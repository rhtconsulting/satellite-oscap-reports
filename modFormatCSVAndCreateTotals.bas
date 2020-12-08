Attribute VB_Name = "modFormatCSVAndCreateTotals"

Const HOST_COLUMN_HEADER As String = "Host"
Const IP_ADDRESS_COLUMN_HEADER As String = "IP Address"
Const ID_COLUMN_HEADER As String = "Id"
Const GROUP_COLUMN_HEADER As String = "Group Title"
Const VERSION_COLUMN_HEADER As String = "Version"
Const DESCRIPTION_COLUMN_HEADER As String = "Description"
Const DISA_ID_COLUMN_HEADER As String = "DISA Id"
Const MITRE_ID_COLUMN_HEADER As String = "Mitre Id"
Const SEVERITY_COLUMN_HEADER As String = "Severity"
Const PASSED_COLUMN_HEADER As String = "Passed"

Function IsValidCellColumn(xlSheet As Worksheet, HeaderCellValue As String) As Boolean

    Dim CurrentColumnValue As String
    Dim xlHeaderCell As Range
    CurrentColumnValue = ""
    For i = 1 To 10
        Set xlHeaderCell = xlSheet.Cells(1, i)
        
        If IsEmpty(xlHeaderCell) = False Then
                CurrentColumnValue = xlHeaderCell.Value
        Else
                CurrentColumnValue = ""
        End If
        If HeaderCellValue = CurrentColumnValue Then
                IsValidCellColumn = True
                Exit For
        Else
                IsValidCellColumn = False
        End If
    Next
Exit Function

End Function
Function ValidateHeaderCells() As Boolean
     Dim xlDataWorksheet As Worksheet
     Dim strBadHeaders As String
     
     strBadHeaders = ""
     Set xlDataWorksheet = ActiveWorkbook.Worksheets(1)
     ValidateHeaderCells = True
    ' Validate that we have all the columns we need---->
        
        
        Dim isValidSheet As Boolean
        isValidSheet = True
        
        
        If IsValidCellColumn(xlDataWorksheet, HOST_COLUMN_HEADER) = False Then
            strBadHeaders = HOST_COLUMN_HEADER
            isValidSheet = False
        End If
        
        If IsValidCellColumn(xlDataWorksheet, IP_ADDRESS_COLUMN_HEADER) = False Then
            strBadHeaders = strBadHeaders & ", " & IP_ADDRESS_COLUMN_HEADER
            isValidSheet = False
        End If
        
        If IsValidCellColumn(xlDataWorksheet, ID_COLUMN_HEADER) = False Then
            strBadHeaders = strBadHeaders & ", " & ID_COLUMN_HEADER
            isValidSheet = False
        End If
        
        If IsValidCellColumn(xlDataWorksheet, GROUP_COLUMN_HEADER) = False Then
            strBadHeaders = strBadHeaders & ", " & GROUP_COLUMN_HEADER
            isValidSheet = False
        End If
        
        If IsValidCellColumn(xlDataWorksheet, VERSION_COLUMN_HEADER) = False Then
            strBadHeaders = strBadHeaders & ", " & VERSION_COLUMN_HEADER
            isValidSheet = False
        End If
        
        If IsValidCellColumn(xlDataWorksheet, DESCRIPTION_COLUMN_HEADER) = False Then
            strBadHeaders = strBadHeaders & ", " & DESCRIPTION_COLUMN_HEADER
            isValidSheet = False
        End If
        
        If IsValidCellColumn(xlDataWorksheet, DISA_ID_COLUMN_HEADER) = False Then
            strBadHeaders = strBadHeaders & ", " & DISA_ID_COLUMN_HEADER
            isValidSheet = False
        End If
        
        If IsValidCellColumn(xlDataWorksheet, MITRE_ID_COLUMN_HEADER) = False Then
            strBadHeaders = strBadHeaders & ", " & MITRE_ID_COLUMN_HEADER
            isValidSheet = False
        End If
        
        If IsValidCellColumn(xlDataWorksheet, SEVERITY_COLUMN_HEADER) = False Then
            strBadHeaders = strBadHeaders & "," & SEVERITY_COLUMN_HEADER
            isValidSheet = False
        End If
        
        If IsValidCellColumn(xlDataWorksheet, PASSED_COLUMN_HEADER) = False Then
            strBadHeaders = strBadHeaders & ", " & PASSED_COLUMN_HEADER
            isValidSheet = False
        End If
        
        If isValidSheet = False Then
            MsgBox "You must have a valid worksheet to run the macro.  " & _
            "Your are missing the following column labels in columns A-J:  " & _
            strBadHeaders
            
            ValidateHeaderCells = False
            Exit Function
        End If
