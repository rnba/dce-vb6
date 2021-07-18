::

  $ . $TESTROOT/Setup

  $ cp -r $TESTROOT/Fixtures/a/foo.bas .


::

  $ file=foo.bas t=Property n=p2 dce-delete-def

  $ diff_files $TESTROOT/Fixtures/a/foo.bas foo.bas
  --- Fixtures/a/foo.bas
  +++ foo.bas
  @@ -76,10 +76,6 @@
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
