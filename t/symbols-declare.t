::

  $ . $TESTDIR/Setup

  $ cat > x.bas <<\EOF
  > Declare Sub s1 Lib "x.dll" (i As Long)
  > Private Declare Sub s2 Lib "x.dll" (i As Long)
  > Declare Sub s3 Lib "x.dll" Alias "n" (i As Long)
  > Private Declare Sub s4 Lib "x.dll" Alias "n" (i As Long)
  > 
  > Declare Function f1 Lib "x.dll" (i As Long) As Long
  > Private Declare Function f2 Lib "x.dll" (i As Long) As Long
  > Declare Function f3 Lib "x.dll" Alias "n" (i As Long) As Long
  > Private Declare Function f4 Lib "x.dll" Alias "n" (i As Long) As Long
  > EOF

  $ dce-lex x.bas | dce-comments -e boiled | dce-symbols
  4 dsub s1
  4 dsub s2
  4 dsub s3
  4 dsub s4
  4 dfun f1
  4 dfun f2
  4 dfun f3
  4 dfun f4
