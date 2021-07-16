::

  $ . $TESTDIR/Setup


::

  $ test-lex '42\n'
  ^^^_42^U$

  $ test-lex '42.69\n'
  ^^^_42.69^U$

  $ test-lex '"  some  text  "\n'
  ^^^_"  some  text  "^U$

  $ test-lex '&HFF\n'
  ^^^_&HFF^U$


  $ test-lex '&HFF&\n'
  ^^^_&HFF&^U$
