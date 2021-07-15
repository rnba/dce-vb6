::

  $ . $TESTDIR/Setup


::

  $ dce-fmt <<\EOF
  > Dim x As Long
  > EOF
  Dim x As Long

::

  $ dce-fmt <<\EOF
  > Dim xs ( 10 ) As Long
  > EOF
  Dim xs(10) As Long

::

  $ dce-fmt <<\EOF
  > x = 42
  > EOF
  x = 42


::

  $ dce-fmt <<\EOF
  > x + 10
  > EOF
  x + 10


::

  $ dce-fmt <<\EOF
  > x , 10
  > EOF
  x, 10


::

  $ dce-fmt <<\EOF
  > f ( x , 10 )
  > EOF
  f(x, 10)


::

  $ dce-fmt <<\EOF
  > f ( x , , 10 )
  > EOF
  f(x, , 10)
