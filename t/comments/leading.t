::

  $ . $TESTROOT/Setup

  $ cp -r $TESTROOT/Fixtures/comments/leading.bas .


::

  $ dce-comments leading.bas > result

  $ cat -A result
  $
  $
  stuff()$
  $
  $
  $
  $
  x = "not a comment"$
