::

  $ . $TESTROOT/Setup

  $ cat > x.bas <<\EOF
  > Attribute VB_Name =  "roflmao"
  > Attribute VB_GlobalNameSpace = False
  > EOF

  $ dce-lex x.bas | dce-comments -e boiled | dce-symbols
