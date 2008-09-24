VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "clsInterface"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False

Public stitle As String
Public volid As String
Public issueno As String
Public supplvol As String
Public supplno As String
Public dateiso As String
Public issn As String
Public status As String
Public pii As String
Public order As String
Public pages As String
Public RVPdate As String
Public ahpdate As String


'------------------------
Public ccodeAbbr As String
Public seccodeAbbr As String
Public versionAbbr As String
Public doctopicAbbr As String
Public languageAbbr As String
Public toccodeAbbr As String
Public typeAbbr As String
Public sponsorAbbr As String
'-----------------------
'Public attributeI As String
'Public attributeII As String
'Public attributeIII As String
'
Public attributeCount As Integer
Private attributes() As String
'----------------------------
Private mErr As New clsErrList
Const errIDObj As String = "211"

Property Get attrib(i As Integer) As String
    If i <= attributeCount Then
        attrib = attributes(i)
    End If
End Property

Property Let attrib(i As Integer, att As String)
    If i > attributeCount Then
        attributeCount = i
        ReDim Preserve attributes(i)
    End If
    attributes(i) = att
End Property

Public Sub ShowFrmArticle(Conf As clsConfig)
  Dim i As Integer, j  As Integer, l As New collection, f As Integer
  Dim aux As String, val As String, inic As Integer, fim As Integer
  Const errIDMet As String = "01"
  '-----------------------------
  On Error GoTo ERRLOG
  
  With frmArticle
    f = FreeFile
    
    Open Conf.directory & Conf.fileTemp For Input As #f
    Input #f, aux, val
    .SelectIssueId (val)
    'If Len(val) > 0 Then
    '    .ComboBox_issueid.text = val
    'Else
    '    frmArticle.OrdIssueList val
    'End If
    
    Input #f, aux, val: Call .SelectComboItem(.ComboBox_ccode, val) 'If Len(val) > 0 Then .ComboBox_ccode.text = val
    Input #f, aux: Line Input #f, val: Call .SelectComboItem(.ComboBox_seccode, val) 'If Len(val) > 0 Then .ComboBox_seccode.text = val
    Input #f, aux, val: If Len(val) > 0 Then .TextBox_pii.text = val
    Input #f, aux, val: If Len(val) > 0 Then .TextBox_order.text = val
    Input #f, aux: Line Input #f, val: .TextBox_pages.text = val
    Input #f, aux, val: If Len(val) > 0 Then Call .SelectComboItem(.ComboBox_version, val)
    Input #f, aux, val: If Len(val) > 0 Then Call .SelectComboItem(.ComboBox_doctopic, val)
    Input #f, aux, val: If Len(val) > 0 Then Call .SelectComboItem(.ComboBox_language, val)
    Input #f, aux: Line Input #f, val
    If Len(val) > 0 Then
    inic = 1
    fim = InStr(val, ",")
    If fim <> 0 Then
      While fim <> 0
        l.add Mid$(val, inic, fim - inic): inic = fim + 1
        fim = InStr(inic, val, ",")
      Wend
      l.add Mid(val, inic, Len(val) - inic + 1)
      For j = 1 To l.count
        For i = 0 To .ListBox_type.ListCount - 1 'listV.Count
          If l.Item(j) = .ListBox_type.list(i) Then
            .ListBox_type.Selected(i) = True
          End If
        Next i
      Next j
    Else
      l.add val
      For i = 0 To .ListBox_type.ListCount - 1
        If val = .ListBox_type.list(i) Then
          .ListBox_type.Selected(i) = True: Exit For
        End If
      Next i
    End If
    End If
    Input #f, aux, val
    If .ComboBox_toccode.Enabled = True Then
      If val <> Empty Then
        .ComboBox_toccode.text = val
      Else
        .ComboBox_toccode.ListIndex = 1
      End If
    End If
    Input #f, aux, val
        
    If Len(val) > 0 Then Call .SelectComboItem(.ComboBox_sponsor, val) ': .ComboBox_sponsor.ListIndex = 0
    
    Input #f, aux, val
    If Len(val) > 0 Then .TextBox_rvpdate.text = val
    'MsgBox "ok"
    Input #f, aux, val
    If Len(val) > 0 Then .TextBox_ahpdate.text = val
    
    .ComboBox_seccode.SetFocus
    .Caption = Conf.titlefrmArticle
    .CommandButton_OK.Caption = Conf.textOK
    .CommandButton_CANCEL.Caption = Conf.textCANCEL
    .Frame_auto.Caption = Conf.titleFields
    'If .ComboBox_issueid.ListCount > 0 Then .OrdIssueList (.ComboBox_issueid.list(0))
    SetPositionFrms Conf
    .show
  End With
  Close #f
  Set l = Nothing
  Exit Sub
ERRLOG:
  With mErr
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
  Close #f
  Set l = Nothing
End Sub

Public Sub EndFrmArticle()
  Const errIDMet As String = "02"
  '-----------------------------
  On Error GoTo ERRLOG
  
  Unload frmArticle
  Exit Sub
ERRLOG:
  Dim Conf As New clsConfig
  With mErr
    Conf.LoadPublicValues
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
  Set Conf = Nothing
End Sub

