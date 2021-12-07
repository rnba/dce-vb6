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
  commit 645309ebe8ad80cf829b0bf69f0b3aee2e7788e6
  Author: Roflmao Snafubar <rs@example.org>
  Date:   Sun Feb 2 20:20:20 2020 +0000
  
      a/foo.bas: drop obsolete VCS comment
  
  commit d0c867ecb10a24520a74b16ec6c6833d9bcb9b32
  Author: Roflmao Snafubar <rs@example.org>
  Date:   Sun Feb 2 20:20:20 2020 +0000
  
      init
