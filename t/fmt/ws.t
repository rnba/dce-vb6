setup::

  $ . $TESTROOT/Setup


trivial::

  $ cat > trivial.bas <<\EOF
  > Const a As Long = 42
  > Public Const b As Long = 42
  > Private Const c As Long = 69
  > EOF

  $ dce-fmt trivial.bas
  Const a As Long = 42
  Public Const b As Long = 42
  Private Const c As Long = 69


normalizes ws::

  $ cat > ws.bas <<\EOF
  >   Const   a    As   Long   =   42
  > EOF

  $ sed -i 's/$/  /' ws.bas

  $ dce-fmt ws.bas
  Const a As Long = 42
