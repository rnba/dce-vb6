Attribute VB_Name = "modSysADOLibrary"
Option Explicit
Private m_adoOrigin As ADODB.Recordset
Public Sub CopyADOStructure(ByVal adoOrigin As ADODB.Recordset, ByRef adoDestination As ADODB.Recordset)

    Rem *** FAILSAFE SKIP
    On Error GoTo ErrorHandler

    Dim lFields         As Long
    Dim lLoop           As Long

    If adoOrigin Is Nothing Then
        Set adoDestination = Nothing
        Exit Sub
    End If

    If adoDestination Is Nothing Then Set adoDestination = New ADODB.Recordset

    lFields = adoOrigin.Fields.Count
    For lLoop = 0 To lFields - 1
        AppendField adoDestination.Fields, adoOrigin.Fields(lLoop)
    Next lLoop

CommonExit:
    Exit Sub

ErrorHandler:
    ' Recordsets can have identical columns, ignore those
    If Err.Number = 3367 Then Resume Next
    Err.Raise Err.Number, "ADOLibrary.CopyADOStructure", Err.Description
    Resume CommonExit

End Sub


Public Sub CopyADOData(ByVal adoOrigin As ADODB.Recordset, ByRef adoDestination As ADODB.Recordset)

    Rem *** FAILSAFE SKIP
    On Error GoTo ErrorHandler

    Dim lFields         As Long
    Dim lLoop           As Long
    Dim vBookmark       As Variant
    Dim strFieldName    As String

    If (adoOrigin Is Nothing) Or (adoDestination Is Nothing) Then Exit Sub

    If (adoDestination.State And adStateOpen) <> adStateOpen Then
        adoDestination.open
    End If

    If adoOrigin.RecordCount = 0 Then Exit Sub

    lFields = adoOrigin.Fields.Count
    With adoOrigin
        'there might not be a bookmark, in which we set it to the first
        ' record
        On Error Resume Next
        vBookmark = .Bookmark
        If (Err.Number <> 0) Then
            vBookmark = adBookmarkFirst
            Err.Clear
        End If
        'resume normal error handling
        On Error GoTo ErrorHandler

        If .RecordCount > 0 Then .MoveFirst
        Do While Not .EOF
            adoDestination.AddNew
            For lLoop = 0 To lFields - 1
                strFieldName = .Fields(lLoop).Name
                If IsNull(.Fields(lLoop).Value) Then
                    adoDestination.Fields(strFieldName).Value = Null
                ElseIf .Fields(lLoop).Type = adChapter Then
                    CopyADOData .Fields(lLoop).Value, adoDestination.Fields(strFieldName).Value
                ElseIf (.Fields(lLoop).attributes And adFldLong) = adFldLong Then
                    If .Fields(lLoop).ActualSize = 0 Then
                        adoDestination.Fields(strFieldName).Value = ""
                    Else
                        adoDestination.Fields(strFieldName).AppendChunk .Fields(lLoop).GetChunk(.Fields(lLoop).ActualSize)
                    End If
                Else
                    adoDestination.Fields(strFieldName).Value = .Fields(lLoop).Value
                End If
            Next lLoop
            adoDestination.Update
            .MoveNext
        Loop
        
        On Error Resume Next
        'there seem to be problems with bookmarks. Made mental note never to revisit
        .Bookmark = vBookmark
        'resume normal error handling
        On Error GoTo ErrorHandler

    End With
    If adoDestination.RecordCount > 0 Then adoDestination.MoveFirst

CommonExit:
    Exit Sub

ErrorHandler:
    Err.Raise Err.Number, "ADOLibrary.CopyADOData", Err.Description
    Resume CommonExit

End Sub


Public Sub SetADOField(ByVal adoRecordset As ADODB.Recordset, ByVal FieldIndex As Variant, ByVal Value As Variant)

    Rem *** FAILSAFE SKIP
    On Error GoTo ErrorHandler

    Dim vBookmark       As Variant

    If adoRecordset Is Nothing Then Exit Sub
    If (adoRecordset.State And adStateOpen) <> adStateOpen Then
        adoRecordset.open
    End If

    With adoRecordset
        'there might not be a bookmark, in which we set it to the first
        ' record
        On Error Resume Next
        vBookmark = .Bookmark
        If (Err.Number <> 0) Then
            vBookmark = adBookmarkFirst
            Err.Clear
        End If
        'resume normal error handling
        On Error GoTo ErrorHandler
        
        If .RecordCount > 0 Then .MoveFirst
        Do While Not .EOF
            .Fields(FieldIndex) = Value
            .Update
            .MoveNext
        Loop
        .Bookmark = vBookmark
    End With

CommonExit:
    Exit Sub

ErrorHandler:
    Err.Raise Err.Number, "ADOLibrary.SetADOField", Err.Description
    Resume CommonExit

End Sub


