setup::

  $ . $TESTDIR/Setup


empty input::

  $ test-lex ''


empty line(s)::

  $ test-lex '\n'
  ^^^U$

  $ test-lex '\n\n'
  ^^^U$
  ^^^U$

unrecognized input (failure):

  $ test-lex '{\n'
  dce-lex: this not tokenized:
  {
  ^^^U{$
  [1]

  $ test-lex '{\n{\n'
  dce-lex: this not tokenized:
  {
  ^^^U{$
  [1]
