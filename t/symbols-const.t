::

  $ . $TESTDIR/Setup


comments::

  $ cat > x.bas <<\EOF
  > Rem Const p As Long = 42
  >   Rem Const q As Long = 69
  > ' Const r As Long = 42
  >   ' Const s As Long = 69
  > EOF

  $ dce-symbols x.bas


trivial::

  $ cat > x.bas <<\EOF
  > Const a As Long = 42
  > Public Const b As Long = 42
  > Private Const c As Long = 69
  > EOF

  $ dce-symbols x.bas
  5 const a
  5 const b
  5 const c


multiline::

  $ cat > x.bas <<\EOF
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

  $ dce-symbols x.bas
  5 const a
  5 const b
  5 const c