Public Sub SetFrmArticle(issuel As clsIssueList, attl As clsAttrList, tag As String)
  Dim issue As New clsIssue, att As New clsAttribute
  Dim i As Integer, v As New clsValue
  Const errIDMet As String = "03"
  '-----------------------------
  On Error GoTo ERRLOG
  
  With frmArticle
    If tag = "article" Then
      .ComboBox_toccode.Enabled = False
      .Frame_toccode.Enabled = False
    ElseIf tag = "text" Then
      .ComboBox_toccode.Enabled = True
      .Frame_toccode.Enabled = True
    End If
    ' 20071214 loadIssueList
    
     Call .loadIssueList(issuel)
    
    Set att = attl.ReturnAttr("ccode")
    .ComboBox_ccode.Clear
    For i = 1 To att.ReturnCount
      Set v = att.ReturnValue(str$(i))
      .ComboBox_ccode.AddItem v.extValue
    Next i
    Set att = attl.ReturnAttr("version")
    .ComboBox_version.Clear
    For i = 1 To att.ReturnCount
      Set v = att.ReturnValue(str$(i))
      .ComboBox_version.AddItem v.extValue
    Next i
    Set att = attl.ReturnAttr("doctopic")
    .ComboBox_doctopic.Clear
    For i = 1 To att.ReturnCount
      Set v = att.ReturnValue(str$(i))
      .ComboBox_doctopic.AddItem v.extValue
    Next i
    Set att = attl.ReturnAttr("language")
    .ComboBox_language.Clear
    For i = 1 To att.ReturnCount
      Set v = att.ReturnValue(str$(i))
      .ComboBox_language.AddItem v.extValue
    Next i
    If tag = "text" Then
      Set att = attl.ReturnAttr("toccode")
      .ComboBox_toccode.Clear
      For i = 1 To att.ReturnCount
        Set v = att.ReturnValue(str$(i))
        .ComboBox_toccode.AddItem v.extValue
      Next i
    End If
    Set att = attl.ReturnAttr("sponsor")
    .ComboBox_sponsor.Clear
    For i = 1 To att.ReturnCount
      Set v = att.ReturnValue(str$(i))
      .ComboBox_sponsor.AddItem v.extValue
    Next i
    Set att = attl.ReturnAttr("illustrative material type")
    .ListBox_type.Clear
    For i = 1 To att.ReturnCount
      Set v = att.ReturnValue(str$(i))
      .ListBox_type.AddItem v.extValue
    Next i
  End With
  Set issue = Nothing: Set att = Nothing: Set v = Nothing
  Exit Sub
ERRLOG:
  Dim Conf As New clsConfig
  With mErr
    Conf.LoadPublicValues
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
  Set Conf = Nothing: Set issue = Nothing: Set att = Nothing: Set v = Nothing
End Sub

Public Sub ExitFrmArticle(Conf As clsConfig, attl As clsAttrList, isL As clsIssueList, Optional id As String)
  Dim t As String, i As Integer, at As New clsAttribute
  Dim l As New collection, f As Integer
  Const errIDMet As String = "04"
  '-----------------------------
  On Error GoTo ERRLOG
  
  f = FreeFile
  With frmArticle
    Open Conf.directory & Conf.fileTemp For Output As #f
    Print #f, "issueid"; ","; .ComboBox_issueid.text
    Print #f, "ccode"; ","; .ComboBox_ccode.text
    Print #f, "seccode"; ","; .ComboBox_seccode.text
    Print #f, "pii"; ","; .TextBox_pii.text
    Print #f, "order"; ","; .TextBox_order.text
    Print #f, "pages"; ","; .TextBox_pages.text
    Print #f, "version"; ","; .ComboBox_version.text
    Print #f, "doctopic"; ","; .ComboBox_doctopic.text
    Print #f, "language"; ","; .ComboBox_language.text
    For i = 0 To .ListBox_type.ListCount - 1
      If .ListBox_type.Selected(i) = True Then
        l.add .ListBox_type.list(i)
        t = t & .ListBox_type.list(i) & ","
      End If
    Next i
    t = Mid(t, 1, Len(t) - 1)
    Print #f, "type"; ","; t
    Print #f, "toccode"; ","; .ComboBox_toccode.text
    Print #f, "sponsor"; ","; .ComboBox_sponsor.text
    Print #f, "new-pid"; ","; .TextBox_rvpdate.text
    Print #f, "ahpdate"; ","; .TextBox_ahpdate.text
    Close #f
    'alteracao
    id = .ComboBox_issueid.text
    '--
  End With
  SetDefaultValueAbbrArticle attl, l, isL
  
  Set at = Nothing: Set l = Nothing
  Exit Sub
ERRLOG:
  With mErr
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
  Set at = Nothing: Set l = Nothing
End Sub

