Attribute VB_Name = "ModDB"
Option Explicit


Public journalDAO As ClsJournalDAO
Public journalAction As New ClsJournalAction

Const changelinetextbox = vbCrLf

Sub Serial_GetExisting(list As ListBox)
    Dim jlist As ClsJournalList
    Dim i As Long
    
    list.Clear
    Set jlist = journalDAO.getJournalList()
    
    For i = 1 To jlist.count
        list.AddItem jlist.getItemByIndex(i).Title
    Next
End Sub

Function Serial_CheckExisting(SerialTitle_to_find As String) As Long
    Serial_CheckExisting = journalDAO.existJournal(SerialTitle_to_find)
End Function

Function Serial_TxtContent(Mfn As Long, tag As Long, Optional language As String) As String
    Serial_TxtContent = journalDAO.getFieldContentByLanguage(Mfn, tag, language)
End Function

Function Serial_ComboDefaultValue(Code As ColCode, DefaultOption As String) As String
    Dim exist As Boolean
    Dim itemCode As ClCode
    Dim Content As String
    
    
        If Len(DefaultOption) > 0 Then
            Set itemCode = New ClCode
            Set itemCode = Code(DefaultOption, exist)
            If exist Then
                Content = itemCode.value
            Else
            Debug.Print
            End If
        End If
    
    Serial_ComboDefaultValue = Content
End Function
Function Serial_ComboContent(Code As ColCode, Mfn As Long, tag As Long, Optional DefaultOption As String) As String
    Serial_ComboContent = journalDAO.getDecodedValue(Code, Mfn, tag, DefaultOption)
End Function

Function TagTxtContent(Content As String, tag As Long) As String
    Dim p2 As Long
    Dim NewContent As String
    Dim p1 As Long
    
        Content = Content + changelinetextbox
        p1 = InStr(Content, changelinetextbox)
        p2 = 1
        While p1 > 0
            NewContent = NewContent + TagContent(Mid(Content, p2, p1 - p2), tag)
            p2 = p1 + Len(changelinetextbox)
            p1 = InStr(p2 + Len(changelinetextbox), Content, changelinetextbox)
        Wend
    TagTxtContent = NewContent
End Function

Sub Serial_ListContent(list As ListBox, Code As ColCode, Mfn As Long, tag As Long)
    Dim Content As String
    Dim exist As Boolean
    Dim itemCode As ClCode
    Dim sep As String
    Dim p As Long
    Dim item As String
    Dim i As Long
    Dim found As Boolean
    
    sep = "%"
    Content = journalDAO.getRepetitiveFieldValue(Mfn, tag, sep)
    
    For i = 0 To list.ListCount - 1
        list.Selected(i) = False
    Next
            
    Set itemCode = New ClCode
    
    p = InStr(Content, sep)
    While p > 0
        item = Mid(Content, 1, p - 1)
        Set itemCode = Code(item, exist)
        If exist Then
            item = itemCode.value
            i = 0
            found = False
            While (i < list.ListCount) And (Not found)
                If StrComp(item, list.list(i), vbTextCompare) = 0 Then
                    found = True
                    list.Selected(i) = True
                End If
                i = i + 1
            Wend
        Else
            
        End If
        Content = Mid(Content, p + 1)
        p = InStr(Content, sep)
    Wend
End Sub

Sub Issue_ListContent(list As ListBox, Code As ColCode, Mfn As Long, tag As Long)
    Dim isistitle As ClIsisdll
    Dim Content As String
    Dim exist As Boolean
    Dim itemCode As ClCode
    Dim sep As String
    Dim p As Long
    Dim item As String
    Dim i As Long
    Dim found As Boolean
    
    sep = "%"
    
    Set isistitle = New ClIsisdll
    With Paths("Issue Database")
    If isistitle.Inicia(.path, .FileName, .Key) Then
        Content = isistitle.UsePft(Mfn, "(v" + CStr(tag) + "|" + sep + "|)")
        'Content = ReplaceString(Content, sep, changelinetextbox)
        
        For i = 0 To list.ListCount - 1
            list.Selected(i) = False
        Next
                
        Set itemCode = New ClCode
        
        p = InStr(Content, sep)
        While p > 0
            item = Mid(Content, 1, p - 1)
            Set itemCode = Code(item, exist)
            If exist Then
                item = itemCode.value
                i = 0
                found = False
                While (i < list.ListCount) And (Not found)
                    If StrComp(item, list.list(i), vbTextCompare) = 0 Then
                        found = True
                        list.Selected(i) = True
                    End If
                    i = i + 1
                Wend
            Else
                
            End If
            Content = Mid(Content, p + 1)
            p = InStr(Content, sep)
        Wend
    End If
    End With
