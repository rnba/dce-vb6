::

  $ . $TESTROOT/Setup

  $ cp -r $TESTROOT/Fixtures/a/foo.bas .


::

  $ file=foo.bas t=dfun n=fnat12 dce-delete-def

  $ diff_files $TESTROOT/Fixtures/a/foo.bas foo.bas
  --- Fixtures/a/foo.bas
  +++ foo.bas
  @@ -22,10 +22,6 @@
   Private Declare Function fnat11 Lib "haw.dll" (x As Long) As Long
   ' snat11
   Private Declare Sub snat11 Lib "haw.dll" (x As Long)
  -Private Declare Function fnat12 Lib "haw.dll" _
  -  Alias "asdf" (ByVal s As String, _
  -  ByVal t As String) _
  -  As Long
   Public Declare Function _
     fnat21 Lib "hem.dll" (x As Long) As Long
   
  [1]

