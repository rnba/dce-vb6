::

  $ . $TESTDIR/Setup

  $ cp -r $TESTDIR/Fixtures/vcs-comment/*.bas .


no argument, no action::

  $ dce-vcs-comment-file


result goes to stdout::

  $ dce-vcs-comment-file present.bas
  ' this stays in
  Attribute VB_Name = "present"
  
  ' other comment 1
  ' other comment 2
  Dim fubar As String
  ' still other comment


leaves $1 unchanged::

  $ diff_files $TESTDIR/Fixtures/vcs-comment/present.bas present.bas


no VCS comment, no action::

  $ dce-vcs-comment-file absent.bas
  ' this stays in
  Attribute VB_Name = "absent"
  
  ' *******
  ' absent.bas
  '
  
  ' other comment 1
  ' other comment 2
  Dim fubar As String
  ' still other comment
