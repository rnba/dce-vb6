::

  $ . $TESTROOT/Setup

  $ cp -r $TESTROOT/Fixtures/comments/none.bas .


::

  $ dce-lex none.bas | dce-comments -e basic > result

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