End Sub


Function Serial_Save(MfnTitle As Long) As Long
    Dim reccontent As String
    Dim i As Long
    Dim msgwarning As String
    Dim OK As Boolean
        
    'MousePointer = vbHourglass
    
    'Serial1.WarnMandatoryFields
    'Serial2.WarnMandatoryFields
    'Serial3.WarnMandatoryFields
    'Serial4.WarnMandatoryFields
    'Serial5.WarnMandatoryFields
    
    If Serial_ChangedContents(MfnTitle) Then
    
    reccontent = reccontent + TagTxtContent(Serial1.TxtISSN.text, 400)
    reccontent = reccontent + TagTxtContent(Serial1.TxtSerTitle.text, 100)
    reccontent = reccontent + TagTxtContent(Serial1.TxtSubtitle.text, 110)
    reccontent = reccontent + TagTxtContent(Serial1.TxtShortTitle.text, 150)
    reccontent = reccontent + TagTxtContent(Serial1.TxtISOStitle.text, 151)
    reccontent = reccontent + TagTxtContent(Serial1.TxtSectionTitle.text, 130)
    reccontent = reccontent + TagTxtContent(Serial1.TxtParallel.text, 230)
    reccontent = reccontent + TagTxtContent(Serial1.TxtOthTitle.text, 240)
    reccontent = reccontent + TagTxtContent(Serial1.TxtOldTitle.text, 610)
    reccontent = reccontent + TagTxtContent(Serial1.TxtNewTitle.text, 710)
    reccontent = reccontent + TagTxtContent(Serial1.TxtIsSuppl.text, 560)
    reccontent = reccontent + TagTxtContent(Serial1.TxtHasSuppl.text, 550)
    
    
    For i = 1 To IdiomsInfo.count
        If Len(Serial2.TxtMission(i).text) > 0 Then reccontent = reccontent + TagTxtContent(Serial2.TxtMission(i).text + "^l" + IdiomsInfo(i).Code, 901)
    Next
    
    reccontent = reccontent + TagTxtContent(UCase(Serial2.TxtDescriptors.text), 440)
    reccontent = reccontent + TagListContent(CodeStudyArea, Serial2.ListStudyArea, 441)
    
    reccontent = reccontent + TagComboContent(CodeLiteratureType, Serial2.ComboTpLit.text, 5)
    reccontent = reccontent + TagComboContent(CodeTreatLevel, Serial2.ComboTreatLev.text, 6)
    reccontent = reccontent + TagComboContent(CodePubLevel, Serial2.ComboPubLev.text, 330)
        
    reccontent = reccontent + TagTxtContent(Serial3.TxtInitDate.text, 301)
    reccontent = reccontent + TagTxtContent(Serial3.TxtInitVol.text, 302)
    reccontent = reccontent + TagTxtContent(Serial3.TxtInitNo.text, 303)
    reccontent = reccontent + TagTxtContent(Serial3.TxtTermDate.text, 304)
    reccontent = reccontent + TagTxtContent(Serial3.TxtFinVol.text, 305)
    reccontent = reccontent + TagTxtContent(Serial3.TxtFinNo.text, 306)
        
    reccontent = reccontent + TagComboContent(CodeFrequency, Serial3.ComboFreq.text, 380)
    reccontent = reccontent + TagComboContent(codeStatus, Serial3.ComboPubStatus.text, 50)
    reccontent = reccontent + TagComboContent(CodeAlphabet, Serial3.ComboAlphabet.text, 340)
    reccontent = reccontent + TagListContent(CodeTxtLanguage, Serial3.ListTextIdiom, 350)
    reccontent = reccontent + TagListContent(CodeAbstLanguage, Serial3.ListAbstIdiom, 360)
        
    reccontent = reccontent + TagTxtContent(Serial3.TxtNationalcode.text, 20)
    reccontent = reccontent + TagTxtContent(Serial3.TxtClassif.text, 430)
    reccontent = reccontent + TagComboContent(CodeStandard, Serial3.ComboStandard.text, 117)
    reccontent = reccontent + TagListContent(CodeScheme, Serial3.ListScheme, 85)
    
    reccontent = reccontent + TagTxtContent(Serial3.TxtPublisher.text, 480)
    
    reccontent = reccontent + TagComboContent(CodeCountry, Serial3.ComboCountry.text, 310)
    reccontent = reccontent + TagComboContent(CodeState, Serial3.ComboState.text, 320)
    'reccontent = reccontent + TagTxtContent(Serial3.TxtPubState.Text, 320)
    
    reccontent = reccontent + TagTxtContent(Serial3.TxtPubCity.text, 490)
        
    reccontent = reccontent + TagTxtContent(Serial4.TxtAddress.text, 63)
    reccontent = reccontent + TagTxtContent(Serial4.TxtPhone.text, 631)
    reccontent = reccontent + TagTxtContent(Serial4.TxtFaxNumber.text, 632)
    reccontent = reccontent + TagTxtContent(Serial4.TxtEmail.text, 64)
    reccontent = reccontent + TagTxtContent(Serial4.TxtCprightDate.text, 621)
    reccontent = reccontent + TagTxtContent(Serial4.TxtCprighter.text, 62)
    reccontent = reccontent + TagTxtContent(Serial4.TxtSponsor.text, 140)
        
        
    reccontent = reccontent + TagTxtContent(Serial4.TxtSECS.text, 37)
    reccontent = reccontent + TagTxtContent(Serial4.TxtMEDLINE.text, 420)
    reccontent = reccontent + TagTxtContent(Serial4.TxtMEDLINEStitle.text, 421)
    reccontent = reccontent + TagTxtContent(Serial4.TxtIdxRange.text, 450)
    reccontent = reccontent + TagTxtContent(Serial4.TxtNotes.text, 900)
    
    
    
    reccontent = reccontent + TagTxtContent(Serial5.TxtSiglum.text, 930)
    reccontent = reccontent + TagTxtContent(Serial5.TxtPubId.text, 68)
    reccontent = reccontent + TagTxtContent(Serial5.TxtSep.text, 65)
    reccontent = reccontent + TagTxtContent(Serial5.TxtSiteLocation.text, 69)
    reccontent = reccontent + TagComboContent(CodeFTP, Serial5.ComboFTP.text, 66)
    reccontent = reccontent + TagComboContent(CodeISSNType, Serial5.ComboISSNType.text, 35)
    reccontent = reccontent + TagComboContent(CodeUsersubscription, Serial5.ComboUserSubscription.text, 67)
    reccontent = reccontent + TagTxtContent(Serial5.ScieloNetWrite, 691)
    reccontent = reccontent + TagTxtContent(Serial5.Text_SubmissionOnline.text, 692)
    
    
    reccontent = reccontent + TagComboContent(CodeCCode, Serial5.ComboCCode.text, 10)
    reccontent = reccontent + TagTxtContent(Serial5.TxtIdNumber.text, 30)
    reccontent = reccontent + TagTxtContent(Serial5.TxtDocCreation.text, 950)
    reccontent = reccontent + TagTxtContent(Serial5.TxtCreatDate.text, 940)
    reccontent = reccontent + TagTxtContent(Serial5.TxtDocUpdate.text, 951)
    
    Serial5.TxtUpdateDate.text = getDateIso(Date)
    reccontent = reccontent + TagTxtContent(Serial5.TxtUpdateDate.text, 941)
    
    reccontent = reccontent + Serial6.getDataToSave
    reccontent = reccontent + journalDAO.tagCreativeCommons(Serial7.getCreativeCommons)
    
    Call journalDAO.Save(MfnTitle, reccontent)
    
    End If
    Serial_Save = MfnTitle
