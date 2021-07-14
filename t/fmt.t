::

  $ . $TESTDIR/Setup


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
  >   Dim  s   As String   = "  haha  "
  > EOF

  $ sed -i 's/$/  /' ws.bas

  $ dce-fmt ws.bas | cat -A
  Const a As Long = 42$
  Dim s As String = "  haha  "$


joins _ lines::

  $ cat > cont.bas <<\EOF
  > Const _
  >   a As Long = 42
  > 
  > Public   Const   _
  > b   As Long =   42
  > 
  > Private _
  >   Const _
  >   c _
  >   As Long    =    69
  > EOF

  $ dce-fmt cont.bas
  Const a As Long = 42
  
  Public Const b As Long = 42
  
  Private Const c As Long = 69
