:title: Using reStructuredText for Documents
:id: 1135

Motivation
==========

I do most of my text manipulation in vim. This includes both writing
documents and writing code. It's cumbersome for me to use windows-based
editors, let alone use Wordpress WYSWYG editors from a browser.
I'd rather keep things in nicely organized text files. It would be
best to write all my documents in a structured format, which can then
be easily translated to other formats such as HTML, Latex, PDF, etc..

Enter reStructuredText.
reStructuredText is the main documentation framework for Python, and it
converts readable marked-up text documents into myriad of formats.
The main engine behind this is Python's docutils.

It's also important for me to be able to highlight syntax in my 
documents. However, getting it working was the most tricky part.


Setting It Up
-------------

Getting everything setup required some work. I mainly wanted to:
  
* Create documents with highlighted code snippets
* Generate quality pdf's


Step 1: Install Necessary Packages
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The latest version of Docutils should support syntax highlighting via *code*
directive. However, I didn't like their default highlight colors. We can
change that after we install some packages.

First download the source to get the latest versions of these packages:

* Latest Python 2.x
* Docutils http://docutils.sourceforge.net/
* Pygments http://pygments.org/download/
* Rst2pdf  http://rst2pdf.ralsina.com.ar/

Untar them and run in each of their directories:

.. code:: sh

  cd <untarred_dir>
  sudo python setup.py install


Step 2: Generate Pygment StyleSheet
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The code block in your RST document will look something like this::

  .. code:: python
    import os
    print "hello world" 

Which will look like:

.. code:: python
  :number-lines:

  import os
  print "hello world" 


Now, if you don't care much about syntax highlight colors generated, you can
skip this step. But if you want to modify the colors, read on.

Generate the stylesheet:

.. code:: sh

  pygmentize -S default -f html > mystyle.css

This command generates style components that will be sprinkled in the 
processed html document. You will have to tell rst2html that you are
using the 'short' highlight format, which is the names that Pygments
use for highlights.

To make things a bit more confusing, ``rst2pdf`` uses a different,
non-standard directive to do syntax highlighting. For more info,
refer to this `link <http://rst2pdf.ralsina.com.ar/handbook.html#syntax-highlighting>`_.


Step 3: Convert the RST doc
~~~~~~~~~~~~~~~~~~~~~~~~~~~

You first need to find where the default html styles are located.
In addition to the html stylesheet, You will supply an additional stylesheet
to be used for syntax highlighting.

Here, the argument `short` denotes that it wants pygment's short naming
convention for css classes. Also notice that we are supplying comma 
separated list of css files, where `mystyle.css` exists in the same
working directory as our .rst file.

.. rst2html.py --syntax-highlight=short --stylesheet=/usr/local/lib/python2.7/dist-packages/docutils/writers/html4css1/html4css1.css,mystyle.css howto_rst2html.rst page.html
.. code:: sh

  rst2html.py --syntax-highlight=short \
              --stylesheet=/usr/local/lib/python2.7/dist-packages/docutils/writers/html4css1/html4css1.css,mystyle.css \
              howto_rst2html.rst page.html

In order to generate a PDF version:


.. code:: sh

  rst2pdf -o page.pdf howto_rst2html.rst


Going Further
-------------

Here are some resources to get you started on reStructuredText:

#. Official doc: http://docutils.sourceforge.net/docs/user/rst/quickstart.html
#. `Good Primer <http://sphinx.pocoo.org/rest.html>`_
#. A GoodPost_
#. Nice cheatsheet: http://ubuntuone.com/1M7C5fdbLkggF7ptoUvTq8
#. rst2pdf doc: http://rst2pdf.ralsina.com.ar/handbook.html

.. _GoodPost: http://www.codekoala.com/blog/2008/syntax-highlighting-rest-pygments-and-django/


.. for getting image in the page
.. .. image:: imgs/whokilledtux.png