End Function

Function TagComboContent(Code As ColCode, Content As String, tag As Long) As String
    Dim exist As Boolean
    Dim itemCode As ClCode
        
    If Len(Content) > 0 Then
        Set itemCode = New ClCode
        Set itemCode = Code(Content, exist)
        If exist Then
            Content = itemCode.Code
        Else
        
        End If
    End If
    
    TagComboContent = TagContent(Content, tag)
End Function

Function TagListContent(Code As ColCode, list As ListBox, tag As Long) As String
    Dim exist As Boolean
    Dim itemCode As ClCode
    Dim i As Long
    Dim Content As String
    
        Set itemCode = New ClCode
        For i = 0 To list.ListCount - 1
            If list.Selected(i) Then
                Set itemCode = Code(list.list(i), exist)
                If exist Then
                    Content = Content + TagContent(itemCode.Code, tag)
                Else
                    Debug.Print
                End If
            End If
        Next
            
    TagListContent = Content
End Function

Sub FillListStudyArea(list As ListBox, Code As ColCode)
    Dim i As Long
    
    list.Clear
    For i = 1 To Code.count
        If StrComp(Code(i).value, Code(i).Code) = 0 Then
            list.AddItem Code(i).value
        Else
            If (i Mod 2) <> 0 Then
                list.AddItem Code(i).value
            End If
        End If
    Next