Public Sub SetDefaultValueAbbrArticle(attl As clsAttrList, l As collection, isL As clsIssueList)
  Dim at As New clsAttribute, i As Integer, issue As New clsIssue
  Const errIDMet As String = "05"
  '-----------------------------
  On Error GoTo ERRLOG
  
  With frmArticle
    Set at = attl.ReturnAttr("ccode")
    ccodeAbbr = at.ReturnValue(.ComboBox_ccode.text).abbrValue
    '
    Set issue = isL.ReturnIssue(.ComboBox_issueid.text)
    'seccodeAbbr = issue.ReturnSec(.ComboBox_seccode.text).abbrValue
    seccodeAbbr = issue.ReturnSec(str$(.ComboBox_seccode.ListIndex + 1)).abbrValue
    '
    Set at = attl.ReturnAttr("version")
    'versionAbbr = at.ReturnValue(.ComboBox_version.text).abbrValue
    versionAbbr = .ComboBox_version.text
    '
    Set at = attl.ReturnAttr("doctopic")
    doctopicAbbr = at.ReturnValue(.ComboBox_doctopic.text).abbrValue
    '
    Set at = attl.ReturnAttr("language")
    languageAbbr = at.ReturnValue(.ComboBox_language.text).abbrValue
    '
    If .ComboBox_toccode.Enabled = True Then
      Set at = attl.ReturnAttr("toccode")
      toccodeAbbr = at.ReturnValue(.ComboBox_toccode.text).abbrValue
    End If
    '
    Set at = attl.ReturnAttr("illustrative material type")
    Select Case l.count
      Case 0
        typeAbbr = "nd"
      Case 1
        typeAbbr = at.ReturnValue(l.Item(1)).abbrValue
      Case Else
        typeAbbr = Chr(34)
        For i = 1 To l.count
          typeAbbr = typeAbbr & at.ReturnValue(l.Item(i)).abbrValue & " "
        Next i
        typeAbbr = Trim$(typeAbbr): typeAbbr = typeAbbr & Chr(34)
    End Select
    '
    On Error Resume Next
    Set at = attl.ReturnAttr("sponsor")
    sponsorAbbr = at.ReturnValue(.ComboBox_sponsor.text).abbrValue
    If err.Number > 0 Then
      sponsorAbbr = Trim$(.ComboBox_sponsor.text)
      If InStr(sponsorAbbr, Space(1)) > 0 Then
        sponsorAbbr = Chr(34) & sponsorAbbr & Chr(34)
      End If
    End If
    On Error GoTo ERRLOG
    '
    stitle = Chr(34) & .TextBox_stitle.text & Chr(34)
    '--20000503 -Revista Cer�mica
    '--If InStr(stitle, " ") <> 0 Then
    '--stitle = Chr(34) & stitle & Chr(34)
    '--End If
    volid = .TextBox_volid.text
    issueno = .TextBox_issueno.text
    supplvol = .TextBox_supplvol.text
    supplno = .TextBox_supplno.text
    dateiso = .TextBox_dateiso.text
    issn = .TextBox_issn.text
    status = .TextBox_status.text
    pii = .TextBox_pii.text
    order = .TextBox_order.text
    pages = .TextBox_pages.text
    RVPdate = .TextBox_rvpdate.text
    ahpdate = .TextBox_ahpdate.text
    If InStr(pages, ",") <> 0 Then
      pages = Chr(34) & pages & Chr(34)
    End If
  End With
  
  Set at = Nothing: Set issue = Nothing
  Exit Sub
ERRLOG:
  Dim Conf As New clsConfig
  With mErr
    Conf.LoadPublicValues
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
  Set Conf = Nothing: Set at = Nothing: Set issue = Nothing
End Sub

Public Sub SetFrmAttribute(attrl As clsAttrList, linkl As clsLkList, tag As String, issueList As clsIssueList, id As String)
  Dim at As New clsAttribute, lk As New clsLink, v As New clsValue
  Dim i As Integer, j As Integer
  
  On Error Resume Next
  
  Set lk = linkl.ReturnLink(tag)
  
  For i = 1 To lk.ReturnCount
    With frmAttribute
      .SetFormHeight (i)
      .Frame1.Caption = tag
      Set at = attrl.ReturnAttr(lk.ReturnAttr(str$(i)))
      If tag = "keyword" Then
        If lk.ReturnAttr(str$(i)) = "keyword priority level" Then
          at.attrName = "type"
        End If
      End If
        
      .ObjLabel(i).Visible = True: .ObjLabel(i).Caption = at.attrName
          '----alteracao
      Select Case at.attrName
        Case "scheme", "standard"
            Dim isse As New clsIssue
              '----
            .ObjCombo(i).Visible = True: .ObjCombo(i).Clear
            Set isse = issueList.ReturnIssue(id)
            If at.attrName = "scheme" Then
                For j = 1 To isse.scheme.count
                    .ObjCombo(i).AddItem isse.scheme.Item(j)
                Next j
                .ObjCombo(i).text = isse.scheme.Item(1)
            Else
                For j = 1 To isse.standard.count
                    .ObjCombo(i).AddItem isse.standard.Item(j)
                Next j
                .ObjCombo(i).text = isse.standard.Item(1)
            End If
        Case Else
            If at.ReturnCount > 1 Then
                .ObjCombo(i).Visible = True: .ObjCombo(i).Clear
                For j = 1 To at.ReturnCount
                  .ObjCombo(i).AddItem at.ReturnValue(str$(j)).extValue
                Next j
                .ObjCombo(i).text = at.lastInsertedValue
            Else
                .ObjText(i).Visible = True
                .ObjText(i).text = at.lastInsertedValue
            End If
        End Select
          '-------------
    End With
  Next i
  With frmAttribute
    If .flagChange = False Then
      .TextBox = selection.text
    Else
      Dim m As New clsMarkup, tg As String, Conf As New clsConfig
      Dim iPos As Long, fPos As Long
      '---------------
      Conf.LoadPublicValues
      '--------------------
      tg = Trim$(selection.text)
      With selection
        .start = .End
      End With
      m.findText Conf.TAGC, True, , iPos
      With selection
        .start = .End
      End With
      m.findText Conf.ETAGO & tg & Conf.TAGC, True, fPos
      .TextBox = ActiveDocument.range(start:=iPos + 1, End:=fPos - 1).text
      With selection
        .start = iPos: .End = iPos
      End With
      Set m = Nothing: Set Conf = Nothing
    End If
    If .flagConv = True Then
      .CB_Conv.Visible = True
    Else
      .CB_Conv.Visible = False
    End If
    .CommandButton_OK.SetFocus
  End With
  Set at = Nothing: Set lk = Nothing: Set v = Nothing