Public Function ExtendADORecordset(ByVal adoOrigin As ADODB.Recordset, ParamArray aColumns() As Variant) As ADODB.Recordset

    Rem *** FAILSAFE SKIP
    On Error GoTo ErrorHandler

    Dim lColumns        As Long
    Dim lUBound         As Long
    Dim lNewColumns     As Long
    Dim lLoop           As Long
    Dim adoDestination  As ADODB.Recordset

    lUBound = UBound(aColumns)
    If lUBound = 0 Then
        aColumns = aColumns(0)
        lUBound = UBound(aColumns)
    End If

    If ((lUBound + 1) Mod 3) <> 0 Then
        Err.Raise 1000, "ADOExtendedRecordset", "The number of parameters must be a multiple of 3."
        Exit Function
    End If

    lColumns = adoOrigin.Fields.Count
    lNewColumns = (lUBound + 1) / 3
    CopyADOStructure adoOrigin, adoDestination
    For lLoop = 0 To lNewColumns - 1
        AppendNewField adoDestination.Fields, aColumns(3 * lLoop), aColumns(3 * lLoop + 1)
    Next lLoop

    If adoOrigin.EOF Then
        If (adoDestination.State And adStateOpen) <> adStateOpen Then
            adoDestination.open
        End If
    Else
        CopyADOData adoOrigin, adoDestination
        For lLoop = 0 To lNewColumns - 1
            If Not IsNull(aColumns(3 * lLoop + 2)) Then
                SetADOField adoDestination, lColumns + lLoop, aColumns(3 * lLoop + 2)
            End If
        Next lLoop
    End If

    Set ExtendADORecordset = adoDestination
    Set adoDestination = Nothing

CommonExit:
    Exit Function

ErrorHandler:
    Err.Raise Err.Number, "ADOLibrary.ExtendADORecordset", Err.Description
    Resume CommonExit

End Function

Private Sub GetADODataType(ByVal strDefinition As String, ByRef iDataType As ADODB.DataTypeEnum, ByRef lDefinedSize As Long, ByRef lPrecision As Long, ByRef lNumericScale As Long, ByRef bNullable As Boolean)

    Rem *** FAILSAFE SKIP
    On Error Resume Next

    Dim aParts()    As String
    Dim lUBound     As Long

    iDataType = adEmpty
    lDefinedSize = -1
    lNumericScale = -1
    lPrecision = -1
    bNullable = True

    'remove spaces
    strDefinition = Replace(LCase(strDefinition), " ", "")
    If Right(strDefinition, 7) = "notnull" Then
        bNullable = False
        strDefinition = left(strDefinition, Len(strDefinition) - 7)
    End If
    If Right(strDefinition, 4) = "null" Then
        bNullable = True
        strDefinition = left(strDefinition, Len(strDefinition) - 4)
    End If
    'replace ( and ) with ,
    strDefinition = Replace(strDefinition, "(", ",")
    strDefinition = Replace(strDefinition, ")", ",")
    aParts = Split(strDefinition, ",")
    lUBound = UBound(aParts)

    Select Case aParts(0)
    Case "bit"
        iDataType = adBoolean
    Case "int"
        iDataType = adInteger
    Case "smallint"
        iDataType = adSmallInt
    Case "tinyint"
        iDataType = adTinyInt
    Case "money"
        iDataType = adCurrency
    Case "smallmoney"
        iDataType = adCurrency
    Case "datetime"
        iDataType = adDBTimeStamp
    Case "smalldatetime"
        iDataType = adDBTimeStamp
    Case "timestamp"
        iDataType = adBinary
    Case "uniqueidentifier"
        iDataType = adGUID
    Case "text"
        iDataType = adLongVarChar
        lDefinedSize = 2147483647
    Case "ntext"
        iDataType = adLongVarWChar
        lDefinedSize = 2147483647
    Case "image"
        iDataType = adLongVarBinary
        lDefinedSize = 2147483647
    Case "float"
        iDataType = adDouble
    Case "real"
        iDataType = adSingle
    Case "decimal", "numeric"
        lPrecision = 18
        lNumericScale = 0
        iDataType = adNumeric
        If (lUBound > 0) Then lPrecision = CByte(aParts(1))
        If (lUBound > 1) Then lNumericScale = CByte(aParts(2))
    Case "char"
        lDefinedSize = 1
        iDataType = adChar
        If (lUBound > 0) Then lDefinedSize = CLng(aParts(1))
    Case "varchar"
        lDefinedSize = 1
        iDataType = adVarChar
        If (lUBound > 0) Then lDefinedSize = CLng(aParts(1))
    Case "nchar"
        lDefinedSize = 1
        iDataType = adWChar
        If (lUBound > 0) Then lDefinedSize = CLng(aParts(1))
    Case "nvarchar"
        lDefinedSize = 1
        iDataType = adVarWChar
        If (lUBound > 0) Then lDefinedSize = CLng(aParts(1))
    Case "binary"
        lDefinedSize = 1
        iDataType = adBinary
        If (lUBound > 0) Then lDefinedSize = CLng(aParts(1))
    Case "varbinary"
        lDefinedSize = 1
        iDataType = adVarBinary
        If (lUBound > 0) Then lDefinedSize = CLng(aParts(1))
    End Select

CommonExit:
    Exit Sub

