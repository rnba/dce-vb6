::

  $ . $TESTDIR/Setup


comments::

  $ cat > comments.bas <<\EOF
  > Rem Const p As Long = 42
  >   Rem Const q As Long = 69
  > ' Const r As Long = 42
  >   ' Const s As Long = 69
  > EOF

  $ dce-symbols comments.bas


trivial::

  $ cat > trivial.bas <<\EOF
  > Const a As Long = 42
  > Public Const b As Long = 42
  > Private Const c As Long = 69
  > EOF

  $ dce-symbols trivial.bas
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

  $ dce-symbols multiline.bas
  5 const a
  5 const b
  5 const c