End Sub

Public Sub SetFrmAttribute_old(attrl As clsAttrList, linkl As clsLkList, tag As String, issueList As clsIssueList, id As String)
  Dim at As New clsAttribute, lk As New clsLink, v As New clsValue
  Dim i As Integer, j As Integer
  
  On Error Resume Next
  
  Set lk = linkl.ReturnLink(tag)
  For i = 1 To lk.ReturnCount
    With frmAttribute
      .Frame1.Caption = tag
      Set at = attrl.ReturnAttr(lk.ReturnAttr(str$(i)))
      If tag = "keyword" Then
        If lk.ReturnAttr(str$(i)) = "keyword priority level" Then
          at.attrName = "type"
        End If
      End If
      Select Case i
        Case 1
          .lb_Attrib1.Visible = True: .lb_Attrib1.Caption = at.attrName
          '----alteracao
          Select Case at.attrName
            Case "scheme", "standard"
              Dim isse As New clsIssue
              '----
              .ComboBox_attrib1.Visible = True: .ComboBox_attrib1.Clear
              Set isse = issueList.ReturnIssue(id)
              If at.attrName = "scheme" Then
                For j = 1 To isse.scheme.count
                    .ObjCombo(i).AddItem isse.scheme.Item(j)
                Next j
                .ObjCombo(i).text = isse.scheme.Item(1)
              Else
                For j = 1 To isse.standard.count
                    .ObjCombo(i).AddItem isse.standard.Item(j)
                Next j
                .ObjCombo(i).text = isse.standard.Item(1)
              End If
            Case Else
              If at.ReturnCount > 1 Then
                .ComboBox_attrib1.Visible = True: .ComboBox_attrib1.Clear
                For j = 1 To at.ReturnCount
                  .ComboBox_attrib1.AddItem at.ReturnValue(str$(j)).extValue
                Next j
                .ComboBox_attrib1.text = at.lastInsertedValue
              Else
                .TextBox_attrib1.Visible = True
                .TextBox_attrib1.text = at.lastInsertedValue
              End If
          End Select
          '-------------
        Case 2
          .lb_Attrib2.Visible = True: .lb_Attrib2.Caption = at.attrName
          If at.ReturnCount > 1 Then
            .ComboBox_attrib2.Visible = True: .ComboBox_attrib2.Clear
            For j = 1 To at.ReturnCount
              .ComboBox_attrib2.AddItem at.ReturnValue(str$(j)).extValue
            Next j
            .ComboBox_attrib2.text = at.lastInsertedValue
          Else
            .TextBox_attrib2.Visible = True
            .TextBox_attrib2.text = at.lastInsertedValue
          End If
        Case 3
          .lb_Attrib3.Visible = True: .lb_Attrib3.Caption = at.attrName
          If at.ReturnCount > 1 Then
            .ComboBox_attrib3.Visible = True: .ComboBox_attrib3.Clear
            For j = 1 To at.ReturnCount
              .ComboBox_attrib3.AddItem at.ReturnValue(str$(j)).extValue
            Next j
            .ComboBox_attrib3.text = at.lastInsertedValue
          Else
            .TextBox_attrib3.Visible = True
            .TextBox_attrib3.text = at.lastInsertedValue
          End If
      End Select
    End With
  Next i
  With frmAttribute
    If .flagChange = False Then
      .TextBox = selection.text
    Else
      Dim m As New clsMarkup, tg As String, Conf As New clsConfig
      Dim iPos As Long, fPos As Long
      '---------------
      Conf.LoadPublicValues
      '--------------------
      tg = Trim$(selection.text)
      With selection
        .start = .End
      End With
      m.findText Conf.TAGC, True, , iPos
      With selection
        .start = .End
      End With
      m.findText Conf.ETAGO & tg & Conf.TAGC, True, fPos
      .TextBox = ActiveDocument.range(start:=iPos + 1, End:=fPos - 1).text
      With selection
        .start = iPos: .End = iPos
      End With
      Set m = Nothing: Set Conf = Nothing
    End If
    If .flagConv = True Then
      .CB_Conv.Visible = True
    Else
      .CB_Conv.Visible = False
    End If
    .CommandButton_OK.SetFocus
  End With
  Set at = Nothing: Set lk = Nothing: Set v = Nothing
