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
  commit f1c88526a39420607902a2a4d1d42114bf5349c3
  Author: Roflmao Snafubar <rs@example.org>
  Date:   Sun Feb 2 20:20:20 2020 +0000
  
      a/foo.bas: drop obsolete VCS comment
  
  commit 645a35513ae08a87496ea1d937e32cf5028a95bd
  Author: Roflmao Snafubar <rs@example.org>
  Date:   Sun Feb 2 20:20:20 2020 +0000
  
      init
