Attribute VB_Name = "foo"
' *******
' foo.bas
'
'$Workfile:: foo.bas    $
'$Archive:: /a/foo.bas                      $
'$Author:: Administ $
'$Modtime:: 1/12/15 9:07p $
'$Date:: 1/12/15 9:07p  $
'$Revision:: 7 $
'$Log:: /a/foo.bas                      $
Rem 
' 78    1/12/15 9:07p Administrator
' Modify f1 function
Rem
' 77    9/07/14 9:42p Administrator
' Adjusted function f2
Rem

Option Explicit

Private Declare Function fnat11 Lib "haw.dll" (x As Long) As Long
' snat11
Private Declare Sub snat11 Lib "haw.dll" (x As Long)
Private Declare Function fnat12 Lib "haw.dll" -
  Alias "asdf" (ByVal s As String, _
  ByVal t As String) _
  As Long
Public Declare Function fnat21 Lib "hem.dll" (x As Long) As Long

Private Const C = 42

Private Enum choice
  Yes = 0
  No = 1
End Enum

Private Enum RGB
  Red = 0xff0000
  Green = 0x00ff00
  Blue = 0x0000ff
End Enum

Private Type b4
    a As Byte
    b As Byte
    c As Byte
    d As Byte
End Type

' f1
Private Function f1(s As String, _
                   Optional ok As Boolean = False) As Long
  Dim bs as b4
  f1 = 42
End Function

' f2
Private Function f2(n As Long) As String
  f2 = "asdf"
  ' dce-vb6 does not perform any kind of semantic analysis
  Exit Function
  Dim x As Long
  x = f1("lol")
End Function

' s3 (comment mentions f2)
Private Sub s3()
  Dim x As Long
  Dim ok As choice
  x = fnat11(C)
End Sub