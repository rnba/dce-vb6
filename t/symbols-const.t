::

  $ . $TESTDIR/Setup


comments::

that'd be dumb.  don't shoot yourself
in the foot, put dce-comments between
dce-lex and dce-symbols.

trivial::

  $ cat > trivial.bas <<\EOF
  > Const a As Long = 42
  > Public Const b As Long = 42
  > Private Const c As Long = 69
  > EOF

  $ dce-lex trivial.bas | dce-comments -e boiled | dce-symbols
  5 const a
  5 const b
  5 const c


multiline::

  $ cat > multiline.bas <<\EOF
  > Const _
  >   a As Long = 42
  > 
  > Public Const _
  > b As Long = 42
  > 
  > Private _
  > Const _
  > c _
  > As Long = 69
  > EOF

  $ dce-lex multiline.bas | dce-comments -e boiled | dce-symbols
  5 const a
  5 const b
  5 const c
