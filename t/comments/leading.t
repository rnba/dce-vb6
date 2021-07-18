::

  $ . $TESTROOT/Setup

  $ cp -r $TESTROOT/Fixtures/comments/leading.bas .


::

  $ dce-comments leading.bas > result

  $ sed 's/$/<$>/' result
  <$>
  <$>
  stuff()<$>
  <$>
  <$>
  <$>
  <$>
  x = "not a comment"<$>
