VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "ClsJournalStatusAction"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Private history As New ClsHistory
Private mvarCodeStatus As ColCode
Private Const valid = "DSC"
Private Const visible = "DS"

Function changed(Mfn As Long) As Boolean
    Dim h As ClsHistory
    
    Set h = journalDAO.getHistory(Mfn)
    changed = (journalDAO.tagHistory(h) <> journalDAO.tagHistory(history))
End Function

Property Set myHistory(h As ClsHistory)
    Set history = h
End Property
Property Get myHistory() As ClsHistory
    Set myHistory = history
End Property

Public Property Get mycodeStatus() As ColCode
    Set mycodeStatus = mvarCodeStatus
End Property
Public Property Set mycodeStatus(codeStatus As ColCode)
    Dim c As ClCode
    Dim i As Long
    
    Set mvarCodeStatus = New ColCode
    For i = 1 To codeStatus.count
        If InStr(valid, codeStatus(i).Code) > 0 Then
            Set c = New ClCode
            Set c = mvarCodeStatus.add(codeStatus(i).Code)
            c.Code = codeStatus(i).Code
            c.value = codeStatus(i).value
            c.unabled = (InStr(visible, codeStatus(i).Code) = 0)
        End If
    Next
End Property
Function validate(prevStatusDate As String, prevStatus As String, statusDate As String, status As String) As Boolean
    
        If checkDate(prevStatusDate, statusDate) Then
            If checkStatus(prevStatus, status) Then
                validate = True
            End If
        End If
    
End Function

Function addNewStatus(statusDate As String, status As String) As Boolean
    Dim js As New ClsJournalStatus
    
        js.status = status
        js.statusDate = statusDate
        Call history.add(js, history.count + 1)
    'If validate(prevStatusDate, prevStatus, statusDate, status) Then
    'End If
End Function

Function checkDateFormat(statusDate As String, err As String) As Boolean
    Dim r As Boolean
    
    If statusDate Like "####[01]#[0123]#" Then
        r = True
    Else
        err = "00101"
    End If
    checkDateFormat = r
End Function
Sub showWarning(warning As String)

    Dim err As String
    Dim msgParam As New ClsParams
    Select Case warning
    Case "MISSING_EXIT_DATE"
        err = "00107"
    Case "MISSING_ENTRY_DATE"
        err = "00108"
    Case "MISSING_STATUS"
        err = "00109"
    End Select
    
    If Len(err) > 0 Then Call ErrorMessages.display(err, msgParam)
    
End Sub

Function checkDate(previousDate As String, currDate As String) As Boolean
    Dim err As String
    Dim msgParam As New ClsParams
    
    If checkDateFormat(currDate, err) Then
        If previousDate >= currDate Then
            err = "00101"
            Call msgParam.add(currDate, 1)
            Call msgParam.add(previousDate, 2)
        End If
    End If
    If Len(err) > 0 Then Call ErrorMessages.display(err, msgParam)
    checkDate = (Len(err) = 0)
End Function
Function checkStatus(previousStatus As String, status As String) As Boolean
    Dim msgParam As New ClsParams
    Dim err As String
    
    If Not isValidStatusTransition(previousStatus, status) Then
        err = "00102"
        
        Call msgParam.add(getCode(mycodeStatus, previousStatus).value, 1)
        If Len(status) > 0 Then
            Call msgParam.add(getCode(mycodeStatus, status).value, 2)
        Else
        Call msgParam.add("", 2)
        End If
    End If
        If Len(err) > 0 Then Call ErrorMessages.display(err, msgParam)

    checkStatus = (Len(err) = 0)
End Function

Function isValidStatusTransition(previousStatus As String, status As String) As Boolean

    Dim s As String
    Dim r As Boolean
    
    s = previousStatus + status
    If previousStatus <> status And Len(status) = 1 And Len(previousStatus) = 1 Then
    Select Case s
    Case "DC"
        r = True
    Case "DS"
        r = False
    Case "SC"
        r = True
    Case "SD"
        r = False
    Case "CS"
        r = True
    Case "CD"
        r = True
    Case "_C"
        r = True
    End Select
    End If
    isValidStatusTransition = r
End Function

Function loadHistory(Mfn As Long)
    Set history = journalDAO.getHistory(Mfn)
End Function

Function getDataToSave() As String
    getDataToSave = journalDAO.tagHistory(history)
End Function