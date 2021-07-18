::

  $ . $TESTDIR/Setup


trivial::

  $ cat > trivial.bas <<\EOF
  > Sub s1(o As String)
  >   x = len(o)
  > End Sub
  > 
  > Private Sub s2(s As String)
  >   x = len(o)
  > End Sub
  > EOF

  $ dce-symbols trivial.bas
  1 sub s1
  1 sub s2


multiline::

  $ cat > multiline.bas <<\EOF
  > Sub _
  > s1(o As _
  >    String)
  >   x = len(o)
  > End Sub
  > 
  > Private _
  >  Sub _
  > s2(s As String)
  >   x = len(o)
  >  End _
  >   Sub
  > EOF

  $ dce-symbols multiline.bas
  1 sub s1
  1 sub s2