End Function
Sub generate_pivot_table()
Attribute generate_pivot_table.VB_ProcData.VB_Invoke_Func = " \n14"
'
' generate_pivot_table Macro
'

'
    Dim xlDataWorksheet As Worksheet
    Dim isValidSheet As Boolean
    
    isValidSheet = ValidateHeaderCells()
    If isValidSheet = False Then
        Exit Sub
    End If
    Set xlDataWorksheet = ActiveWorkbook.Worksheets(1)
    
    
        


        Call xlDataWorksheet.Activate
    Selection.ColumnWidth = 14
    Columns("F:F").ColumnWidth = 61.29
    Columns("F:F").Select
    With Selection
        .HorizontalAlignment = xlGeneral
        .VerticalAlignment = xlBottom
        .WrapText = True
        .Orientation = 0
        .AddIndent = False
        .IndentLevel = 0
        .ShrinkToFit = False
        .ReadingOrder = xlContext
        .MergeCells = False
    End With
    Rows("1:1").Select
    Selection.Font.Bold = True
    With Selection.Interior
        .Pattern = xlSolid
        .PatternColorIndex = xlAutomatic
        .ThemeColor = xlThemeColorDark2
        .TintAndShade = -9.99786370433668E-02
        .PatternTintAndShade = 0
    End With
    Range("D2").Select
    Columns("D:D").ColumnWidth = 11.29
    xlDataWorksheet.Select
    xlDataWorksheet.Name = "Data"
    Cells.Select
    Sheets.Add
    Sheets("Sheet1").Name = "Totals"
    ActiveWorkbook.PivotCaches.Create(SourceType:=xlDatabase, SourceData:= _
        "data!R1C1:R1048576C10", Version:=6).CreatePivotTable TableDestination:= _
        "Totals!R3C1", TableName:="PivotTable1", DefaultVersion:=6
    Sheets("Totals").Select
    Cells(3, 1).Select
    ActiveSheet.Shapes.AddChart2(201, xlColumnClustered).Select
    ActiveChart.SetSourceData Source:=Range("Totals!$A$3:$C$20")
    ActiveChart.Parent.Delete
    With ActiveSheet.PivotTables("PivotTable1").PivotFields("Host")
        .Orientation = xlRowField
        .Position = 1
    End With
    With ActiveSheet.PivotTables("PivotTable1").PivotFields("Passed")
        .Orientation = xlRowField
        .Position = 2
    End With
    ActiveSheet.PivotTables("PivotTable1").PivotFields("Passed").Orientation = _
        xlHidden
    With ActiveSheet.PivotTables("PivotTable1").PivotFields("Severity")
        .Orientation = xlRowField
        .Position = 2
    End With
    ActiveSheet.PivotTables("PivotTable1").AddDataField ActiveSheet.PivotTables( _
        "PivotTable1").PivotFields("Passed"), "Count of Passed", xlCount
    Range("B3").Select
    ActiveSheet.PivotTables("PivotTable1").PivotFields("Count of Passed").Caption _
        = "Totals"
    With ActiveSheet.PivotTables("PivotTable1").PivotFields("Passed")
        .Orientation = xlPageField
        .Position = 1
    End With
    ActiveSheet.PivotTables("PivotTable1").PivotFields("Passed").ClearAllFilters
    ActiveSheet.PivotTables("PivotTable1").PivotFields("Passed").CurrentPage = _
        "False "
    With ActiveSheet.PivotTables("PivotTable1").PivotFields("Id")
        .Orientation = xlRowField
        .Position = 3
    End With
    With ActiveSheet.PivotTables("PivotTable1").PivotFields("Version")
        .Orientation = xlRowField
        .Position = 4
    End With
    ActiveSheet.PivotTables("PivotTable1").PivotFields("Version").Orientation = _
        xlHidden
    With ActiveSheet.PivotTables("PivotTable1").PivotFields("Group Title")
        .Orientation = xlRowField
        .Position = 4
    End With
    With ActiveSheet.PivotTables("PivotTable1").PivotFields("Version")
        .Orientation = xlRowField
        .Position = 5
    End With
    With ActiveSheet.PivotTables("PivotTable1").PivotFields("Description")
        .Orientation = xlRowField
        .Position = 6
    End With
    
    Dim PF                    As PivotField
    Dim PT                    As PivotTable
    Dim PI                    As PivotItem
    
    Set PT = ActiveSheet.PivotTables("PivotTable1")

    For Each PF In PT.PivotFields
        If PF.Orientation <> xlPageField Then
            For Each PI In PF.PivotItems
                PI.ShowDetail = False
            Next PI
        End If
    Next PF

  
    Sheets("Data").Select
    Sheets("Data").Move Before:=Sheets(1)
    Cells.Select
    Selection.AutoFilter
End Sub