End Sub
Sub FillList(list As ListBox, Code As ColCode)
    Dim i As Long
    
    list.Clear
    
    For i = 1 To Code.count
        list.AddItem Code(i).value
    Next
End Sub

Sub FillCombo(combo As ComboBox, Code As ColCode)
    Dim i As Long
    
    combo.Clear
    For i = 1 To Code.count
        If Not Code(i).unabled Then
            combo.AddItem Code(i).value
        End If
    Next
End Sub

Sub UnselectList(list As ListBox)
    Dim i As Long
    
    For i = 0 To list.ListCount - 1
        list.Selected(i) = False
    Next
End Sub

Sub UnloadSerialForms()
    Dim IsNewSerial As Boolean
    IsNewSerial = Serial1.FillingNewSerial
    
    Unload Serial7
    Unload Serial6
    Unload Serial5
    Unload Serial4
    Unload Serial3
    Unload Serial2
    Unload Serial1
    Unload FrmInfo
    journalAction.generateJournalStandardListForMarkup
    If IsNewSerial Then
        Call Serial_GetExisting(FrmNewSerial.ListExistingSerial)
        FrmNewSerial.Show
    Else
        FrmExistingSerial.Show
        Call Serial_GetExisting(FrmExistingSerial.ListExistingSerial)
    End If
End Sub
 
Function Serial_Close(MyMfnTitle As Long) As Integer
    Dim resp As VbMsgBoxResult
    Dim QClose As Integer
    Dim QExit As Boolean
    
    QExit = Not Serial6.WarnMandatoryFields
    
    If Not QExit Then
        If TitleCloseDenied Then
            MsgBox ConfigLabels.MsgUnabledtoClose
        Else
            resp = MsgBox(ConfigLabels.MsgExit, vbYesNo + vbDefaultButton2)
            If resp = vbYes Then
                QExit = True
            ElseIf resp = vbNo Then
                QExit = False
            End If
        End If
    End If
    
    If QExit Then
        If Serial_ChangedContents(MyMfnTitle) Then
            resp = MsgBox(ConfigLabels.MsgSaveChanges, vbYesNoCancel)
            If resp = vbCancel Then
            
            ElseIf resp = vbYes Then
                QClose = 2
            ElseIf resp = vbNo Then
                QClose = 1
            End If
        Else
            QClose = 1
        End If
    End If
    Serial_Close = QClose
End Function

