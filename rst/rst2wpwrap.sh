#!/bin/bash

# config is stored: ~/.config/rst2wp/wordpressrc


if [ $# -lt 1 ]; then
  echo "usage: $0 <rstfile> [upload]"
  # $RSTCMD --help 
  exit 1
fi

RSTFILE=$1
shift;

DOWP=0
if [ "${1}X" != "X" ]; then
  DOWP=1
  shift
fi

# this css combines the default html4css1 and pygmentize css
CSS=../css/mystyle.css

RSTCMD=../bin/rst2wp/rst2wp.py
echo $RSTCMD $RSTFILE
$RSTCMD $RSTFILE -s $CSS $*

#  HTMLOUT=/var/www/droparea/test.html
#  RSTCMD=rst2html.py
#  # /usr/local/lib/python2.6/dist-packages/docutils/writers/html4css1/html4css1.css
#  # my custom css that combins html4css1.css and pygmentize generted syntax css.
#  # CSS="/usr/local/lib/python2.7/dist-packages/docutils/writers/html4css1/mystyle.css"
#
#  echo $RSTCMD --syntax-highlight=short --stylesheet=$CSS $* $RSTFILE $HTMLOUT
#  $RSTCMD --syntax-highlight=short --stylesheet=$CSS $* $RSTFILE $HTMLOUT
#  echo "written to $HTMLOUT"
