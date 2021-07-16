setup::

  $ . $TESTROOT/Setup


::

  $ test-lex '#Const\n'
  ^^^_#Const^U$

  $ test-lex '#If\n'
  ^^^_#If^U$

  $ test-lex '#Else\n'
  ^^^_#Else^U$

  $ test-lex '#ElseIf\n'
  ^^^_#ElseIf^U$
