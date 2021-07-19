::

  $ . $TESTDIR/Setup

  $ cp -r $TESTDIR/Fixtures/a/foo.bas bar.bas


::

  $ dce-delete-def
  multisubstitute: fatal: file not set
  [100]

  $ file=foo.bas dce-delete-def
  multisubstitute: fatal: t not set
  [100]

  $ file=foo.bas t=sub dce-delete-def
  multisubstitute: fatal: n not set
  [100]

  $ file=foo.bas t=sub n=s dce-delete-def
  sed: can't read foo.bas: No such file or directory
  [2]
