::

  $ . $TESTDIR/Setup

  $ cp -r $TESTDIR/Fixtures/comments/leading.bas .


::

  $ dce-lex leading.bas | dce-comments > result

  $ cat -A result
  $
  $
  stuff()$
  $
  $
  $
  $
  x = "not a comment"$
