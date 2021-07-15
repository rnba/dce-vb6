::

  $ . $TESTDIR/Setup


::

  $ dce-fmt <<\EOF
  > Dim x As Long
  > EOF
  Dim x As Long


::

  $ dce-fmt <<\EOF
  > Private rs As ADODB.Recordset
  > EOF
  Private rs As ADODB.Recordset


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


hex (short)::

  $ dce-fmt <<\EOF
  > x = &HFF00
  > EOF
  x = &HFF00


hex (long)::

  $ dce-fmt <<\EOF
  > x = &HFF00&
  > EOF
  x = &HFF00&


arithmetic::

  $ dce-fmt <<\EOF
  > x + 10
  > x - 10
  > x * 10
  > x / 10
  > x \ 10
  > EOF
  x + 10
  x - 10
  x * 10
  x / 10
  x \ 10


comparisons::

  $ dce-fmt <<\EOF
  > x < 10
  > x > 10
  > x <= 10
  > x >= 10
  > EOF
  x < 10
  x > 10
  x <= 10
  x >= 10


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


::

  $ dce-fmt <<\EOF
  > s = String(10, " ")
  > EOF
  s = String(10, " ")


::

  $ dce-fmt <<\EOF
  > Debug.Print s1; " = "; s2
  > EOF
  Debug.Print s1; " = "; s2

::

  $ dce-fmt <<\EOF
  > f ( ( 10 + x ) * 2 ) )
  > EOF
  f((10 + x) * 2))
