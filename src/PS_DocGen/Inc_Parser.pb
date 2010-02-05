ProcedureDLL DocGen_Parser(sFilename.s, ptrInclude.l)
  Protected plFile.l, plNbResults.l, plNbResultsBis.l, plInc.l, plIncBis.l
  Protected psPathCur.s
  Protected psLine.s, psContent.s, psVar.s, psDoc.s
  Protected pbInMultiline.b, pbInStructure.b, pbInEnumeration.b, pbInMacro.b, pbInProcedure.b
  Protected pbProcedureC.b, pbProcedureDLL.b, pbFound.b
  Protected Dim ResRegex.s(0)
  Protected Dim ResRegexBis.s(0)
  
  ; Initialization of protected variables
  psPathCur = ""
  
  ; Extracts Data From File
  plFile = OpenFile(#PB_Any, sFilename)
  If plFile
    While Eof(plFile) = 0
      psLine = Trim(ReadString(plFile))
      If psLine > ""
        pbFound = #False
        If pbInMultiline = #False
          plNbResults = ExtractRegularExpression(#Regex_CommentBefore, psLine, ResRegex())
          If plNbResults = 1
            psContent = ResRegex(0)
          Else
            psContent = ""
          EndIf
          If psContent > ""
            ;{ IncludePath }
              plNbResults = ExtractRegularExpression(#Regex_IncPath, psContent, ResRegex())
              If plNbResults = 1
                psPathCur = ResRegex(0)
                pbFound = #True
                ; Debug "IncludePath > " + psPathCur
              EndIf
            ;}
            ;{ (X)IncludeFile }
              plNbResults = ExtractRegularExpression(#Regex_IncFile, psContent, ResRegex())
              If plNbResults = 1
                LastElement(LL_IncludeFiles())
                AddElement(LL_IncludeFiles())
                With LL_IncludeFiles()
                  \sPath = psPathCur
                  \sFilename = ResRegex(0)
                  ; Debug "IncludeFile > " + ResRegex(0)
                EndWith
                pbFound = #True
              EndIf
            ;}
            ;{ Structures }
              plNbResults = ExtractRegularExpression(#Regex_Structure, psContent, ResRegex())
              If plNbResults = 1
                LastElement(LL_ListStructures())
                AddElement(LL_ListStructures())
                With LL_ListStructures()
                  \ptrInclude = ptrInclude
                  \sName = ResRegex(0)
                  \sDescription = psDoc
                  ; Debug "Structure > " + ResRegex(0)
                EndWith
                psDoc = ""
                pbInMultiline = #True
                pbInStructure = #True
                pbFound = #True
              EndIf
            ;}
            ;{ Enumerations }
              plNbResults = ExtractRegularExpression(#Regex_Enumeration, psContent, ResRegex())
              If plNbResults = 1
                LastElement(LL_ListEnumerations())
                AddElement(LL_ListEnumerations())
                With LL_ListEnumerations()
                  \ptrInclude = ptrInclude
                  \sDescription = psDoc
                  plNbResults = ExtractRegularExpression(#Regex_Doc, psContent, ResRegex())
                  If plNbResults = 1
                    If \sDescription = ""
                      \sDescription = ResRegex(0)
                    Else
                      \sDescription + #System_EOL + ResRegex(0)
                    EndIf
                  EndIf
                  ; Debug "Enumeration > Found"
                EndWith
                psDoc = ""
                pbInMultiline = #True
                pbInEnumeration = #True
                pbFound = #True
              EndIf
            ;}
            ;{ Macros }
              plNbResults = ExtractRegularExpression(#Regex_Macro, psContent, ResRegex())
              If plNbResults = 1
                LastElement(LL_ListMacros())
                AddElement(LL_ListMacros())
                With LL_ListMacros()
                  \ptrInclude = ptrInclude
                  \sName = ResRegex(0)
                  \sContent = psContent
                  \sDescription = psDoc
                  ; Debug "Macro > " + ResRegex(0)
                EndWith
                psDoc = ""
                pbInMultiline = #True
                pbInMacro = #True
                pbFound = #True
              EndIf
            ;}
            ;{ Tableaux }
              plNbResults = ExtractRegularExpression(#Regex_Array, psContent, ResRegex())
              If plNbResults = 1
                LastElement(LL_ListArrays())
                AddElement(LL_ListArrays())
                With LL_ListArrays()
                  \ptrInclude = ptrInclude
                  \sName = ResRegex(0)
                  \sDescription = psDoc
                  plNbResults = ExtractRegularExpression(#Regex_Doc, psContent, ResRegex())
                  If plNbResults = 1
                    If \sDescription = ""
                      \sDescription = ResRegex(0)
                    Else
                      \sDescription + #System_EOL + ResRegex(0)
                    EndIf
                  EndIf
                  If MatchRegularExpression(#Regex_IsGlobal, psContent) = #True
                    \bIsGlobal = #True
                  EndIf
                  ; Debug "Array > " + \sName
                  psDoc = ""
                  pbFound = #True
                EndWith
              EndIf
            ;}
            ;{ Listes Chainees }
              plNbResults = ExtractRegularExpression(#Regex_LinkedList, psContent, ResRegex())
              If plNbResults = 1
                LastElement(LL_ListLinkedLists())
                AddElement(LL_ListLinkedLists())
                With LL_ListLinkedLists()
                  \ptrInclude = ptrInclude
                  \sName = ResRegex(0)
                  \sDescription = psDoc
                  plNbResults = ExtractRegularExpression(#Regex_Doc, psContent, ResRegex())
                  If plNbResults = 1
                    If \sDescription = ""
                      \sDescription = ResRegex(0)
                    Else
                      \sDescription + #System_EOL + ResRegex(0)
                    EndIf
                  EndIf
                  If MatchRegularExpression(#Regex_IsGlobal, psContent) = #True
                    \bIsGlobal = #True
                  EndIf
                  ; Debug "LinkedList > " + \sName
                  psDoc = ""
                  pbFound = #True
                EndWith
              EndIf
            ;}
            ;{ Constantes }
              plNbResults = ExtractRegularExpression(#Regex_Constant, psContent, ResRegex())
              If plNbResults = 1
                LastElement(LL_ListConstants())
                AddElement(LL_ListConstants())
                With LL_ListConstants()
                  \ptrInclude = ptrInclude
                  \sName = ResRegex(0)
                  plNbResults = ExtractRegularExpression(#Regex_ConstantValue, psContent, ResRegex())
                  If plNbResults = 1
                    \sValue = ResRegex(0)
                  EndIf
                  \sDescription = psDoc
                  plNbResults = ExtractRegularExpression(#Regex_Doc, psContent, ResRegex())
                  If plNbResults = 1
                    If \sDescription = ""
                      \sDescription = ResRegex(0)
                    Else
                      \sDescription + #System_EOL + ResRegex(0)
                    EndIf
                  EndIf
                  ; Debug "Constant > " + \sName
                  ; Debug "Constant > Value > " + \sValue
                  psDoc = ""
                  pbFound = #True
                EndWith
              EndIf
            ;}
            ;{ Procedure(C)(DLL) }
              plNbResults = ExtractRegularExpression(#Regex_ProcedureCDLL, psContent, ResRegex())
              If plNbResults = 1
                pbProcedureC = #True
                pbProcedureDLL = #True
                pbInProcedure = #True
              Else
                plNbResults = ExtractRegularExpression(#Regex_ProcedureDLL, psContent, ResRegex())
                If plNbResults = 1
                  pbProcedureC = #False
                  pbProcedureDLL = #True
                  pbInProcedure = #True
                Else
                  plNbResults = ExtractRegularExpression(#Regex_ProcedureC, psContent, ResRegex())
                  If plNbResults = 1
                    pbProcedureC = #True
                    pbProcedureDLL = #False
                    pbInProcedure = #True
                  Else
                    plNbResults = ExtractRegularExpression(#Regex_Procedure, psContent, ResRegex())
                    If plNbResults = 1
                      pbProcedureC = #False
                      pbProcedureDLL = #False
                      pbInProcedure = #True
                    EndIf
                  EndIf
                EndIf
              EndIf
              If pbInProcedure = #True
                LastElement(LL_ListProcedures())
                AddElement(LL_ListProcedures())
                With LL_ListProcedures()
                  \bIsC = pbProcedureC
                  \bIsDLL = pbProcedureDLL
                  \ptrInclude = ptrInclude
                  \sProcedure = ResRegex(0)
                  \sDescription = psDoc
                  ; Debug "Procedure > " + ResRegex(0)
                  plNbResults = ExtractRegularExpression(#Regex_ProcedureName, \sProcedure, ResRegex())
                  If plNbResults = 1
                    \sName = ResRegex(0)
                    ; Debug "Procedure > Name >"+ ResRegex(0)
                  EndIf
                  plNbResults = ExtractRegularExpression(#Regex_ProcedureType, \sProcedure, ResRegex())
                  If plNbResults = 1
                    \sType = ResRegex(0)
                    ; Debug "Procedure > Type >"+ ResRegex(0)
                  EndIf
                  plNbResults = ExtractRegularExpression(#Regex_ProcedureParameter, RemoveString(\sProcedure, " "), ResRegex())
                  If plNbResults >= 1
                    ; Browse each parameter
                    For plInc = 0 To plNbResults - 1
                      psVar = ResRegex(plInc)
                      ; Debug "Procedure > Parameter > "+ psVar
                      plNbResultsBis = ExtractRegularExpression(#Regex_ProcedureParameterName, psVar, ResRegexBis())
                      If plNbResultsBis >= 1
                        If \sParameterName = ""
                          \sParameterName = ResRegexBis(0)
                        Else
                          \sParameterName + "|" + ResRegexBis(0)
                        EndIf
                        ; Debug "Procedure > Parameter > Name >"+ ResRegexBis(0)
                      EndIf
                      plNbResultsBis = ExtractRegularExpression(#Regex_ProcedureParameterType, psVar, ResRegexBis())
                      If plNbResultsBis >= 1
                        If \sParameterType = ""
                          \sParameterType = ResRegexBis(0)
                        Else
                          \sParameterType + "|" + ResRegexBis(0)
                        EndIf
                        ; Debug "Procedure > Parameter > Type >"+ ResRegexBis(0)
                      Else
                        If \sParameterType = ""
                          \sParameterType = " "
                        Else
                          \sParameterType + "|" + " "
                        EndIf
                      EndIf
                    Next
                  EndIf
                EndWith
                psDoc = ""
                pbInMultiline = #True
                pbFound = #True
              EndIf
            ;}
          Else
            ;{ Documentation }
              plNbResults = ExtractRegularExpression(#Regex_Doc, psLine, ResRegex())
              If plNbResults = 1
                If psDoc = ""
                  psDoc = "@" + ResRegex(0)
                Else
                  psDoc + #System_EOL + "@" + ResRegex(0)
                EndIf
              EndIf
            ;}
          EndIf
        Else
          If pbInStructure = #True
            If MatchRegularExpression(#Regex_EndGroup, psLine) = #False
              ; Nom du champ
              plNbResults = ExtractRegularExpression(#Regex_CommentBefore, psLine, ResRegex())
              If plNbResults = 1
                With LL_ListStructures()
                  If \sField = ""
                    \sField = ResRegex(0)
                  Else
                    \sField + "|"+ ResRegex(0)
                  EndIf
                  ; Debug "Field > "+ ResRegex(0)
                EndWith
              EndIf
              ; Documentation du champ
              plNbResults = ExtractRegularExpression(#Regex_Doc, psLine, ResRegex())
              If plNbResults = 1
                If ResRegex(0) = "" 
                  ResRegex(0) = " "
                EndIf
                With LL_ListStructures()
                  If \sFieldDescription = ""
                    \sFieldDescription = ResRegex(0)
                  Else
                    \sFieldDescription + "|"+ ResRegex(0)
                  EndIf
                EndWith
              EndIf
            Else
              ; Verify that we are not in a StructureUnion
              If FindString(LCase(psLine), "endstructureunion", 0) = 0
                pbInMultiline = #False
                pbInStructure = #False
              EndIf
            EndIf
          EndIf
          If pbInEnumeration = #True
            If MatchRegularExpression(#Regex_EndGroup, psLine) = #False
              ; Nom du champ
              plNbResults = ExtractRegularExpression(#Regex_CommentBefore, psLine, ResRegex())
              If plNbResults = 1
                With LL_ListEnumerations()
                  If \sField = ""
                    \sField = ResRegex(0)
                  Else
                    \sField + "|"+ ResRegex(0)
                  EndIf
                  ; Debug "Field > "+ ResRegex(0)
                EndWith
              EndIf
              ; Documentation du champ
              plNbResults = ExtractRegularExpression(#Regex_Doc, psLine, ResRegex())
              If plNbResults = 1
                If ResRegex(0) = "" 
                  ResRegex(0) = " "
                EndIf
                With LL_ListStructures()
                  If \sFieldDescription = ""
                    \sFieldDescription = ResRegex(0)
                  Else
                    \sFieldDescription + "|"+ ResRegex(0)
                  EndIf
                EndWith
              EndIf
            Else
              pbInMultiline = #False
              pbInEnumeration = #False
            EndIf
          EndIf
          If pbInMacro = #True
            ; Macro's Content
            plNbResults = ExtractRegularExpression(#Regex_CommentBefore, psLine, ResRegex())
            If plNbResults = 1
              With LL_ListMacros()
                \sContent + Chr(13) + Chr(10)+ ResRegex(0)
                ;; Debug "Content > "+ ResRegex(0)
              EndWith
            EndIf
            ; Documentation
            plNbResults = ExtractRegularExpression(#Regex_Doc, psLine, ResRegex())
            If plNbResults = 1
              If ResRegex(0) = "" 
                ResRegex(0) = " "
              EndIf
              With LL_ListMacros()
                \sDescription + ResRegex(0)
              EndWith
            EndIf
            If MatchRegularExpression(#Regex_EndGroup, psLine) = #True
              If FindString(LCase(psLine), "endmacro", 0) > 0
                pbInMultiline = #False
                pbInMacro = #False
              EndIf
            EndIf
          EndIf
          If pbInProcedure = #True
            ; Procedure's Content
            plNbResults = ExtractRegularExpression(#Regex_CommentBefore, psLine, ResRegex())
            If plNbResults = 1
              With LL_ListProcedures()
                \sContent + Chr(13) + Chr(10)+ ResRegex(0)
                ;; Debug "Content > "+ ResRegex(0)
              EndWith
            EndIf
            If MatchRegularExpression(#Regex_EndGroup, psLine) = #True
              If FindString(LCase(psLine), "endprocedure", 0) > 0
                pbInMultiline = #False
                pbInProcedure = #False
              EndIf
            EndIf
          EndIf
        EndIf
      EndIf
    Wend
    CloseFile(plFile)
  Else
    MR_Error("Can't open the file : "+#DQuote+sFilename+#DQuote)
  EndIf
EndProcedure
ProcedureDLL DocGen_ParserDoc(sDocumentation.s, *PtrDoc.S_Documentation)
  Protected sPart.s, sTag.s, sAttribute.s
  Protected lIncA.l
  sDocumentation = Trim(sDocumentation)
  sDocumentation = ReplaceString(sDocumentation, "@+", " ")
  For lIncA = 1 To CountString(sDocumentation, "@")
    sPart = StringField(sDocumentation, lIncA+1, "@")
    sTag = StringField(sPart, 1, " ")
    sTag = ReplaceString(sTag, Chr(13) + Chr(10), "")
    sTag = ReplaceString(sTag, Chr(10), "")
    sAttribute = Trim(Right(sPart, Len(sPart) - Len(sTag) - 1))
    If Left(sAttribute, 1) = ":"
      sAttribute = Trim(Right(sAttribute, Len(sAttribute) - 1))
    EndIf
    If Right(sAttribute, 1) = ":"
      sAttribute = Trim(Left(sAttribute, Len(sAttribute) - 1))
    EndIf
    sAttribute = ReplaceString(sAttribute, Chr(13) + Chr(10), "<br />")
    sAttribute = ReplaceString(sAttribute, Chr(10), "<br />")
    Select sTag
      Case "author" : *PtrDoc\sAuthor = sAttribute
      Case "desc" : *PtrDoc\sDescription  = sAttribute
      Case "link" : *PtrDoc\sLink = sAttribute
      Case "return" : *PtrDoc\sReturn = sAttribute
      Case "sample" : *PtrDoc\sSample = sAttribute
      Default : Debug ">>>" + sTag + " ! " + sAttribute : CallDebugger
    EndSelect
  Next
EndProcedure
