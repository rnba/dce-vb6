::

  $ . $TESTDIR/Setup

  $ cp -r $TESTDIR/Fixtures/comments/trailing.bas .


::

  $ dce-lex trailing.bas | dce-comments > result

  $ cat -A result
  a = 0$
  b = "a string literal..."$
  c = "is not a 'comment'!"$
  html = Replace(s, "'", "&apos;")$
  lessons("I'm", "You're", "We're")$
  $
    a = 0$
    b = "a string literal..."$
    c = "is not a 'comment'!"$
    html = Replace(s, "'", "&apos;")$
    lessons("I'm", "You're", "We're")$
