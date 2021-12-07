::

  $ . $TESTROOT/Setup

  $ cp -r $TESTROOT/Fixtures/a/foo.bas .


::

  $ file=foo.bas t=plet n=p2 dce-delete-def

  $ diff_files $TESTROOT/Fixtures/a/foo.bas foo.bas
  --- Fixtures/a/foo.bas
  +++ foo.bas
  @@ -78,10 +78,6 @@
     p1 = 42
   End Property
   
  -Property Let p2() As String
  -  p2 = "..."
  -End Property
  -
   Property Set p3(Long v)
     ' ...
   End Property
  [1]
