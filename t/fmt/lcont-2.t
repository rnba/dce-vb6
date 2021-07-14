setup::

  $ . $TESTROOT/Setup


test::

  $ cat > proto.bas <<\EOF
  > Private  _
  > Function _
  >  f( _
  >    ByVal j As Long _
  >  , ByVal k As Long _
  >  ) As String
  > EOF

  $ dce-fmt proto.bas
  Private Function f(ByVal j As Long, ByVal k As Long) As String
