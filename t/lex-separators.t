::

  $ . $TESTDIR/Setup


::

  $ test-lex ':\n'
  ^^^_:^U$

::

  $ test-lex ',\n'
  ^^^_,^U$

  $ test-lex ',,\n'
  ^^^_,^_,^U$

::

  $ test-lex '((\n'
  ^^^_(^_(^U$

  $ test-lex '))\n'
  ^^^_)^_)^U$

::

  $ test-lex ';\n'
  ^^^_;^U$
