::

  $ . $TESTROOT/Setup

  $ cp -r $TESTROOT/Fixtures/vcs-comment/*.bas .


no argument -> complaint::

  $ ! dce-vcs-comment-file -i 2>stderr
  $ cat stderr
  * no input files (glob)


-i changes the file:

  $ dce-vcs-comment-file -i present.bas

  $ cat present.bas
  ' this stays in
  Attribute VB_Name = "present"
  
  ' other comment 1
  ' other comment 2
  Dim fubar As String
  ' still other comment


no VCS comment, no action::

  $ dce-vcs-comment-file -i absent.bas

  $ cat absent.bas
  ' this stays in
  Attribute VB_Name = "absent"
  
  ' *******
  ' absent.bas
  '
  
  ' other comment 1
  ' other comment 2
  Dim fubar As String
  ' still other comment

