::

  $ . $TESTDIR/Setup


::

  $ dce-lex <<\EOF | dce-comments -e boiled > out
  >   Dim iAm As Long ' as i remember
  >   Public   _
  >     Function _
  >     f(s As String) _
  >       As Long      ' let's see
  >     f = Len$(s)
  >   End Function
  > EOF

  $ cat -A out
  ^^^_Dim^_iAm^_As^_Long^U$
  ^^^_Public^_Function^_f^_(^_s^_As^_String^_)^_As^_Long^U$
  ^^^_f^_=^_Len$^_(^_s^_)^U$
  ^^^_End^_Function^U$
