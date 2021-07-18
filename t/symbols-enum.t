::

  $ . $TESTDIR/Setup

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

  $ dce-symbols x.bas
  2 enum Choice
  2 enum RGB
