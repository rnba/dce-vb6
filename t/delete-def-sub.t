::

  $ . $TESTDIR/Setup


  $ cp -r $TESTDIR/Fixtures/a/foo.bas .


::

  $ file=foo.bas t=Sub n=s3 dce-delete-def

  $ diff_files $TESTDIR/Fixtures/a/foo.bas foo.bas
  --- Fixtures/a/foo.bas
  +++ foo.bas
  @@ -65,13 +65,6 @@
     f2 = 42
   End Function
   
  -' s3 (comment mentions f2)
  -Private Sub s3()
  -  Dim x As Long
  -  Dim ok As choice
  -  x = fnat11(C)
  -End Sub
  -
   Property Get p1() As Long
     p1 = 42
   End Property
  [1]
