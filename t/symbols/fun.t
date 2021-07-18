::

  $ . $TESTROOT/Setup


trivial::

  $ cat > trivial.bas <<\EOF
  > Function f1(s As String) As Long
  >   f1 = 42
  > End Function
  > 
  > Private Function f2(s As String) As Long
  >   f2 = 69
  > End Function
  > EOF

  $ dce-symbols trivial.bas
  1 fun f1
  1 fun f2


multiline::

  $ cat > multiline.bas <<\EOF
  > Function _
  >   f1(s As String, _
  >      n As Long _
  >   ) As Long
  >   f1 = 42
  > End _
  > Function
  > 
  > Private _
  > Function _
  > f2(s As String) As Long
  >   f2 = 69
  > End _
  > Function
  > EOF

  $ dce-symbols multiline.bas
  1 fun f1
  1 fun f2
