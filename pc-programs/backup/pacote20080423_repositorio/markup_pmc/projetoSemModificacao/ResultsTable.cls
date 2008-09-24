VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "ResultsTable"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False

'Alberto Pedroso, Feb/98
'Result Table

Private table As New collection
Const Delimiter = ","
'--------------------
Private mErr As New clsErrList
Const errIDObj As String = "220"

Public Function count()
 Const errIDMet As String = "01"
 '-----------------------------
 On Error GoTo errLOG
 
 count = table.count
 Exit Function
errLOG:
  Dim conf As New clsConfig
  With mErr
    conf.LoadPublicValues
    .LoadErr conf
    .BuildLog errIDObj & errIDMet, conf
  End With
  Set conf = Nothing
End Function
Public Sub AddNew(line As String)
 Dim tableEntry As New ResultsTableEntry
 Dim pos As Long, DelimiterPos As Long
 Const errIDMet As String = "02"
 '-----------------------------
 On Error GoTo errLOG
  
 pos = 1
 DelimiterPos = InStr(line, Delimiter)
 tableEntry.Element = Mid(line, pos, DelimiterPos - 1)
 '
 pos = DelimiterPos + 1
 DelimiterPos = InStr(pos, line, Delimiter)
 tableEntry.SubElement = Mid(line, pos, DelimiterPos - pos)
 '
 pos = DelimiterPos + 1
 DelimiterPos = InStr(pos, line, Delimiter)
 tableEntry.StartPos = val(Mid(line, pos, DelimiterPos - pos)) + 1
 '
 pos = DelimiterPos + 1
 DelimiterPos = InStr(pos, line, Delimiter)
 tableEntry.EndPos = val(Mid(line, pos, DelimiterPos - pos)) + 1
 '
 pos = DelimiterPos + 1
 DelimiterPos = InStr(pos, line, Delimiter)
 tableEntry.Level = val(Mid(line, pos, DelimiterPos - pos))
 '
 pos = DelimiterPos + 1
 If val(Mid(line, pos)) = 0 Then
  tableEntry.Terminal = False
 Else
  tableEntry.Terminal = True
 End If
 '
 table.add tableEntry
 Exit Sub
errLOG:
  Dim conf As New clsConfig
  With mErr
    conf.LoadPublicValues
    .LoadErr conf
    .BuildLog errIDObj & errIDMet, conf
  End With
  Set conf = Nothing
End Sub
Public Function GetItem(i As Long) As ResultsTableEntry
 Const errIDMet As String = "03"
 '-----------------------------
 On Error GoTo errLOG
 
 Set GetItem = table.Item(i)
 Exit Function
errLOG:
  Dim conf As New clsConfig
  With mErr
    conf.LoadPublicValues
    .LoadErr conf
    .BuildLog errIDObj & errIDMet, conf
  End With
  Set conf = Nothing
End Function
Public Sub Clean()
 Dim i As Long
 Const errIDMet As String = "04"
 '-----------------------------
 On Error GoTo errLOG
 
 For i = 1 To table.count
  table.remove 1
 Next i
 Exit Sub
errLOG:
  Dim conf As New clsConfig
  With mErr
    conf.LoadPublicValues
    .LoadErr conf
    .BuildLog errIDObj & errIDMet, conf
  End With
  Set conf = Nothing
End Sub
Private Sub Class_Terminate()
 Const errIDMet As String = "05"
 '-----------------------------
 On Error GoTo errLOG
 
 Clean
 Exit Sub
errLOG:
  Dim conf As New clsConfig
  With mErr
    conf.LoadPublicValues
    .LoadErr conf
    .BuildLog errIDObj & errIDMet, conf
  End With
  Set conf = Nothing
End Sub