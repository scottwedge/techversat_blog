:title: More on XMLRPC
:id: 1389
:categories: Tutorials

More on XMLRPC
==============

In case I forget... this is what I did to find parent_id's for pages I want to
upload. Parent_id's are necessary if you have wordpress Pages that are nested.
Navigation menu's use it, and your pages will be inevitably be grouped into logical
classifications.


Inspecting Posts from Python Commandline
----------------------------------------

Here are the steps in Python::

  # load the library and initialize the lib
  >>> import wordpresslib as wp
  >>> c = wp.WordPressClient('http://yourwpsite/xmlrpc.php', 'admin','blah')

  # here, xmlrpc ServerProxy is stored in c._server
  >>> c._server
  <ServerProxy for www.techversat.com/xmlrpc.php>

  # run the barebones xmlrpc call
  >>> posts = c._server.wp.getPosts(0,'admin','blah',{'post_type':'page'})

  # inspect the post objects that returned
  >>> [p['post_title'] for p in posts]
  ['test', 'Shipping and Return', 'Contact Us', 'LEDI Tutorial',
    'LEDI', 'FDTI Tutorial', 'FDTI Breakout Board', 'Terms of Use', 'Projects', 'Services']
  >>> [p['post_parent'] for p in posts]
  ['0', '0', '668', '1022', '2', '1013', '2', '0', '0', '0']
  >>> [p['post_title'] for p in posts]
  ['test', 'Shipping and Return', 'Contact Us', 'LEDI Tutorial', 'LEDI',
    'FDTI Tutorial', 'FDTI Breakout Board', 'Terms of Use', 'Projects', 'Services']



Testing "Page" Post
-------------------

Now we can test posting a `Page` on our Wordpress::

  >>> content = {
    'post_type': 'page',
    'post_content': 'nada much',
    'post_parent': 1022,
    'ping_status': 'closed',
    'post_title': 'testing from python'}

  # test
  >>> c._server.wp.newPost(0,'admin','blah',content) 
  '1386'

  # try edit
  >>> c._server.wp.editPost(0,'admin','blah',1386,content)
  True
