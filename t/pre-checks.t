::

  $ . $TESTROOT/Setup


$file does not exist::

  $ file=nonexistent dce-pre-checks
  dce-vb6: not a file: nonexistent
  [1]


$file is not a file::

  $ mkdir not-a-file
  $ file=not-a-file dce-pre-checks
  dce-vb6: not a file: not-a-file
  [1]


$PWD is not a repository root::

  $ touch stuff.bas
  $ file=stuff.bas dce-pre-checks
  dce-vb6: not a directory: .git
  [1]


$file has changes in the working tree::

  $ setup_repo .
  $ echo foo > stuff.bas
  $ file=stuff.bas dce-pre-checks
  dce-vb6: stuff.bas has changes in the worktree
  [1]


$file has changes in the working tree::

  $ git add -u
  $ file=stuff.bas dce-pre-checks
  dce-vb6: stuff.bas has changes in the index
  [2]


$file is ok.  dce-pre-checks will exec its args::

  $ git commit -qm ok
  $ file=stuff.bas dce-pre-checks sh -c 'echo ok; exit 42'
  ok
  [42]


$file is ok, nothing to exec is not a problem::

  $ file=stuff.bas dce-pre-checks