ErrorHandler:
    Err.Raise Err.Number, "ADOLibrary.GetADODataType", Err.Description
    Resume CommonExit

End Sub


Public Function CreateADORecordset(ParamArray aColumns() As Variant) As ADODB.Recordset

    Rem *** FAILSAFE SKIP
    On Error GoTo ErrorHandler

    Dim lUBound         As Long
    Dim lNewColumns     As Long
    Dim lLoop           As Long
    Dim iDataType       As ADODB.DataTypeEnum
    Dim lDefinedSize    As Long
    Dim lPrecision      As Long
    Dim lNumericScale   As Long
    Dim adoDestination  As ADODB.Recordset
    Dim bNullable       As Boolean
    Dim lAttributes     As Long

    lUBound = UBound(aColumns)
    If lUBound = 0 Then
        aColumns = aColumns(0)
        lUBound = UBound(aColumns)
    End If

    If ((lUBound + 1) Mod 2) <> 0 Then
        Err.Raise 1000, "ADOCreateRecordset", "The number of parameters must be a multiple of 2."
        Exit Function
    End If

    lNewColumns = (lUBound + 1) / 2
    Set adoDestination = New ADODB.Recordset
    adoDestination.LockType = adLockBatchOptimistic 'KA 2542-05-10  JL :-)
    adoDestination.CursorType = adOpenStatic        'JL 2542-05-26
    adoDestination.CursorLocation = adUseClient     'JL 2542-05-26
    For lLoop = 0 To lNewColumns - 1
        lAttributes = 0
        GetADODataType aColumns(2 * lLoop + 1), iDataType, lDefinedSize, lPrecision, lNumericScale, bNullable
        If iDataType = adEmpty Then
            Err.Raise 1000, "", "SQL Syntax error in expression '" & aColumns(2 * lLoop + 1) & "'"
        End If
        If bNullable Then lAttributes = adFldMayBeNull + adFldIsNullable
        If iDataType = adLongVarBinary Then
            lAttributes = lAttributes + adFldLong + adFldMayDefer + adFldUnknownUpdatable
        End If
        If lDefinedSize >= 0 Then
            adoDestination.Fields.Append "" & aColumns(2 * lLoop), iDataType, lDefinedSize, lAttributes
        Else
            adoDestination.Fields.Append "" & aColumns(2 * lLoop), iDataType, , lAttributes
        End If
        If lPrecision >= 0 Then
            adoDestination.Fields("" & aColumns(2 * lLoop)).Precision = CByte(lPrecision)
            If lNumericScale >= 0 Then
                adoDestination.Fields("" & aColumns(2 * lLoop)).NumericScale = CByte(lNumericScale)
            End If
        End If
    Next lLoop
    adoDestination.open

    Set CreateADORecordset = adoDestination
    Set adoDestination = Nothing

CommonExit:
    Exit Function

ErrorHandler:
    Err.Raise Err.Number, "ADOLibrary.CreateADORecordset", Err.Description
    Resume CommonExit

End Function


Public Function ExtendADORecordsetAdvanced(ByVal adoOrigin As ADODB.Recordset, ParamArray aColumns() As Variant) As ADODB.Recordset

    Rem *** FAILSAFE SKIP
    On Error GoTo ErrorHandler

    Dim lColumns        As Long
    Dim lUBound         As Long
    Dim lNewColumns     As Long
    Dim lLoop           As Long
    Dim adoDestination  As ADODB.Recordset
    Dim lNewColPosition As Long
    Dim lOldColPosition As Long
    Dim bIsNewColumn    As Boolean

    lUBound = UBound(aColumns)
    If lUBound = 0 Then
        aColumns = aColumns(0)
        lUBound = UBound(aColumns)
    End If

    If ((lUBound + 1) Mod 4) <> 0 Then
        Err.Raise 1000, "ExtendADORecordsetAdvanced", "The number of parameters must be a multiple of 4."
        Exit Function
    End If

    If adoOrigin Is Nothing Then
        Set ExtendADORecordsetAdvanced = Nothing
        Exit Function
    End If

    If adoDestination Is Nothing Then Set adoDestination = New ADODB.Recordset

    lColumns = adoOrigin.Fields.Count
    lNewColumns = (lUBound + 1) / 4

    lOldColPosition = 0
    For lNewColPosition = 0 To lColumns + lNewColumns - 1
        'check if lNewColPosition must be a newly inserted column
        bIsNewColumn = False
        For lLoop = 0 To lNewColumns - 1
            If CLng(aColumns(lLoop * 4)) = lNewColPosition Then
                bIsNewColumn = True
                Exit For
            End If
        Next lLoop
        If bIsNewColumn Then
            'new column to be inserted
            AppendNewField adoDestination.Fields, aColumns(4 * lLoop + 1), aColumns(4 * lLoop + 2)
        Else
            'column from existing recordset to be inserted
            AppendField adoDestination.Fields, adoOrigin.Fields(lOldColPosition)
            lOldColPosition = lOldColPosition + 1
        End If
    Next lNewColPosition

    If adoOrigin.EOF Then
        If (adoDestination.State And adStateOpen) <> adStateOpen Then
            adoDestination.open
        End If
    Else
        CopyADOData adoOrigin, adoDestination
        For lLoop = 0 To lNewColumns - 1
            If Not IsNull(aColumns(4 * lLoop + 3)) Then
                SetADOField adoDestination, aColumns(4 * lLoop), aColumns(4 * lLoop + 3)
            End If
        Next lLoop
    End If

    Set ExtendADORecordsetAdvanced = adoDestination
    Set adoDestination = Nothing

