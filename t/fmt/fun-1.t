setup::

  $ . $TESTROOT/Setup


joins _ lines in function definitions::

  $ cat > case1.bas <<\EOF
  > Public Function thisFunction(arg As Date _
  >                              ) As Date
  >     thisFunction = otherFunction(Year(arg), _
  >                                  Month(arg), _
  >                                  Day(arg) _
  >                                  )
  > End   Function
  > EOF

  $ dce-fmt case1.bas
  Public Function thisFunction(arg As Date) As Date
  thisFunction = otherFunction(Year(arg), Month(arg), Day(arg))
  End Function
