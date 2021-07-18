::

  $ . $TESTDIR/Setup

  $ cp -r $TESTDIR/Fixtures/comments/leading.bas .


::

  $ dce-lex leading.bas | dce-comments -e basic > result

  $ cat -A result
  $
  $
  stuff()$
  $
  $
  $
  $
  x = "not a comment"$
