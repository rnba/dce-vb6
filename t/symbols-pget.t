::

  $ . $TESTDIR/Setup


::

  $ cat > x.bas <<\EOF
  > Property Get p1() As Long
  >   p1 = 42
  > End Property
  > 
  > Private Property Get p2() As Long
  >   p2 = 69
  > End Property
  > EOF

  $ dce-symbols x.bas
  1 pget p1
  1 pget p2