CommonExit:
    Exit Function

ErrorHandler:
    Err.Raise Err.Number, "ADOLibrary.ExtendADORecordsetAdvanced", Err.Description
    Resume CommonExit

End Function


Private Sub AppendField(ByVal colFields As ADODB.Fields, ByVal fldNewField As ADODB.field)
    Rem *** FAILSAFE SKIP
    On Error GoTo ErrorHandler

    Dim lNewIndex       As Long

    With fldNewField
        colFields.Append .Name, .Type, .DefinedSize, .attributes
        lNewIndex = colFields.Count - 1
        colFields(lNewIndex).NumericScale = .NumericScale
        colFields(lNewIndex).Precision = .Precision
        If (colFields(lNewIndex).attributes And adFldUnknownUpdatable) = adFldUnknownUpdatable Then
            colFields(lNewIndex).attributes = colFields(lNewIndex).attributes - adFldUnknownUpdatable
        End If
        If (colFields(lNewIndex).attributes And adFldUpdatable) <> adFldUpdatable Then
            colFields(lNewIndex).attributes = colFields(lNewIndex).attributes + adFldUpdatable
        End If
    End With
    
CommonExit:
    Exit Sub

ErrorHandler:
    ' Recordsets can have identical columns, ignore those
    If Err <> 3367 Then
        Err.Raise Err.Number, "ADOLibrary.AppendField", Err.Description
    End If
    Resume CommonExit

End Sub

Private Sub AppendNewField(ByVal colFields As ADODB.Fields, ByVal strFieldName As String, ByVal strDataType As String)

    Rem *** FAILSAFE SKIP
    On Error GoTo ErrorHandler

    Dim iDataType       As ADODB.DataTypeEnum
    Dim lDefinedSize    As Long
    Dim lPrecision      As Long
    Dim lNumericScale   As Long
    Dim bIgnore         As Boolean

    'get type information
    GetADODataType strDataType, iDataType, lDefinedSize, lPrecision, lNumericScale, bIgnore
    If iDataType = adEmpty Then
        'syntax error
        Err.Raise 1000, "", "SQL Syntax error in expression '" & strDataType & "'"
    End If
    If lDefinedSize >= 0 Then
        colFields.Append strFieldName, iDataType, lDefinedSize, adFldMayBeNull + adFldIsNullable
    Else
        colFields.Append strFieldName, iDataType, , adFldMayBeNull + adFldIsNullable
    End If
    If lPrecision >= 0 Then
        colFields(strFieldName).Precision = CByte(lPrecision)
        If lNumericScale >= 0 Then
            colFields(strFieldName).NumericScale = CByte(lNumericScale)
        End If
    End If
    
CommonExit:
    Exit Sub

ErrorHandler:
    Err.Raise Err.Number, "ADOLibrary.AppendNewField", Err.Description
    Resume CommonExit

End Sub


Private Sub ParseColumnDescription(ByVal strColumnDescription As String, ByRef colComputingSteps As Collection, ByRef strColumnName As String, ByRef strDataType As String)

    Rem *** FAILSAFE SKIP
    On Error GoTo ErrorHandler

    Dim iPos            As Integer
    Dim strColumn       As String
    Dim strDefinition   As String

    iPos = InStr(strColumnDescription, "=")
    If iPos > 0 Then
        'description is of type <name> as <type> = <expression>
        strColumn = Trim(left(strColumnDescription, iPos - 1))
        strDefinition = Trim(Mid(strColumnDescription, iPos + 1))
        iPos = InStr(1, strColumn, " as ", vbTextCompare)
        strColumnName = Trim(left(strColumn, iPos - 1))
        strDataType = Trim(Mid(strColumn, iPos + 4))
        ParseDefinition strDefinition, colComputingSteps
    Else
        'description is of type <name>
        Set colComputingSteps = Nothing
        strColumnName = strColumnDescription
        strDataType = ""
    End If

CommonExit:
    Exit Sub

ErrorHandler:
    Err.Raise Err.Number, "ADOLibrary.ParseColumnDescription", Err.Description
    Resume CommonExit

End Sub