Function Serial_ChangedContents(MfnTitle As Long) As Boolean
    Dim change As Boolean
    Dim i As Long
    
    change = (StrComp(Serial1.TxtISSN.text, Serial_TxtContent(MfnTitle, 400)) <> 0)
    change = change Or (StrComp(Serial1.TxtSerTitle.text, Serial_TxtContent(MfnTitle, 100)) <> 0)
    change = change Or (StrComp(Serial1.TxtSubtitle.text, Serial_TxtContent(MfnTitle, 110)) <> 0)
    change = change Or (StrComp(Serial1.TxtShortTitle.text, Serial_TxtContent(MfnTitle, 150)) <> 0)
    change = change Or (StrComp(Serial1.TxtISOStitle.text, Serial_TxtContent(MfnTitle, 151)) <> 0)
    change = change Or (StrComp(Serial1.TxtSectionTitle.text, Serial_TxtContent(MfnTitle, 130)) <> 0)
    change = change Or (StrComp(Serial1.TxtParallel.text, Serial_TxtContent(MfnTitle, 230)) <> 0)
    change = change Or (StrComp(Serial1.TxtOthTitle.text, Serial_TxtContent(MfnTitle, 240)) <> 0)
    change = change Or (StrComp(Serial1.TxtOldTitle.text, Serial_TxtContent(MfnTitle, 610)) <> 0)
    change = change Or (StrComp(Serial1.TxtNewTitle.text, Serial_TxtContent(MfnTitle, 710)) <> 0)
    change = change Or (StrComp(Serial1.TxtIsSuppl.text, Serial_TxtContent(MfnTitle, 560)) <> 0)
    change = change Or (StrComp(Serial1.TxtHasSuppl.text, Serial_TxtContent(MfnTitle, 550)) <> 0)
    
    For i = 1 To IdiomsInfo.count
        change = change Or (StrComp(Serial2.TxtMission(i).text, Serial_TxtContent(MfnTitle, 901, IdiomsInfo(i).Code)) <> 0)
    Next

    change = change Or (StrComp(Serial2.TxtDescriptors.text, Serial_TxtContent(MfnTitle, 440), vbTextCompare) <> 0)
    'change = change Or (StrComp(Serial2.ListStudyArea.Text, Serial_TxtContent(MfnTitle, 441)) <> 0)
    
    change = change Or Serial_ChangedListContent(Serial2.ListStudyArea, CodeStudyArea, MfnTitle, 441)

    change = change Or (StrComp(Serial2.ComboTpLit.text, Serial_ComboContent(CodeLiteratureType, MfnTitle, 5)) <> 0)
    change = change Or (StrComp(Serial2.ComboTreatLev.text, Serial_ComboContent(CodeTreatLevel, MfnTitle, 6)) <> 0)
    change = change Or (StrComp(Serial2.ComboPubLev.text, Serial_ComboContent(CodePubLevel, MfnTitle, 330)) <> 0)
    
    change = change Or (StrComp(Serial3.TxtInitVol.text, Serial_TxtContent(MfnTitle, 302)) <> 0)
    change = change Or (StrComp(Serial3.TxtInitNo.text, Serial_TxtContent(MfnTitle, 303)) <> 0)
    change = change Or (StrComp(Serial3.TxtTermDate.text, Serial_TxtContent(MfnTitle, 304)) <> 0)
    change = change Or (StrComp(Serial3.TxtFinVol.text, Serial_TxtContent(MfnTitle, 305)) <> 0)
    change = change Or (StrComp(Serial3.TxtFinNo.text, Serial_TxtContent(MfnTitle, 306)) <> 0)
    
    change = change Or (StrComp(Serial3.ComboFreq.text, Serial_ComboContent(CodeFrequency, MfnTitle, 380)) <> 0)
    change = change Or (StrComp(Serial3.ComboPubStatus.text, Serial_ComboContent(codeStatus, MfnTitle, 50)) <> 0)
    change = change Or (StrComp(Serial3.ComboAlphabet.text, Serial_ComboContent(CodeAlphabet, MfnTitle, 340)) <> 0)
    change = change Or (StrComp(Serial3.ComboStandard.text, Serial_ComboContent(CodeStandard, MfnTitle, 117)) <> 0)
        
    change = change Or (StrComp(Serial3.TxtNationalcode.text, Serial_TxtContent(MfnTitle, 20)) <> 0)
    change = change Or (StrComp(Serial3.TxtClassif.text, Serial_TxtContent(MfnTitle, 430)) <> 0)
    change = change Or (StrComp(Serial3.TxtPublisher.text, Serial_TxtContent(MfnTitle, 480)) <> 0)
    change = change Or (StrComp(Serial3.ComboCountry.text, Serial_ComboContent(CodeCountry, MfnTitle, 310)) <> 0)
    change = change Or (StrComp(Serial3.ComboState.text, Serial_ComboContent(CodeState, MfnTitle, 320)) <> 0)
    'change = change Or (StrComp(Serial3.TxtPubState.Text, Serial_TxtContent(MfnTitle, 320)) <> 0)
    change = change Or (StrComp(Serial3.TxtPubCity.text, Serial_TxtContent(MfnTitle, 490)) <> 0)

    change = change Or (StrComp(Serial4.TxtAddress.text, Serial_TxtContent(MfnTitle, 63)) <> 0)
    change = change Or (StrComp(Serial4.TxtPhone.text, Serial_TxtContent(MfnTitle, 631)) <> 0)
    change = change Or (StrComp(Serial4.TxtFaxNumber.text, Serial_TxtContent(MfnTitle, 632)) <> 0)
    change = change Or (StrComp(Serial4.TxtEmail.text, Serial_TxtContent(MfnTitle, 64)) <> 0)
    change = change Or (StrComp(Serial4.TxtCprightDate.text, Serial_TxtContent(MfnTitle, 621)) <> 0)
    change = change Or (StrComp(Serial4.TxtCprighter.text, Serial_TxtContent(MfnTitle, 62)) <> 0)
    change = change Or (StrComp(Serial4.TxtSponsor.text, Serial_TxtContent(MfnTitle, 140)) <> 0)
    change = change Or (StrComp(Serial4.TxtSECS.text, Serial_TxtContent(MfnTitle, 37)) <> 0)
    change = change Or (StrComp(Serial4.TxtMEDLINE.text, Serial_TxtContent(MfnTitle, 420)) <> 0)
    change = change Or (StrComp(Serial4.TxtMEDLINEStitle.text, Serial_TxtContent(MfnTitle, 421)) <> 0)
    change = change Or (StrComp(Serial4.TxtIdxRange.text, Serial_TxtContent(MfnTitle, 450)) <> 0)
    change = change Or (StrComp(Serial4.TxtNotes.text, Serial_TxtContent(MfnTitle, 900)) <> 0)
    
    change = change Or (StrComp(Serial5.TxtSiglum.text, Serial_TxtContent(MfnTitle, 930)) <> 0)
    change = change Or (StrComp(Serial5.TxtPubId.text, Serial_TxtContent(MfnTitle, 68)) <> 0)
    change = change Or (StrComp(Serial5.TxtSep.text, Serial_TxtContent(MfnTitle, 65)) <> 0)
    change = change Or (StrComp(Serial5.TxtSiteLocation.text, Serial_TxtContent(MfnTitle, 69)) <> 0)
    change = change Or (StrComp(Serial5.ComboFTP.text, Serial_ComboContent(CodeFTP, MfnTitle, 66)) <> 0)
    change = change Or (StrComp(Serial5.ComboISSNType.text, Serial_ComboContent(CodeISSNType, MfnTitle, 35)) <> 0)
    change = change Or (StrComp(Serial5.ComboUserSubscription.text, Serial_ComboContent(CodeUsersubscription, MfnTitle, 67)) <> 0)
    change = change Or (StrComp(Serial5.Text_SubmissionOnline.text, Serial_TxtContent(MfnTitle, 692)) <> 0)
    
    change = change Or (StrComp(Serial5.ScieloNetWrite, Serial_TxtContent(MfnTitle, 691)) <> 0)
    change = change Or (StrComp(Serial5.ComboCCode.text, Serial_ComboContent(CodeCCode, MfnTitle, 10)) <> 0)
    change = change Or (StrComp(Serial5.TxtIdNumber.text, Serial_TxtContent(MfnTitle, 30)) <> 0)
    'change = change Or (StrComp(Serial5.TxtDocCreation.Text, Serial_TxtContent(MfnTitle, 950)) <> 0)
    'change = change Or (StrComp(Serial5.TxtCreatDate.Text, Serial_TxtContent(MfnTitle, 940)) <> 0)
    change = change Or (StrComp(Serial5.TxtDocUpdate.text, Serial_TxtContent(MfnTitle, 951)) <> 0)
    'change = change Or (StrComp(Serial5.TxtUpdateDate.Text, Serial_TxtContent(MfnTitle, 941)) <> 0)

    change = change Or Serial_ChangedListContent(Serial3.ListScheme, CodeScheme, MfnTitle, 85)
    change = change Or Serial_ChangedListContent(Serial3.ListTextIdiom, CodeTxtLanguage, MfnTitle, 350)
    change = change Or Serial_ChangedListContent(Serial3.ListAbstIdiom, CodeAbstLanguage, MfnTitle, 360)
    change = change Or Serial6.changed Or Serial7.changed
    
    Serial_ChangedContents = change
