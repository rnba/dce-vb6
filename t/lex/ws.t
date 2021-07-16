::

  $ . $TESTROOT/Setup


whitespace::

  $ test-lex '    \n'
  ^^^_    ^U$

  $ test-lex '\t    \n'
  ^^^_^I    ^U$

  $ test-lex '  \t\t  \t\n'
  ^^^_  ^I^I  ^I^U$