Private Sub ParseDefinition(ByVal strDefinition As String, ByRef colComputingSteps As Collection)

    Dim bContinue As Boolean
    Rem *** FAILSAFE SKIP

    On Error GoTo ErrorHandler

    Dim iPos            As Integer
    Dim vElement        As Variant
    Dim lLoop           As Long
    Dim lComputingStep  As Long

    If colComputingSteps Is Nothing Then
        Set colComputingSteps = New Collection
    End If

    strDefinition = LCase(strDefinition)

    bContinue = True
    Do While bContinue
        If left(strDefinition, 8) = "coalesce" Then
            'encountered coalesce
            colComputingSteps.Add "C"
            strDefinition = Mid(strDefinition, 9)
        ElseIf left(strDefinition, 4) = "trim" Then
            'encountered trim
            colComputingSteps.Add "T"
            strDefinition = Mid(strDefinition, 5)
        Else
            Select Case left(strDefinition, 1)
            Case "'"
                'encountered string constant
                iPos = InStr(2, strDefinition, "'")
                colComputingSteps.Add "V:" & Mid(strDefinition, 2, iPos - 2)
                strDefinition = Mid(strDefinition, iPos + 1)
            Case "+", ",", "(", ")"
                colComputingSteps.Add left(strDefinition, 1)
                strDefinition = Mid(strDefinition, 2)
            Case Else
                'encountered column name
                iPos = MinimumNot0(InStr(strDefinition, "'"), _
                    MinimumNot0(InStr(strDefinition, "+"), _
                    MinimumNot0(InStr(strDefinition, ","), _
                    MinimumNot0(InStr(strDefinition, "("), _
                    MinimumNot0(InStr(strDefinition, " "), InStr(strDefinition, ")"))))))
                If iPos = 0 Then
                    colComputingSteps.Add "F:" & strDefinition
                    strDefinition = ""
                Else
                    colComputingSteps.Add "F:" & left(strDefinition, iPos - 1)
                    strDefinition = Mid(strDefinition, iPos)
                End If
            End Select
        End If
        strDefinition = Trim(strDefinition)
        bContinue = (Len(strDefinition) > 0)
    Loop

CommonExit:
    Exit Sub

ErrorHandler:
    Err.Raise Err.Number, "ADOLibrary.ParseDefinition", Err.Description
    Resume CommonExit

End Sub

Private Function MinimumNot0(ByVal iInt1 As Integer, ByVal iInt2 As Integer) As Integer

    Rem *** FAILSAFE SKIP
    On Error Resume Next
    
    'returns the minimum of the non-0 numbers
    'returns 0 if both numbers are 0
    If (iInt1 = 0) Then
        MinimumNot0 = iInt2
    ElseIf (iInt2 = 0) Then
        MinimumNot0 = iInt1
    ElseIf (iInt1 < iInt2) Then
        MinimumNot0 = iInt1
    Else
        MinimumNot0 = iInt2
    End If

End Function

Private Function ProcessCoalesce(ByVal colComputingSteps As Collection, ByRef lComputingStep As Long) As Variant

    Rem *** FAILSAFE SKIP
    On Error GoTo ErrorHandler

    Dim vCurrentValue   As Variant
    Dim vTemp           As Variant

    'skip keyword coalesce
    lComputingStep = lComputingStep + 1

    'check for (
    If colComputingSteps(lComputingStep) <> "(" Then
        Err.Raise vbObjectError + 1, , "coalesce must be followed by (."
    End If

    'move to next token
    lComputingStep = lComputingStep + 1
    'first argument of coalesce()
    vCurrentValue = ProcessExpression(colComputingSteps, lComputingStep)
    Do While colComputingSteps(lComputingStep) = ","
        'subsequent arguments of coalesce()
        lComputingStep = lComputingStep + 1
        vTemp = ProcessExpression(colComputingSteps, lComputingStep)
        If IsNull(vCurrentValue) Then
            vCurrentValue = vTemp
        End If
    Loop

    'check for ) and skip
    If colComputingSteps(lComputingStep) <> ")" Then
        Err.Raise vbObjectError + 1, , "Missing ) in Trim() expression."
    End If
    lComputingStep = lComputingStep + 1

    'return value
    ProcessCoalesce = vCurrentValue

CommonExit:
    Exit Function

ErrorHandler:
    Err.Raise Err.Number, "ADOLibrary.ProcessCoalesce", Err.Description
    Resume CommonExit


End Function

Private Function ProcessTrim(ByVal colComputingSteps As Collection, ByRef lComputingStep As Long) As Variant

    Rem *** FAILSAFE SKIP
    On Error GoTo ErrorHandler

    Dim vCurrentValue   As Variant

    'skip keyword coalesce
    lComputingStep = lComputingStep + 1
    
    'check for (
    If colComputingSteps(lComputingStep) <> "(" Then
        Err.Raise vbObjectError + 1, , "coalesce must be followed by (."
    End If
    'move to next token
    lComputingStep = lComputingStep + 1
    
    vCurrentValue = Trim(ProcessExpression(colComputingSteps, lComputingStep))
    If Len(vCurrentValue) = 0 Then vCurrentValue = Null
    
    'check for )
    If colComputingSteps(lComputingStep) <> ")" Then
        Err.Raise vbObjectError + 1, , "Missing ) in Trim() expression."
    End If
    'move to next token = skip )
    lComputingStep = lComputingStep + 1

    'return value
    ProcessTrim = vCurrentValue

CommonExit:
    Exit Function
    
