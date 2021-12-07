::

  $ . $TESTROOT/Setup

  $ cp -r $TESTROOT/Fixtures/a/foo.bas .


::

  $ file=foo.bas t=fun n=f1 dce-delete-def

  $ diff_files $TESTROOT/Fixtures/a/foo.bas foo.bas
  --- Fixtures/a/foo.bas
  +++ foo.bas
  @@ -52,13 +52,6 @@
       d As Byte
   End Type
   
  -' f1
  -Private Function f1(s As String, _
  -                   Optional ok As Boolean = False) As Long
  -  Dim bs as b4
  -  f1 = 42
  -End Function
  -
   ' f2
   Private Function _
                       f2(s As String, _
  [1]
