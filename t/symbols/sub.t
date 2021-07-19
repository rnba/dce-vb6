::

  $ . $TESTROOT/Setup


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

  $ dce-lex trivial.bas | dce-comments -e boiled | dce-symbols
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

  $ dce-lex multiline.bas | dce-comments -e boiled | dce-symbols
  1 sub s1
  1 sub s2
