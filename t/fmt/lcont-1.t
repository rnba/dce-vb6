dce-fmt concats line continuations
==================================

setup::

  $ . $TESTROOT/Setup


test::

  $ cat > cont.bas <<\EOF
  > Const _
  >   a As Long = 42
  > 
  > Public   Const   _
  > b   As Long =   42
  > 
  > Private _
  >   _
  >   Const _
  >   c _
  >   As Long    =    69
  > EOF

  $ dce-fmt cont.bas
  Const a As Long = 42
  
  Public Const b As Long = 42
  
  Private Const c As Long = 69
