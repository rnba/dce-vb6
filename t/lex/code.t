::

  $ . $TESTROOT/Setup


::

  $ test-lex 'Dim fubar As Long = 42\n'
  ^^^_Dim^_ ^_fubar^_ ^_As^_ ^_Long^_ ^_=^_ ^_42^U$

  $ test-lex 'Dim snafu As String = "  spaces around  "\n'
  ^^^_Dim^_ ^_snafu^_ ^_As^_ ^_String^_ ^_=^_ ^_"  spaces around  "^U$

  $ test-lex '#If 42'
  ^^^_#If^_ ^_42^U (no-eol)

  $ test-lex 'Dim _\nfubar _\n  As Long\n  = 42\n'
  ^^^_Dim^_ ^__^U$
  ^^^_fubar^_ ^__^U$
  ^^^_  ^_As^_ ^_Long^U$
  ^^^_  ^_=^_ ^_42^U$
