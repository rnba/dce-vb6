::

  $ . $TESTDIR/Setup

  $ cp -r $TESTDIR/Fixtures/comments/none.bas .


::

  $ dce-comments none.bas > result

  $ cat -A result
  a = 0$
  b = "a string literal..."$
  c = "is not a 'comment'!"$
  sql("SELECT 'fubar' AS snafu")$
  html = Replace(s, "'", "&apos;")$
  lessons("I'm", "You're", "We're")$
  $
    a = 0$
    b = "a string literal..."$
    c = "is not a 'comment'!"$
    sql("SELECT 'fubar' AS snafu")$
    html = Replace(s, "'", "&apos;")$
    lessons("I'm", "You're", "We're")$

  $ diff -u none.bas result