ErrorHandler:
    Err.Raise Err.Number, "ADOLibrary.ProcessTrim", Err.Description
    Resume CommonExit
    
End Function

Private Sub CheckConcatenate(ByRef vCurrentValue As Variant, ByVal colComputingSteps As Collection, ByRef lComputingStep As Long)

    Rem *** FAILSAFE SKIP
    On Error GoTo ErrorHandler

    Dim vTemp       As Variant

    If lComputingStep > colComputingSteps.Count Then Exit Sub

    'if the next token is +, we have an expression to concatenate
    Do While colComputingSteps(lComputingStep) = "+"
        lComputingStep = lComputingStep + 1
        vTemp = ProcessExpression(colComputingSteps, lComputingStep)
        If Not IsNull(vTemp) Then vCurrentValue = vCurrentValue & vTemp
        If lComputingStep > colComputingSteps.Count Then Exit Sub
    Loop

CommonExit:
    Exit Sub

ErrorHandler:
    Err.Raise Err.Number, "ADOLibrary.CheckConcatenate", Err.Description
    Resume CommonExit
    
End Sub


Private Function ProcessExpression(ByVal colComputingSteps As Collection, ByRef lComputingStep As Long) As Variant

    Rem *** FAILSAFE SKIP
    On Error GoTo ErrorHandler

    Select Case left(colComputingSteps(lComputingStep), 1)
    Case "C"
        ProcessExpression = ProcessCoalesce(colComputingSteps, lComputingStep)
        CheckConcatenate ProcessExpression, colComputingSteps, lComputingStep
    Case "T"
        ProcessExpression = ProcessTrim(colComputingSteps, lComputingStep)
        CheckConcatenate ProcessExpression, colComputingSteps, lComputingStep
    Case "F"
        ProcessExpression = ColumnValue(colComputingSteps(lComputingStep))
        lComputingStep = lComputingStep + 1
        CheckConcatenate ProcessExpression, colComputingSteps, lComputingStep
    Case "V"
        ProcessExpression = Mid(colComputingSteps(lComputingStep), 3)
        If Len(ProcessExpression) = 0 Then ProcessExpression = Null
        lComputingStep = lComputingStep + 1
        CheckConcatenate ProcessExpression, colComputingSteps, lComputingStep
    Case Else
        Err.Raise vbObjectError + 1, , "Must start with coalesce, trim, column or string constant."
    End Select

CommonExit:
    Exit Function

ErrorHandler:
    Err.Raise Err.Number, "ADOLibrary.ProcessExppression", Err.Description
    Resume CommonExit

End Function

Private Function ColumnValue(ByVal strName As String) As Variant

    Rem *** FAILSAFE SKIP
    On Error Resume Next

    ColumnValue = m_adoOrigin.Fields(Mid(strName, 3)).Value
    'empty strings are deemed equivalent to Null
    If Len("" & ColumnValue) = 0 Then ColumnValue = Null

End Function

Public Function ModifyADORecordset(ByVal adoOrigin As ADODB.Recordset, ParamArray aColumns() As Variant) As ADODB.Recordset

    Rem *** FAILSAFE SKIP
    On Error GoTo ErrorHandler

    Dim lUBound             As Long
    Dim lLoop               As Long
    Dim adoDestination      As ADODB.Recordset
    Dim aColDescriptions()  As Collection
    Dim strColumnName       As String
    Dim strDataType         As String
    Dim lComputingStep      As Long

    'if there is only one argument, we assume it's an array of Variants
    lUBound = UBound(aColumns)
    If lUBound = 0 Then
        aColumns = aColumns(0)
        lUBound = UBound(aColumns)
    End If

    'source is Nothing -> return Nothing
    If adoOrigin Is Nothing Then
        Set ModifyADORecordset = Nothing
        Exit Function
    End If

    'create new recordset
    If adoDestination Is Nothing Then Set adoDestination = New ADODB.Recordset

    'dimension the expression collection array
    ReDim aColDescriptions(lUBound)

    For lLoop = 0 To lUBound
        ParseColumnDescription aColumns(lLoop), aColDescriptions(lLoop), strColumnName, strDataType
        If aColDescriptions(lLoop) Is Nothing Then
            'simple column: copy field description from source recordset
            AppendField adoDestination.Fields, adoOrigin.Fields(strColumnName)
        Else
            'computed column
            AppendNewField adoDestination.Fields, strColumnName, strDataType
        End If
    Next lLoop

    'open recordset
    If (adoDestination.State And adStateOpen) <> adStateOpen Then
        adoDestination.open
    End If

    'set module level variable
    Set m_adoOrigin = adoOrigin

    'loop through records and append
    With adoOrigin
        If Not .EOF Then
            .MoveFirst
            Do While Not .EOF
                adoDestination.AddNew
                For lLoop = 0 To lUBound
                    If aColDescriptions(lLoop) Is Nothing Then
                        'simple column
                        strColumnName = aColumns(lLoop)
                        If IsNull(.Fields(strColumnName)) Then
                            adoDestination.Fields(strColumnName) = Null
                        ElseIf (.Fields(strColumnName).attributes And adFldLong) = adFldLong Then
                            adoDestination.Fields(strColumnName).AppendChunk .Fields(strColumnName).GetChunk(.Fields(strColumnName).ActualSize)
                        Else
                            adoDestination.Fields(strColumnName) = .Fields(strColumnName).Value
                        End If
                    Else
                        'computed column: compute the value and assign it
                        lComputingStep = 1
                        adoDestination.Fields(lLoop) = ProcessExpression(aColDescriptions(lLoop), lComputingStep)
                    End If
                Next lLoop
                adoDestination.Update
                .MoveNext
            Loop
        End If
    End With
    Set ModifyADORecordset = adoDestination
    Set adoDestination = Nothing
    Set m_adoOrigin = Nothing
    'clean up array of collections
    For lLoop = 0 To lUBound
        Set aColDescriptions(lLoop) = Nothing
    Next lLoop

