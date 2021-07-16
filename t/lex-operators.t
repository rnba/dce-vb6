::

  $ . $TESTDIR/Setup


infix operators::

  $ test-lex '+\n'
  ^^^_+^U$

  $ test-lex '-\n'
  ^^^_-^U$

  $ test-lex '*\n'
  ^^^_*^U$

  $ test-lex '/\n'
  ^^^_/^U$

  $ test-lex '\\\n'
  ^^^_\^U$

  $ test-lex '^\n'
  ^^^_^^U$

  $ test-lex '<\n'
  ^^^_<^U$

  $ test-lex '>\n'
  ^^^_>^U$

  $ test-lex '<=\n'
  ^^^_<=^U$

  $ test-lex '>=\n'
  ^^^_>=^U$

  $ test-lex '&\n'
  ^^^_&^U$
