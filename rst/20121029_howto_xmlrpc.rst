:title: Wordpress Posts Without WYSWYG
:id: 1206
:categories: Tutorials


Wordpress Posts Without WYSWYG
==============================

I dislike drafting my posts on the browser. After years of working primarily in
unix environments, I find myself much more at home with terminal-based
interface rather than GUI's. Besides, I would love to do text editing in vim,
and make my workflow as efficient as possible. Fortunately, I've found the right
set of tools that jives with me.

Now I can keep my texts in reStructuredText format on my local disk, sync-ed with
github. I do all the editing in vim. Better yet, recent version of vim highlights
reStructuredText, as long as you have your file named with .rst extension.

Once I am done editing, I simply run a command to upload the post to my wordpress
site. No frills. Just simple and efficient.


Automating Wordpress Posts with XMLRPC
--------------------------------------

Ideal workflow for me would be to work on the document locally, and post it
to my Wordpress website with a single command. Thanks to XMLRPC, it should be
possible to interact with Wordpress using any programming language.

|autoimg|

Found this `link <http://www.wprecipes.com/post-on-your-wordpress-blog-using-php>`_ on the web
where the author gives you a snippet of PHP code:

.. code:: bash

  function wpPostXMLRPC($title,$body,$rpcurl,$username,
      $password,$category,$keywords='',$encoding='UTF-8')
  {
    $title = htmlentities($title,ENT_NOQUOTES,$encoding);
    $keywords = htmlentities($keywords,ENT_NOQUOTES,
                $encoding);

    $content = array(
        'title'=>$title,
        'description'=>$body,
        'mt_allow_comments'=>0,  // 1 to allow comments
        'mt_allow_pings'=>0,  // 1 to allow trackbacks
        'post_type'=>'post',
        'mt_keywords'=>$keywords,
        'categories'=>array($category)
    );
    $params = array(0,$username,$password,$content,true);
    $request = xmlrpc_encode_request('metaWeblog.newPost',
                $params);
    $ch = curl_init();
    curl_setopt($ch, CURLOPT_POSTFIELDS, $request);
    curl_setopt($ch, CURLOPT_URL, $rpcurl);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
    curl_setopt($ch, CURLOPT_TIMEOUT, 1);
    $results = curl_exec($ch);
    curl_close($ch);
    return $results;
  }

XMLRPC is rather simple. It essentially structures your inputs/data into XML, and
then ships it over to the remote server for processing. Data is sent using HTTP Post,
and the submitted **procedure** is validated against supported list of remote functions.

But the code above is in PHP. I am trying to use reStructuredText for editing my posts
offline, and it uses Python! Quick googling gives me a few libraries I can use for
XMLRPC with Python.

* XMLRPC is part of the core library: http://docs.python.org/2/library/xmlrpclib.html


Someone Must've Already Done It?
--------------------------------

That's good, but even better - looks like people have already written libraries to
interact with Wordpress using XMLPRC:

* `A blog post <http://blog.mafr.de/2008/03/22/using-rst-with-wordpress/>`_
* `One that I decided to use <https://github.com/glasserc/rst2wp>`_ 
* `Another one that looks more recent <https://github.com/maxcutler/python-wordpress-xmlrpc>`_
  This last one has pretty good documentation. The example on the tutorial works fine
  for me: http://python-wordpress-xmlrpc.readthedocs.org/en/latest/overview.html


Testing Things Out
~~~~~~~~~~~~~~~~~~

To test things out, you first need to modify `Settings` in Wordpress under `Writing`
and check the option to use XMLRPC.

I then downloaded the latest source of `python-wordpress-xmlrpc`:

``git clone git://github.com/maxcutler/python-wordpress-xmlrpc.git``

After that, tried running the examples from the python command line.

.. code:: python

  from wordpress_xmlrpc import Client
  from wordpress_xmlrpc.methods import posts

  client = Client('http://mysite.wordpress.com/xmlrpc.php',
                  'username', 'password')
  posts = client.call(posts.GetPosts())
  
  # see what kind of object this is
  help(posts[0])
  # list of fields
  p[3].struct.keys() 
  # get the post_id
  p[3].struct['post_id']

Nice! I can already extract the list of posts.
It was also relatively trivial to test posting a blog entry by following 
`this example <http://python-wordpress-xmlrpc.readthedocs.org/en/latest/overview.html#installation>`_


Not Reinventing the Wheel
~~~~~~~~~~~~~~~~~~~~~~~~~

You can probably put wrappers around this library, but why reinvent the wheel 
if there's something already out there?

Thanks to `glasserc`, most of the useful functionality was already there.
The python project `rst2wp <https://github.com/glasserc/rst2wp>`_  has lots of useful
functionality I wanted:

