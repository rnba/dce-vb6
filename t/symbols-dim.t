::

  $ . $TESTDIR/Setup

  $ cat > x.bas <<\EOF
  > Dim a As Long = 42
  > Public Dim b As Long = 42
  > Static c As Long = 69
  > 
  > Rem Dim p As Long = 42
  >   Rem Dim q As Long = 69
  > ' Dim r As Long = 42
  >   ' Dim s As Long = 69
  > EOF

::

  $ dce-symbols x.bas
  5 var a
  5 var b
  5 var c