CommonExit:
    Exit Function

ErrorHandler:
    Err.Raise Err.Number, "ADOLibrary.ModifyADORecordset", Err.Description
    Resume CommonExit

End Function


Public Function GetPictureFromRS(objField As ADODB.field) As Picture
Attribute GetPictureFromRS.VB_Description = "Return a picture object from a image field."

    Rem *** FAILSAFE SKIP
'    On Error GoTo ErrorHandler
'
'    Const strProcName   As String = "GetPictureFromRS"
'
'    Dim strFileName     As String
'    Dim strErrDesc      As String
'    Dim lErrorNum       As Long
'    Dim bOpen           As Boolean
'
'    Dim iFile           As Integer
'    Dim arrBytes()      As Byte
'
'    If Not IsNull(objField.Value) Then
'        strFileName = GetTempFile()
'
'        On Error Resume Next
'        Kill strFileName
'
'        On Error GoTo ErrorHandler
'
''        arrBytes = objField.GetChunk(1)
'        arrBytes = objField.GetChunk(objField.ActualSize)
'        iFile = FreeFile
'        Open strFileName For Binary Access Write As #iFile
'        bOpen = True
'        Put #iFile, , arrBytes
'        Close #iFile
'        bOpen = False
'        Set GetPictureFromRS = LoadPicture(strFileName)
'
'        Kill strFileName
'    End If
'
'Commonexit:
'    Exit Function
'
'ErrorHandler:
'    If bOpen Then
'        bOpen = False
'        Close
'    End If
'    Resume Commonexit
    
End Function

Public Function IfNull(ByVal vValue As Variant) As Variant
    Rem *** FAILSAFE SKIP
    If Not IsNull(vValue) Then IfNull = vValue
    
End Function

Public Function n2e(vWhat As Variant) As Variant
    Rem *** FAILSAFE SKIP
    ' Replaces a possible Null with Empty
    ' used as a sub or function
    ' Think it's the same as ifnull, so i't should be replaced.
    If IsNull(vWhat) Then
        n2e = Empty
        vWhat = Empty
    Else
        n2e = vWhat
    End If
End Function


Public Function FormatADOGUID(ByVal strGUID As String) As String
    Rem *** FAILSAFE SKIP
    'Some versions of ADO seems to have a problem with GUIDs without brackets.
    'this function add brackets to non-bracket guids
    
    If Len(strGUID) = 36 Then
        FormatADOGUID = "{" & strGUID & "}"
    Else
        FormatADOGUID = strGUID
    End If
End Function

Public Function TrimADOGUID(ByVal strGUID As String) As String
    Rem *** FAILSAFE SKIP
    'remove brackets from a GUID
    TrimADOGUID = Replace(Replace(strGUID, "{", ""), "}", "")
End Function

'Purpose:        Find wrapper
Public Sub Find(ByRef rs As ADODB.Recordset, ByRef strWhat As String)
    Rem *** FAILSAFE SKIP
    On Local Error Resume Next
    If rs.RecordCount > 0 Then
        rs.Find strWhat, start:=1
    End If
End Sub

Public Sub CloseRs(rs As ADODB.Recordset)
    
    Rem *** FAILSAFE SKIP
    ' Close and discard the recordset
    On Local Error Resume Next
    If Not rs Is Nothing Then
        If rs.State = adStateOpen Then rs.Close
        Set rs = Nothing
    End If

End Sub

Public Function FieldExist(ByVal rsData As Recordset, ByVal strFieldName As String) As Boolean
    Rem *** FAILSAFE SKIP
    On Error Resume Next

    Dim objField    As ADODB.field
    
    For Each objField In rsData.Fields
        If LCase$(objField.Name) = LCase$(strFieldName) Then
            FieldExist = True
            Exit For
        End If
    Next
End Function

