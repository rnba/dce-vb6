::

  $ . $TESTROOT/Setup

  $ cat > x.bas <<\EOF
  > Private Type b4
  >     a As Byte
  >     b As Byte
  >     c As Byte
  >     d As Byte
  > End Type
  > 
  > Type OneLong
  >   l As Long
  > End Type
  > EOF

::

  $ dce-lex x.bas | dce-comments -e boiled | dce-symbols
  3 type b4
  3 type OneLong
