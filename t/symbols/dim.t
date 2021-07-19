::

  $ . $TESTROOT/Setup


comments::

  $ cat > x.bas <<\EOF
  > Rem Dim p As Long = 42
  >   Rem Dim q As Long = 69
  > ' Dim r As Long = 42
  >   ' Dim s As Long = 69
  > EOF

  $ dce-lex x.bas | dce-comments -e boiled | dce-symbols


trivial::

  $ cat > x.bas <<\EOF
  > Dim a As Long = 42
  > Public Dim b As Long = 42
  > Static c As Long = 69
  > EOF

  $ dce-lex x.bas | dce-comments -e boiled | dce-symbols
  5 var a
  5 var b
  5 var c


multiline::

  $ cat > x.bas <<\EOF
  > Dim _
  > a As Long = 42
  > Public Dim _
  >  b As Long = 42
  > Static _
  > c _
  > As Long = 69
  > EOF

  $ dce-lex x.bas | dce-comments -e boiled | dce-symbols
  5 var a
  5 var b
  5 var c