End Function

Function Serial_ChangedListContent(list As ListBox, Code As ColCode, MfnTitle As Long, tag As Long) As Boolean
    Dim Content As String
    Dim exist As Boolean
    Dim changed As Long
    Dim itemCode As ClCode
    Dim sep As String
    Dim p As Long
    Dim item As String
    Dim i As Long
    Dim values As String
    
    sep = "%"
    
    Content = journalDAO.getRepetitiveFieldValue(MfnTitle, tag, sep)
    
    Set itemCode = New ClCode
    p = InStr(Content, sep)
    While p > 0
        item = Mid(Content, 1, p - 1)
        Set itemCode = Code(item, exist)
        If exist Then values = values + itemCode.value + sep
        Content = Mid(Content, p + 1)
        p = InStr(Content, sep)
    Wend
    values = sep + values
    
    For i = 0 To list.ListCount - 1
        If list.Selected(i) Then
            'esta selecionado mas nao esta na base
            If InStr(values, sep + list.list(i) + sep) = 0 Then
                changed = changed + 1
            End If
        Else
            'nao esta selecionado mas esta na base
            If InStr(values, sep + list.list(i) + sep) > 0 Then
                changed = changed + 1
            End If
        End If
    Next
    
    Serial_ChangedListContent = (changed > 0)
    
