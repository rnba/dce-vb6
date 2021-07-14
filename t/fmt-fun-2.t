setup::

  $ . $TESTDIR/Setup


joins _ lines in function definitions::

  $ cat > case2.bas <<\EOF
  > Private  _
  > Function _
  >  f( _
  >    ByVal j As Long _
  >  , ByVal k As Long _
  >  ) As String
  > 
  >    On Error _
  >      Resume Next
  >    
  >    Dim _
  >        length As Long
  >    Dim _
  >    buf As String   *  1024
  > 
  >    length = g( _
  >      j, _
  >      k, _
  >      buf, _
  >      Len(buf))
  > 
  >    f = Left$ (buf, length - 1)
  > 
  >  End _
  >  Function
  > EOF

  $ dce-fmt case2.bas
  Private Function f(ByVal j As Long, ByVal k As Long) As String
  
  On Error Resume Next
  
  Dim length As Long
  Dim buf As String * 1024
  
  length = g(j, k, buf, Len(buf))
  
  f = Left$(buf, length - 1)
  
  End Function
