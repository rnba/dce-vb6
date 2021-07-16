::

  $ . $TESTDIR/Setup


at the start of line::

  $ test-lex "' this is a comment"
  ^^^_' this is a comment^U (no-eol)

  $ test-lex \'' this is a comment\n'
  ^^^_' this is a comment^U$

  $ test-lex 'Rem this is a comment'
  ^^^_Rem this is a comment^U (no-eol)

  $ test-lex 'Rem this is a comment\n'
  ^^^_Rem this is a comment^U$