End Function

Sub CancelFilling()
    Dim resp As VbMsgBoxResult
    
    resp = MsgBox(ConfigLabels.MsgExit, vbYesNo)
    If resp = vbYes Then
        UnloadSerialForms
    ElseIf resp = vbNo Then
    
    End If
End Sub

Sub FormQueryUnload(Cancel As Integer, UnloadMode As Integer)

    If UnloadMode = vbFormControlMenu Then
        Cancel = 1
        MsgBox ConfigLabels.MsgClosebyCancelorClose
    End If
End Sub

Function Serial_Remove(Mfns() As Long, q As Long) As Boolean
    Dim isistitle As ClIsisdll
    Dim isistitle2 As ClIsisdll
    Dim i As Long
    Dim t As Boolean
    
    If q > 0 Then
        With Paths("Title Database")
        Call FileCopy(.path + "\" + .FileName + ".mst", .path + "\tmp" + .FileName + ".mst")
        Call FileCopy(.path + "\" + .FileName + ".xrf", .path + "\tmp" + .FileName + ".xrf")
        Call FileCopy(.path + "\" + Paths("Tit_ISSN Inverted File").FileName + ".fst", .path + "\tmp" + .FileName + ".fst")
        
        Kill .path + "\" + .FileName + ".*"
        Kill .path + "\" + Paths("Tit_ISSN Inverted File").FileName + ".*"
        
        Call FileCopy(.path + "\tmp" + .FileName + ".fst", .path + "\" + Paths("Tit_ISSN Inverted File").FileName + ".fst")
        
        
        Set isistitle = New ClIsisdll
        Set isistitle2 = New ClIsisdll
        If isistitle2.Inicia(.path, "tmp" + .FileName, .Key) Then
            If isistitle.Inicia(.path, .FileName, .Key) Then
                If isistitle.IfCreate(Paths("Tit_ISSN Inverted File").FileName) Then
                    For i = 1 To q
                        If isistitle.RecordSave(isistitle2.RecordGet(Mfns(i))) Then
                            t = isistitle.IfUpdate(i, i)
                        End If
                    Next
                End If
            End If
        End If
        End With
    End If
    Serial_Remove = t
    Set isistitle = Nothing
    Set isistitle2 = Nothing
End Function

Function Section_CheckExisting(SerialTitle_to_find As String, ISSN As String, PUBID As String) As Long
    Dim isisSection As ClIsisdll
    Dim Mfn As Long
    Dim SERIALTITLE As String
    Dim SerialISSN As String
    Dim found As Boolean
    Dim i As Long
    Dim MfnCounter As Long
    Dim SerialMfns() As Long
    
    
    Set isisSection = New ClIsisdll
    With Paths("Section Database")
    If isisSection.Inicia(.path, .FileName, .Key) Then
        If isisSection.IfCreate(.FileName) Then
            'procura pela chave=titulo e pelo campo=t�tulo
            MfnCounter = isisSection.MfnFind(SerialTitle_to_find, SerialMfns)
            i = 0
            While (i < MfnCounter) And (Not found)
                i = i + 1
                SERIALTITLE = isisSection.UsePft(SerialMfns(i), "v100")
                If StrComp(SERIALTITLE, SerialTitle_to_find) = 0 Then
                    Mfn = SerialMfns(i)
                    found = True
                End If
            Wend
            
            'procura pela chave=ISSN
            If Not found Then
                MfnCounter = isisSection.MfnFind(ISSN, SerialMfns)
                i = 0
                While (i < MfnCounter) And (Not found)
                    i = i + 1
                    'procura campo=title
                    SERIALTITLE = isisSection.UsePft(SerialMfns(i), "v100")
                    If StrComp(SERIALTITLE, SerialTitle_to_find) = 0 Then
                        found = True
                        Mfn = SerialMfns(i)
                    Else
                        'procura campo=issn
                        SerialISSN = isisSection.UsePft(SerialMfns(i), "v35")
                        If StrComp(SerialISSN, ISSN) = 0 Then
                            found = True
                            Mfn = SerialMfns(i)
                        End If
                    End If
                Wend
            End If
            
        End If
        If Not found Then
            Mfn = 0
            While (Mfn < isisSection.MfnQuantity) And (Not found)
                Mfn = Mfn + 1
                SERIALTITLE = isisSection.UsePft(Mfn, "v930")
                If StrComp(SERIALTITLE, PUBID) = 0 Then
                    found = True
                End If
            Wend
        End If
    End If
    End With
    If found Then
        Section_CheckExisting = Mfn
    End If
End Function

Function Issue_ComboContent(Code As ColCode, Mfn As Long, tag As Long) As String
    Dim isistitle As ClIsisdll
    Dim Content As String
    Dim exist As Boolean
    Dim itemCode As ClCode
    
    Set isistitle = New ClIsisdll
    With Paths("Issue Database")
    If isistitle.Inicia(.path, .FileName, .Key) Then
        Content = isistitle.UsePft(Mfn, "v" + CStr(tag))
        If Len(Content) > 0 Then
            Set itemCode = New ClCode
            Set itemCode = Code(Content, exist)
            If exist Then
                Content = itemCode.value
            Else
            Debug.Print
            End If
        End If
    End If
    End With
    Issue_ComboContent = Content
End Function

Function Issue_TxtContent(Mfn As Long, tag As Long, Optional subf As String, Optional language As String) As String
    Dim isisIssue As ClIsisdll
    Dim Content As String
    Dim sep As String
    
    sep = "%"
    
    Set isisIssue = New ClIsisdll
    With Paths("Issue Database")
    If isisIssue.Inicia(.path, .FileName, .Key) Then
        If Len(language) = 0 Then
            Content = isisIssue.UsePft(Mfn, "(v" + CStr(tag) + subf + "+|" + sep + "|)")
        Else
            Content = isisIssue.UsePft(Mfn, "(if v" + CStr(tag) + "^l='" + language + "' then v" + CStr(tag) + subf + " fi)")
        End If
        Content = ReplaceString(Content, sep, changelinetextbox)
    End If
    Set isisIssue = Nothing
    End With
    Issue_TxtContent = Content
End Function

Function Section_Header(Mfn As Long, language As String) As String
    Dim isisSection As ClIsisdll
    Dim Content As String
    
    Set isisSection = New ClIsisdll
    With Paths("Section Database")
    If isisSection.Inicia(.path, .FileName, .Key) Then
        Content = isisSection.UsePft(Mfn, "(if v48^l='" + language + "' then v48^h fi)")
    End If
    End With
    Set isisSection = Nothing
    Section_Header = Content
End Function

Function Issue_Header(Mfn As Long, language As String) As String
    Dim isisIssue As ClIsisdll
    Dim Content As String
    
    Set isisIssue = New ClIsisdll
    With Paths("Issue Database")
    If isisIssue.Inicia(.path, .FileName, .Key) Then
        Content = isisIssue.UsePft(Mfn, "(if v48^l='" + language + "' then v48^h fi)")
    End If
    End With
    Set isisIssue = Nothing
    Issue_Header = Content
End Function

Function getCode(Code As ColCode, Content As String) As ClCode
    Dim exist As Boolean
    Dim itemCode As ClCode
    Dim r As ClCode
    
    If Len(Content) > 0 Then
        
        Set itemCode = Code(Content, exist)
        If exist Then
            Set r = itemCode
        End If
    End If
    
    Set getCode = r
End Function