End Sub

Public Sub ShowFrmAttribute(Conf As clsConfig)
  Const errIDMet As String = "06"
  '-----------------------------
  On Error GoTo ERRLOG
  
  With frmAttribute
    .Caption = Conf.titlefrmAttribute
    .CommandButton_OK.Caption = Conf.textOK
    .CommandButton_CANCEL.Caption = Conf.textCANCEL
    SetPositionFrms Conf
    .show
  End With
  Exit Sub
ERRLOG:
  With mErr
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
End Sub

Public Sub EndFrmAttribute()
  Dim flag As Boolean
  Const errIDMet As String = "07"
  '-----------------------------
  On Error GoTo ERRLOG
  
  flag = frmAttribute.CB_Conv.value
  Unload frmAttribute
  frmAttribute.CB_Conv.value = flag
  Exit Sub
ERRLOG:
  Dim Conf As New clsConfig
  With mErr
    Conf.LoadPublicValues
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
  Set Conf = Nothing
End Sub

Public Sub ExitFrmAttribute(attl As clsAttrList)
  Dim at As New clsAttribute
  Dim i As Integer
  Const errIDMet As String = "08"
  '-----------------------------
  On Error GoTo ERRLOG
  
  For i = 1 To 5
    With frmAttribute
    If .ObjLabel(i).Visible = True Then
      If .ObjLabel(i).Caption = "type" Then
        Set at = attl.ReturnAttr("keyword priority level")
        .ObjLabel(i).Caption = "keyword priority level"
      Else
        Set at = attl.ReturnAttr(.ObjLabel(i).Caption)
      End If
      If .ObjText(i).Visible = True Then
        at.lastInsertedValue = .ObjText(i).text
      ElseIf .ObjCombo(i).Visible = True Then
        at.lastInsertedValue = .ObjCombo(i).text
      End If
    End If
    End With
  Next
  SetDefaultValueAbbrAttribute attl
  Exit Sub
ERRLOG:
  Dim Conf As New clsConfig
  With mErr
    Conf.LoadPublicValues
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
  Set Conf = Nothing
End Sub

Public Sub ExitFrmAttribute_Old(attl As clsAttrList)
  Dim at As New clsAttribute
  Const errIDMet As String = "08"
  '-----------------------------
  On Error GoTo ERRLOG
  
  With frmAttribute
    If .lb_Attrib1.Visible = True Then
      If .lb_Attrib1.Caption = "type" Then
        Set at = attl.ReturnAttr("keyword priority level")
        .lb_Attrib1.Caption = "keyword priority level"
      Else
        Set at = attl.ReturnAttr(.lb_Attrib1.Caption)
      End If
      If .TextBox_attrib1.Visible = True Then
        at.lastInsertedValue = .TextBox_attrib1.text
      ElseIf .ComboBox_attrib1.Visible = True Then
        at.lastInsertedValue = .ComboBox_attrib1.text
      End If
    End If
    If .lb_Attrib2.Visible = True Then
      If .lb_Attrib2.Caption = "type" Then
        Set at = attl.ReturnAttr("keyword priority level")
        .lb_Attrib2.Caption = "keyword priority level"
      Else
        Set at = attl.ReturnAttr(.lb_Attrib2.Caption)
      End If
      If .TextBox_attrib2.Visible = True Then
        at.lastInsertedValue = .TextBox_attrib2.text
      ElseIf .ComboBox_attrib2.Visible = True Then
        at.lastInsertedValue = .ComboBox_attrib2.text
      End If
    End If
    If .lb_Attrib3.Visible = True Then
      If .lb_Attrib3.Caption = "type" Then
        Set at = attl.ReturnAttr("keyword priority level")
        .lb_Attrib3.Caption = "keyword priority level"
      Else
        Set at = attl.ReturnAttr(.lb_Attrib3.Caption)
      End If
      If .TextBox_attrib3.Visible = True Then
        at.lastInsertedValue = .TextBox_attrib3.text
      ElseIf .ComboBox_attrib3.Visible = True Then
        at.lastInsertedValue = .ComboBox_attrib3.text
      End If
    End If
  End With
  SetDefaultValueAbbrAttribute attl
  Exit Sub
ERRLOG:
  Dim Conf As New clsConfig
  With mErr
    Conf.LoadPublicValues
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
  Set Conf = Nothing
End Sub

Public Sub SetDefaultValueAbbrAttribute(attl As clsAttrList)
  Dim at As New clsAttribute
  Dim i As Integer
  Const errIDMet As String = "09"
  '-----------------------------
  On Error GoTo ERRLOG
  
  For i = 1 To 5
  With frmAttribute
    
    If .ObjLabel(i).Visible = True Then
    
      If .ObjText(i).Visible = True Then
      
        attrib(i) = .ObjText(i).text
        
        If Len(Trim$(attrib(i))) <> 0 Then
        
          '--If InStr(attrib(i), " ") <> 0 Then
          
            attrib(i) = Chr(34) & attrib(i) & Chr(34)
          '--End If
        End If
      ElseIf .ObjCombo(i).Visible = True Then
      
        Set at = attl.ReturnAttr(.ObjLabel(i).Caption)
        
        With at
          attrib(i) = .ReturnValue(.lastInsertedValue).abbrValue
          
        End With
      End If
    End If
  End With
  Next
  Set at = Nothing
  Exit Sub
