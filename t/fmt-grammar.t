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


infix operators::

  $ dce-fmt <<\EOF
  > x + 10
  > x - 10
  > x * 10
  > x / 10
  > x \ 10
  > x ^ 10
  > 
  > x < 10
  > x > 10
  > x <= 10
  > x >= 10
  > 
  > x & y
  > x & "  hello  "
  > "  hello  " & "  goodbye  "
  > EOF
  x + 10
  x - 10
  x * 10
  x / 10
  x \ 10
  x ^ 10
  
  x < 10
  x > 10
  x <= 10
  x >= 10
  
  x & y
  x & "  hello  "
  "  hello  " & "  goodbye  "


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
  > Call db.execute(  "proc"  , arg )
  > EOF
  Call db.execute("proc", arg)


::

  $ dce-fmt <<\EOF
  > RaiseEvent Error( E.Number , E.Description )
  > EOF
  RaiseEvent Error(E.Number, E.Description)


::

  $ dce-fmt <<\EOF
  > f ( x , , 10 )
  > EOF
  f(x, , 10)


::

  $ dce-fmt <<\EOF
  > s = f(  "   "   )
  > EOF
  s = f("   ")


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
  > Open fn For Output As #p
  > Print #p, str
  > EOF
  Open fn For Output As #p
  Print #p, str


::

  $ dce-fmt <<\EOF
  > f ( ( 10 + x ) * 2 ) )
  > EOF
  f((10 + x) * 2))
