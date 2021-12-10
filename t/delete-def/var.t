::

  $ . $TESTROOT/Setup

  $ cat >vars.bas <<\EOF
  > Public x As Long
  > Public y As Long = 69
  > Public p As Long
  > Public q As Long = 42
  > Private b(8) As Byte
  > Private c() As Byte
  > Dim s As String
  > Dim t As String = "fubar"
  > EOF


::

  $ cp vars.bas v.bas
  $ file=v.bas t=var n=x dce-delete-def

  $ diff_files vars.bas v.bas
  --- vars.bas
  +++ v.bas
  @@ -1,4 +1,3 @@
  -Public x As Long
   Public y As Long = 69
   Public p As Long
   Public q As Long = 42
  [1]


::

  $ cp vars.bas v.bas
  $ file=v.bas t=var n=y dce-delete-def

  $ diff_files vars.bas v.bas
  --- vars.bas
  +++ v.bas
  @@ -1,5 +1,4 @@
   Public x As Long
  -Public y As Long = 69
   Public p As Long
   Public q As Long = 42
   Private b(8) As Byte
  [1]


::

  $ cp vars.bas v.bas
  $ file=v.bas t=var n=p dce-delete-def

  $ diff_files vars.bas v.bas
  --- vars.bas
  +++ v.bas
  @@ -1,6 +1,5 @@
   Public x As Long
   Public y As Long = 69
  -Public p As Long
   Public q As Long = 42
   Private b(8) As Byte
   Private c() As Byte
  [1]


::

  $ cp vars.bas v.bas
  $ file=v.bas t=var n=q dce-delete-def

  $ diff_files vars.bas v.bas
  --- vars.bas
  +++ v.bas
  @@ -1,7 +1,6 @@
   Public x As Long
   Public y As Long = 69
   Public p As Long
  -Public q As Long = 42
   Private b(8) As Byte
   Private c() As Byte
   Dim s As String
  [1]


::

  $ cp vars.bas v.bas
  $ file=v.bas t=var n=b dce-delete-def

  $ diff_files vars.bas v.bas
  --- vars.bas
  +++ v.bas
  @@ -2,7 +2,6 @@
   Public y As Long = 69
   Public p As Long
   Public q As Long = 42
  -Private b(8) As Byte
   Private c() As Byte
   Dim s As String
   Dim t As String = "fubar"
  [1]


::

  $ cp vars.bas v.bas
  $ file=v.bas t=var n=c dce-delete-def

  $ diff_files vars.bas v.bas
  --- vars.bas
  +++ v.bas
  @@ -3,6 +3,5 @@
   Public p As Long
   Public q As Long = 42
   Private b(8) As Byte
  -Private c() As Byte
   Dim s As String
   Dim t As String = "fubar"
  [1]


::

  $ cp vars.bas v.bas
  $ file=v.bas t=var n=s dce-delete-def

  $ diff_files vars.bas v.bas
  --- vars.bas
  +++ v.bas
  @@ -4,5 +4,4 @@
   Public q As Long = 42
   Private b(8) As Byte
   Private c() As Byte
  -Dim s As String
   Dim t As String = "fubar"
  [1]


::

  $ cp vars.bas v.bas
  $ file=v.bas t=var n=t dce-delete-def

  $ diff_files vars.bas v.bas
  --- vars.bas
  +++ v.bas
  @@ -5,4 +5,3 @@
   Private b(8) As Byte
   Private c() As Byte
   Dim s As String
  -Dim t As String = "fubar"
  [1]
