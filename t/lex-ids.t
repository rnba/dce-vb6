setup::

  $ . $TESTDIR/Setup


identifiers::

  $ test-lex 'Len\n'
  ^^^_Len^U$

  $ test-lex 'Left$\n'
  ^^^_Left$^U$

file handles::

  $ test-lex '#fnum\n'
  ^^^_#fnum^U$

  $ test-lex '#123\n'
  ^^^_#123^U$
