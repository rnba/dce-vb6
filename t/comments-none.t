::

  $ . $TESTDIR/Setup

  $ cp -r $TESTDIR/Fixtures/comments/none.bas .


::

  $ dce-comments none.bas > result

  $ cat result
  a = 0
  b = "a string literal..."
  c = "is not a 'comment'!"
  sql("SELECT 'fubar' AS snafu")
  html = Replace(s, "'", "&apos;")
  lessons("I'm", "You're", "We're")
  
    a = 0
    b = "a string literal..."
    c = "is not a 'comment'!"
    sql("SELECT 'fubar' AS snafu")
    html = Replace(s, "'", "&apos;")
    lessons("I'm", "You're", "We're")

  $ diff -u none.bas result

::

  $ dce-comments -i none.bas

  $ diff_files $TESTDIR/Fixtures/comments/none.bas none.bas