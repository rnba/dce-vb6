::

  $ . $TESTDIR/Setup

  $ cp -r $TESTDIR/Fixtures/a .
  $ setup_repo .


::

  $ dce-vcs-comment-git
  execlineb: fatal: too few arguments: expecting at least 1 but got 0
  [100]

  $ echo >> a/foo.bas
  $ dce-vcs-comment-git a/foo.bas true

  $ git log
  commit 3324b9858ccf66368afcf294bb85e54c0b17c760
  Author: Roflmao Snafubar <rs@example.org>
  Date:   Sun Feb 2 20:20:20 2020 +0000
  
      a/foo.bas: drop obsolete VCS comment
  
  commit f824b0921b12fc7396f6d22cff16dfb727db9b02
  Author: Roflmao Snafubar <rs@example.org>
  Date:   Sun Feb 2 20:20:20 2020 +0000
  
      init