* keeping track of .rst file with corresponding blog/page post
* detecting image directives and uploading it automatically to Wordpress
* uploaded images are properly linked with the doc
* discarding unnecessary portions of the generated HTML before doing XMLRPC POST

However, it didn't seem to support syntax highlighting with custom css.
I modified it bit, and got it working. It also had minor bug, but `glassrc` was
extremely prompt in responding. The library also relies on an implementation of 
Wordpress xmlrpc, which seems to be `outdated <https://github.com/charlax/wordpresslib>`_.
This **wordpresslib** hasn't been modified in 2yrs... and it wasn't posting Pages (not Posts)
properly.


Modifying a Bit
~~~~~~~~~~~~~~~

To make it work, I had to poke around a bit on the `docutils` structure.
First the structure of the library:

.. code:: bash

  $ find /usr/local/lib/python2.6/dist-packages/docutils \
     -maxdepth 2 -type f | egrep -v "languages|.pyc" \
    | sed -e 's/.*docutils/docutils/'
  docutils/core.py
  docutils/error_reporting.py
  docutils/transforms/references.py
  docutils/transforms/components.py
  docutils/transforms/misc.py
  docutils/transforms/universal.py
  docutils/transforms/peps.py
  docutils/transforms/parts.py
  docutils/transforms/__init__.py
  docutils/transforms/frontmatter.py
  docutils/transforms/writer_aux.py
  docutils/nodes.py
  docutils/statemachine.py
  docutils/parsers/null.py
  docutils/parsers/__init__.py
  docutils/readers/pep.py
  docutils/readers/__init__.py
  docutils/readers/standalone.py
  docutils/readers/doctree.py
  docutils/_string_template_compat.py
  docutils/_compat.py
  docutils/utils/code_analyzer.py
  docutils/utils/__init__.py
  docutils/utils/roman.py
  docutils/utils/punctuation_chars.py
  docutils/io.py
  docutils/urischemes.py
  docutils/__init__.py
  docutils/frontend.py
  docutils/math/math2html.py
  docutils/math/tex2unichar.py
  docutils/math/__init__.py
  docutils/math/unichar2tex.py
  docutils/math/latex2mathml.py
  docutils/examples.py
  docutils/writers/pseudoxml.py
  docutils/writers/null.py
  docutils_xml.py
  docutils/writers/__init__.py
  docutils/writers/manpage.py

Largely, the docutils contain these top-level objects:

* Utils
* Parsers
* Readers
* Writers
* Transforms

Under ``docutils/core.py``, the class **Publisher** puts everything together. 
You just need to supply, at the minimum, the original reStructuredText, and
a writer if you want to output it to a specific format:

.. code:: python

  def publish_parts(source, source_path=None, source_class=io.StringInput,
                  destination_path=None,
                  reader=None, reader_name='standalone',
                  parser=None, parser_name='restructuredtext',
                  writer=None, writer_name='pseudoxml',
                  settings=None, settings_spec=None,
                  settings_overrides=None, config_section=None,
                  enable_exit_status=False):


The **rst2wp** runs this function at the core. 

.. code:: python

   output = core.publish_parts(source=text, writer=writer,
                               reader=reader,
                               settings_overrides={
           'wordpress_instance' : wp,
           'application': self,
           'bibliographic_fields': {
               'categories': categories
               },
           'directive_uris': directive_uris,
           'used_images': used_images,
           # FIXME: probably a nicer way to do this
           'filename': self.filename
           })


In order to make it embed the bits of syntax highlighting .css definitions, I had
to botch it (mainly for testing)

.. code:: python

   output = core.publish_parts(source=text, writer=writer,
                               reader=reader,
                               settings_overrides={
           'wordpress_instance' : wp,
           'application': self,
           'bibliographic_fields': {
               'categories': categories
               },
           'directive_uris': directive_uris,
           'used_images': used_images,
           # FIXME: probably a nicer way to do this
           'filename': self.filename,
           'syntax_highlight' : 'short',
           'stylesheet_path' : '/usr/local/lib/python2.6/dist-packages/ \
                  docutils/writers/html4css1/html4css1.css,./mystyle.css',
           'embed_stylesheet' : 1
           })


Notice I added ``syntax_highlight``, ``stylesheet_path``, and ``embed_stylesheet``. 
These additional config parameters are passed over to ``docutils/writers/html4css1/__init__.py``
when it renders reStructuredText to HTML.

Anyways, I am planning to fork it from `glasserc`'s excellent work thus far, and 
possibly extend it to fit my needs... (will contribute to the project as time permits)

.. |autoimg| image:: http://techversat.com/wp-content/uploads/automation.png
    :uploaded: http://techversat.com/wp-content/uploads/automation.png
    

