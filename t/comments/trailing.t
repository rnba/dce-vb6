::

  $ . $TESTROOT/Setup

  $ cp -r $TESTROOT/Fixtures/comments/trailing.bas .


::

  $ dce-comments trailing.bas > result

  $ sed 's/$/<$>/' result
  a = 0<$>
  b = "a string literal..."<$>
  c = "is not a 'comment'!"<$>
  html = Replace(s, "'", "&apos;")<$>
  lessons("I'm", "You're", "We're")<$>
  <$>
    a = 0<$>
    b = "a string literal..."<$>
    c = "is not a 'comment'!"<$>
    html = Replace(s, "'", "&apos;")<$>
    lessons("I'm", "You're", "We're")<$>

::

  $ dce-comments -i trailing.bas
  $ sed 's/$/<$>/' trailing.bas
  a = 0<$>
  b = "a string literal..."<$>
  c = "is not a 'comment'!"<$>
  html = Replace(s, "'", "&apos;")<$>
  lessons("I'm", "You're", "We're")<$>
  <$>
    a = 0<$>
    b = "a string literal..."<$>
    c = "is not a 'comment'!"<$>
    html = Replace(s, "'", "&apos;")<$>
    lessons("I'm", "You're", "We're")<$>
