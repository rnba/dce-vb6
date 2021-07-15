setup::

  $ . $TESTDIR/Setup


leaves string literals intact::

  $ cat > ws1.bas <<\EOF
  >   Dim  s   As String   = "    haha    "
  > EOF

  $ dce-fmt ws1.bas
  Dim s As String = "    haha    "


  $ cat > ws2.bas <<\EOF
  >   len("   omg   wtf  ")
  > EOF

  $ dce-fmt ws2.bas
  len("   omg   wtf  ")