ERRLOG:
  Dim Conf As New clsConfig
  With mErr
    Conf.LoadPublicValues
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
  Set Conf = Nothing: Set at = Nothing
End Sub

Public Sub SetDefaultValueAbbrAttribute_old(attl As clsAttrList)
  Dim at As New clsAttribute
  Const errIDMet As String = "09"
  '-----------------------------
  On Error GoTo ERRLOG
  
  With frmAttribute
    If .lb_Attrib1.Visible = True Then
      If .TextBox_attrib1.Visible = True Then
        attributeI = .TextBox_attrib1.text
        If Len(Trim$(attributeI)) <> 0 Then
          If InStr(attributeI, " ") <> 0 Then
            attributeI = Chr(34) & attributeI & Chr(34)
          End If
        End If
      ElseIf .ComboBox_attrib1.Visible = True Then
        Set at = attl.ReturnAttr(.lb_Attrib1.Caption)
        With at
          attributeI = .ReturnValue(.lastInsertedValue).abbrValue
        End With
      End If
    End If
    If .lb_Attrib2.Visible = True Then
      If .TextBox_attrib2.Visible = True Then
        attributeII = .TextBox_attrib2.text
        If Len(Trim$(attributeII)) <> 0 Then
          If InStr(attributeII, " ") <> 0 Then
            attributeII = Chr(34) & attributeII & Chr(34)
          End If
        End If
      ElseIf .ComboBox_attrib2.Visible = True Then
        Set at = attl.ReturnAttr(.lb_Attrib2.Caption)
        With at
          attributeII = .ReturnValue(.lastInsertedValue).abbrValue
        End With
      End If
    End If
    If .lb_Attrib3.Visible = True Then
      If .TextBox_attrib3.Visible = True Then
        attributeIII = .TextBox_attrib3.text
        If Len(Trim$(attributeIII)) <> 0 Then
          If InStr(attributeIII, " ") <> 0 Then
            attributeIII = Chr(34) & attributeIII & Chr(34)
          End If
        End If
      ElseIf .ComboBox_attrib3.Visible = True Then
        Set at = attl.ReturnAttr(.lb_Attrib3.Caption)
        With at
          attributeIII = .ReturnValue(.lastInsertedValue).abbrValue
        End With
      End If
    End If
  End With
  Set at = Nothing
  Exit Sub
ERRLOG:
  Dim Conf As New clsConfig
  With mErr
    Conf.LoadPublicValues
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
  Set Conf = Nothing: Set at = Nothing
End Sub

Public Sub ShowFrmConfig(Conf As clsConfig)
  Const errIDMet As String = "10"
  '-----------------------------
  On Error GoTo ERRLOG
  
  With frmConfig
    .Caption = Conf.titlefrmConfig
    .Frame_language.Caption = Conf.titleLanguage
    .Frame_responsible.Caption = Conf.titleResponsible
    .OptionButton_en.Caption = Conf.optionEnglish
    .OptionButton_sp.Caption = Conf.optionSpanish
    .OptionButton_pt.Caption = Conf.optionPortuguese
    .CommandButton_clear.Caption = Conf.textClear
    .CommandButton_record.Caption = Conf.textWrite
    .CommandButton_OK.Caption = Conf.textOK
    .CommandButton_CANCEL.Caption = Conf.textCANCEL
    .show
  End With
  Exit Sub
ERRLOG:
  With mErr
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
End Sub

Public Sub EndFrmConfig()
  Const errIDMet As String = "11"
  '-----------------------------
  On Error GoTo ERRLOG
  
  Unload frmConfig
  Exit Sub
ERRLOG:
  Dim Conf As New clsConfig
  With mErr
    Conf.LoadPublicValues
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
  Set Conf = Nothing
End Sub

Public Sub BuildMarkupBar(Conf As clsConfig)
  Dim language As String, capBut As String, f As Integer
  Const fileDefault As String = "default.mds"
  Const errIDMet As String = "12"
  '-----------------------------
  On Error GoTo ERRLOG
  
  f = FreeFile
  Open Conf.directory & fileDefault For Input As #f
  Input #f, aux, language
  Close #f
  Dim b As CommandBarPopup
  With CommandBars("StartUp").Controls
    '.Add Type:=msoControlPopup, Before:=.Count + 1
    .add Type:=msoControlPopup
    Set b = .Item(.count)
    With b
      Select Case language
        Case "en"
          capBut = "Markup"
        Case "pt"
          capBut = "Marca��o"
        Case "sp"
          capBut = "Marcaci�n"
      End Select
      .Caption = capBut
      '.BeginGroup = True
      With .CommandBar.Controls
        .add Type:=msoControlButton
        With .Item(.count)
          .Caption = "Markup DTD-Scielo 3.1"
          .TooltipText = "Start Markup"
          .OnAction = "MainModule.Main"
        End With
        .add Type:=msoControlButton
        With .Item(.count)
          Select Case language
            Case "en"
              capBut = "Configuration"
            Case "pt"
              capBut = "Configura��o"
            Case "sp"
              capBut = "Configuraci�n"
          End Select
          .Caption = capBut
          .TooltipText = "Setup"
          .OnAction = "MainModule.MainConfig"
        End With
        '.Add Type:=msoControlButton
        'With .Item(.count)
        '  .Caption = "1.0-2.0-3.0"
        '  .OnAction = "MainModule.Conv"
        'End With
      End With
    End With
  End With
  Set b = Nothing
  Exit Sub
