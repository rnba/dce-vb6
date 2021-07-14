::

  $ . $TESTDIR/Setup


::

  $ cat > x.bas <<\EOF
  > Function f1(s As String) As Long
  >   f1 = 42
  > End Function
  > 
  > Private Function f2(s As String) As Long
  >   f2 = 69
  > End Function
  > EOF

  $ dce-symbols x.bas
  1 fun f1
  1 fun f2
