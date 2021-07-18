::

  $ . $TESTROOT/Setup

  $ cp -r $TESTROOT/Fixtures/a .
  $ setup_repo .


::

  $ dce-vcs-comment-git
  execlineb: fatal: too few arguments: expecting at least 1 but got 0
  [100]

  $ echo >> a/foo.bas
  $ dce-vcs-comment-git a/foo.bas true

  $ git log
  commit ca9637be317d7ad49bd56c6c926acfef7492f156
  Author: Roflmao Snafubar <rs@example.org>
  Date:   Sun Feb 2 20:20:20 2020 +0000
  
      a/foo.bas: drop obsolete VCS comment
  
  commit 576414cbba4f2305958680926b60a05637c6c7ed
  Author: Roflmao Snafubar <rs@example.org>
  Date:   Sun Feb 2 20:20:20 2020 +0000
  
      init
