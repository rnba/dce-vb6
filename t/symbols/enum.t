::

  $ . $TESTROOT/Setup

  $ cat > x.bas <<\EOF
  > Enum Choice
  >   Yes = 0
  >   No = 1
  > End Enum
  > 
  > Private Enum RGB
  >   Red = 0xff0000
  >   Green = 0x00ff00
  >   Blue = 0x0000ff
  > End Enum
  > EOF

::

  $ dce-lex x.bas | dce-comments -e boiled | dce-symbols
  2 enum Choice
  2 enum RGB
