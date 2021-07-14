::

  $ . $TESTDIR/Setup


::

  $ cat > x.bas <<\EOF
  > Sub s1(o As String)
  >   x = len(o)
  > End Sub
  > 
  > Private Sub s2(s As String)
  >   x = len(o)
  > End Sub
  > EOF

  $ dce-symbols x.bas
  1 sub s1
  1 sub s2