ERRLOG:
  With mErr
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
  Set b = Nothing
End Sub

Sub DestroyMarkupBar(Conf As clsConfig)
  Dim i As Integer
  Const errIDMet As String = "13"
  '-----------------------------
  On Error GoTo ERRLOG
  
  With CommandBars("StartUp").Controls
    While .count > 0
      .Item(.count).Delete
    Wend
  End With
  
  Exit Sub
ERRLOG:
  With mErr
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
End Sub

Sub DisableWordBars()
  Const qtde As Integer = 15
  Dim Barras(qtde) As String
  Dim i As Integer
  Const errIDMet As String = "14"
  '-----------------------------
  On Error GoTo ERRLOG
  
  '-----nomes dos toolbars do WORD-------
  Barras(0) = "Standard": Barras(1) = "Formatting": Barras(2) = "AutoText"
  Barras(3) = "Control Toolbox": Barras(4) = "Database": Barras(5) = "Drawing"
  Barras(6) = "Forms": Barras(7) = "Picture": Barras(8) = "Reviewing": Barras(9) = "Tables and Borders"
  Barras(10) = "Visual Basic": Barras(11) = "Web": Barras(12) = "WordArt"
  Barras(13) = "Microsoft": Barras(14) = "3-D Settings": Barras(15) = "Shadow Settings"
  '--------------------------------------
  For i = 0 To qtde
    CommandBars(Barras(i)).Enabled = False
  Next i
  CommandBars("Menu Bar").Enabled = False
  Exit Sub
ERRLOG:
  Dim Conf As New clsConfig
  With mErr
    Conf.LoadPublicValues
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
  Set Conf = Nothing
End Sub

Sub EnableWordBars()
  Const qtde As Integer = 15
  Dim Barras(qtde) As String
  Dim i As Integer
  Const errIDMet As String = "15"
  '-----------------------------
  On Error GoTo ERRLOG
  
  '-----nomes dos toolbars do WORD-------
  Barras(0) = "Standard": Barras(1) = "Formatting": Barras(2) = "AutoText"
  Barras(3) = "Control Toolbox": Barras(4) = "Database": Barras(5) = "Drawing"
  Barras(6) = "Forms": Barras(7) = "Picture": Barras(8) = "Reviewing": Barras(9) = "Tables and Borders"
  Barras(10) = "Visual Basic": Barras(11) = "Web": Barras(12) = "WordArt"
  Barras(13) = "Microsoft": Barras(14) = "3-D Settings": Barras(15) = "Shadow Settings"
  '--------------------------------------
  For i = 0 To qtde
    CommandBars(Barras(i)).Enabled = True
  Next i
  CommandBars("Menu Bar").Enabled = True
  Exit Sub
ERRLOG:
  Dim Conf As New clsConfig
  With mErr
    Conf.LoadPublicValues
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
  Set Conf = Nothing
End Sub

Public Sub SetPositionFrms(Conf As clsConfig)
  With frmArticle
    '.Top = 0
    '.Left = 0
    .StartUpPosition = 2
  End With
  With frmAttribute
    '.Top = 0
    '.Left = 0
    .StartUpPosition = 2
  End With
End Sub