Public Function StringFromRS(rs As ADODB.Recordset, column As String, _
                             Optional strPrefix As String = "") As String

    Rem *** FAILSAFE SKIP
    
    Dim strTemp     As String
    Dim strColumn   As String
    
    If Not rs Is Nothing Then
        With rs
            If .RecordCount > 0 Then
                .MoveFirst
                While Not .EOF
                    If IsNull(.Fields(column)) = True Then
                    ElseIf strColumn = NZ(.Fields(column).Value) Then
                        'skip the ids we've already processed
                    Else
                        strColumn = NZ(.Fields(column).Value)
                        If Len(strTemp) Then strTemp = strTemp & ", "
                        strTemp = strTemp & "'" & strPrefix & .Fields(column).Value & "'"
                    End If
                    .MoveNext
                Wend
                .MoveFirst
                StringFromRS = strTemp
            End If
        End With
    End If
End Function

Public Function Clone(ByVal oRs As ADODB.Recordset, _
                      Optional ByVal LockType As ADODB.LockTypeEnum = adLockUnspecified) As ADODB.Recordset
    
    Dim oStream         As ADODB.Stream
    Dim oRsClone        As ADODB.Recordset
    
    If oRs Is Nothing Then
    Else
    
        'save the recordset to the stream object
        Set oStream = New ADODB.Stream
        oRs.Save oStream
        
        'and now open the stream object into a new recordset
        Set oRsClone = New ADODB.Recordset
        oRsClone.open oStream, , , LockType
        
        'return the cloned recordset
        Set Clone = oRsClone
        
        'release the reference
        Set oRsClone = Nothing
        
    End If
    
End Function

Public Function ADOUpdateText(ByRef rsField As ADODB.field, _
                              ByVal vField As Variant, _
                              Optional bSkipNull As Boolean = False) As Boolean

On Error GoTo FunctionError
        
    If IsNull(vField) = True And _
        bSkipNull = True Then
    ElseIf NZ(rsField.Value) = NZ(vField) Then
        ADOUpdateText = False
    Else
        ADOUpdateText = True
        rsField.Value = ZN(vField)
    End If
    
FunctionError:
    
End Function

Public Function ADOUpdateFlag(ByRef rsField As ADODB.field, _
                              ByVal vField As Variant, _
                              Optional bAbs As Boolean = False) As Boolean

On Error GoTo FunctionError
        
    If IsNull(rsField.Value) = True And IsNull(vField) = False Then
        ADOUpdateFlag = True
        rsField.Value = Abs(N0(vField))
    ElseIf N0(rsField.Value) = N0(vField) Then
        ADOUpdateFlag = False
    Else
        ADOUpdateFlag = True
        If bAbs = True Then
            rsField.Value = Abs(N0(vField))
        Else
            rsField.Value = N0(vField)
        End If
    End If
    
FunctionError:
    
End Function

Public Function ADOUpdateDate(ByRef rsField As ADODB.field, _
                              ByVal vField As Variant) As Boolean

On Error GoTo FunctionError
        
    If NE(rsField.Value) = NE(vField) Then
        ADOUpdateDate = False
    Else
        ADOUpdateDate = True
        rsField.Value = EN(vField)
    End If
    
FunctionError:
    
End Function

Public Function ADOUpdateNumber(ByRef rsField As ADODB.field, _
                                ByVal vField As Variant, _
                                Optional bNULL As Boolean = False) As Boolean

On Error GoTo FunctionError
        
    If N0(rsField.Value) = TDbl(vField) Then
        ADOUpdateNumber = False
    Else
        ADOUpdateNumber = True
        If TDbl(vField) = 0 And _
           bNULL = True Then
            rsField.Value = Null
        Else
            rsField.Value = TDbl(vField)
        End If
    End If
    
FunctionError:
    
End Function

Public Function ADOCompareText(ByRef rsField As ADODB.field, _
                              ByVal vField As Variant) As Boolean

On Error GoTo FunctionError
        
    If NZ(rsField.Value) = NZ(vField) Then
        ADOCompareText = True
    Else
        ADOCompareText = False
    End If
    
FunctionError:
    
End Function

Public Function ADOCompareFlag(ByRef rsField As ADODB.field, _
                              ByVal vField As Variant) As Boolean

On Error GoTo FunctionError
        
    If N0(rsField.Value) = N0(vField) Then
        ADOCompareFlag = True
    Else
        ADOCompareFlag = False
    End If
    
FunctionError:
    
End Function

Public Function ADOCompareDate(ByRef rsField As ADODB.field, _
                              ByVal vField As Variant) As Boolean

On Error GoTo FunctionError
        
    If NE(rsField.Value) = NE(vField) Then
        ADOCompareDate = True
    Else
        ADOCompareDate = False
    End If
    
FunctionError:
    
End Function

Public Function ADOCompareNumber(ByRef rsField As ADODB.field, _
                                ByVal vField As Variant) As Boolean

On Error GoTo FunctionError
        
    If N0(rsField.Value) = TDbl(vField) Then
        ADOCompareNumber = True
    Else
        ADOCompareNumber = False
    End If
    
FunctionError:
    
End Function

Public Function IsRsModified(rs As ADODB.Recordset) As Boolean

    IsRsModified = False

    If rs Is Nothing Then
    Else
        rs.Filter = adFilterNone
        rs.Filter = adFilterPendingRecords
        If rs.EOF = False Then
            IsRsModified = True
        End If
        rs.Filter = adFilterNone
    End If

End Function
