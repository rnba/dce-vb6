::

  $ . $TESTROOT/Setup


qualified ids::

  $ test-lex 'foo\n'
  ^^^_foo^U$

  $ test-lex 'foo.bar\n'
  ^^^_foo.bar^U$

  $ test-lex 'foo.bar.baz\n'
  ^^^_foo.bar.baz^U$

  $ test-lex '.foo\n'
  ^^^_.foo^U$

  $ test-lex '.foo.bar\n'
  ^^^_.foo.bar^U$

  $ test-lex '.foo.bar.baz\n'
  ^^^_.foo.bar.baz^U$