Public Sub ShowFrmArticleEdit(Conf As clsConfig, DocTag As String, attrl As clsAttrList)
  Dim l As New collection, f As Integer
  Dim aux As String, val As String, inic As Integer, fim As Integer
  Dim areacode As String
  Dim i As Long
  Dim found As Boolean
  Dim issueid As String
  Dim issue As clsIssue
  Dim year As String
  Const errIDMet As String = "16"
  '-----------------------------
  On Error GoTo ERRLOG
  
  With frmArticle
    
    issueid = GetArticleAttributeContent(DocTag, "stitle=") & Space(1)
    
    val = GetArticleAttributeContent(DocTag, "volid=")
    If Len(val) > 0 Then issueid = issueid & "v." & val & Space(1)
    
    val = GetArticleAttributeContent(DocTag, "supplvol=")
    If Len(val) > 0 Then issueid = issueid & "s." & val & Space(1)
    
    val = GetArticleAttributeContent(DocTag, "issueno=")
    If Len(val) > 0 Then
        issueid = issueid & "n." & val & Space(1)
        If val = "ahead" Or val = "review" Then
            year = Mid(GetArticleAttributeContent(DocTag, "dateiso="), 1, 4)
        End If
    End If
    
    val = GetArticleAttributeContent(DocTag, "supplno=")
    If Len(val) > 0 Then issueid = issueid & "s." & val & Space(1)
      
    
    issueid = Trim(issueid & " " & year)
    
    Set issue = New clsIssue
    Set issue = .SelectIssueId(issueid)
    
    
    If Len(issue.primaryKey) > 0 Then
    
    val = GetArticleAttributeContent(DocTag, "seccode=")
    If Len(val) > 0 Then Call .SelectComboItem(.ComboBox_seccode, issue.GetExtSec(val))
    
    val = GetArticleAttributeContent(DocTag, "ccode=")
    If Len(val) > 0 Then Call .SelectComboItem(.ComboBox_ccode, attrl.ReturnAttr("ccode").GetExtVal(val))
    
    val = GetArticleAttributeContent(DocTag, "pii=")
    If Len(val) > 0 Then .TextBox_pii.text = val
    
    val = GetArticleAttributeContent(DocTag, "order=")
    If Len(val) > 0 Then .TextBox_order.text = val
       
    val = GetArticleAttributeContent(DocTag, "fpage=")
    If Len(val) > 0 Then val = val & "-" & GetArticleAttributeContent(DocTag, "lpage=")
    If Len(val) > 0 Then .TextBox_pages.text = val
    
    val = GetArticleAttributeContent(DocTag, "version=")
    If Len(val) > 0 Then Call .SelectComboItem(.ComboBox_version, val)
    
    val = GetArticleAttributeContent(DocTag, "doctopic=")
    If Len(val) > 0 Then Call .SelectComboItem(.ComboBox_doctopic, attrl.ReturnAttr("doctopic").GetExtVal(val))
    
    val = GetArticleAttributeContent(DocTag, "language=")
    If Len(val) > 0 Then Call .SelectComboItem(.ComboBox_language, attrl.ReturnAttr("language").GetExtVal(val))
    
    val = GetArticleAttributeContent(DocTag, "toccode=")
    If Len(val) > 0 Then Call .SelectComboItem(.ComboBox_toccode, attrl.ReturnAttr("toccode").GetExtVal(val))
    
    val = GetArticleAttributeContent(DocTag, "type=")
    If Len(val) > 0 Then
    inic = 1
    fim = InStr(val, " ")
    If fim <> 0 Then
      While fim <> 0
        l.add Mid$(val, inic, fim - inic): inic = fim + 1
        fim = InStr(inic, val, " ")
      Wend
      l.add Mid(val, inic, Len(val) - inic + 1)
      For j = 1 To l.count
      
        For i = 0 To .ListBox_type.ListCount - 1 'listV.Count
          If attrl.ReturnAttr("illustrative material type").GetExtVal(l.Item(j)) = .ListBox_type.list(i) Then
            .ListBox_type.Selected(i) = True
          End If
        Next i
      Next j
    Else
      l.add val
      For i = 0 To .ListBox_type.ListCount - 1
        If attrl.ReturnAttr("illustrative material type").GetExtVal(l.Item(1)) = .ListBox_type.list(i) Then
          .ListBox_type.Selected(i) = True: Exit For
        End If
      Next i
    End If
    End If
    
    val = GetArticleAttributeContent(DocTag, "sponsor=")
    If Len(val) > 0 Then Call .SelectComboItem(.ComboBox_sponsor, attrl.ReturnAttr("sponsor").GetExtVal(val))
    
        val = GetArticleAttributeContent(DocTag, "rvpdate=")
        If Len(val) > 0 Then .TextBox_rvpdate.text = val
    val = GetArticleAttributeContent(DocTag, "ahpdate=")
    If Len(val) > 0 Then .TextBox_ahpdate.text = val
            
        frmArticle.currentAHPDate = frmArticle.TextBox_ahpdate.text
        frmArticle.currentRVPDate = frmArticle.TextBox_rvpdate.text
        frmArticle.currentTitle = frmArticle.TextBox_stitle.text

    End If
    .Caption = Conf.titlefrmArticle
    .CommandButton_OK.Caption = Conf.textOK
    .CommandButton_CANCEL.Caption = Conf.textCANCEL
    '.Frame_auto.Caption = conf.titleFields
    SetPositionFrms Conf
    'roberta para ordenar
    
    'If .ComboBox_issueid.ListCount > 0 Then .OrdIssueList (.ComboBox_issueid.list(0))
    .show
  End With
  Exit Sub
ERRLOG:
  With mErr
    .LoadErr Conf
    .BuildLog errIDObj & errIDMet, Conf
  End With
  
  Set l = Nothing
End Sub

Private Function GetArticleAttributeContent(Fulltag As String, attr As String) As String
    Dim pI As Long
    Dim pF As Long
    Dim ret As String
        
    pI = InStr(Fulltag, attr)
    If pI > 0 Then
        pI = pI + Len(attr)
        If Mid(Fulltag, pI, 1) = Chr(34) Then
            pI = pI + 1
            pF = InStr(pI, Fulltag, Chr(34), vbBinaryCompare)
        Else
            pF = InStr(pI, Fulltag, " ", vbTextCompare)
            If pF = 0 Then pF = InStr(pI, Fulltag, Chr(160), vbTextCompare)
            If pF = 0 Then pF = InStr(pI, Fulltag, "]", vbTextCompare)
            
        End If
        If pF > 0 Then ret = Mid(Fulltag, pI, pF - pI)
    End If
    GetArticleAttributeContent = ret
End Function