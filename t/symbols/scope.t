::

  $ . $TESTROOT/Setup


ignores locals::

  $ cat > scope.bas <<\EOF
  > Const x As Long = 42
  > Sub s()
  > Dim t As String
  > Const y As Long = 69
  > End Sub
  > Dim a As Long = 24
  > b As String = "hola"
  > EOF

  $ dce-symbols scope.bas
  5 const x
  1 sub s
  5 var a
  5 var b
