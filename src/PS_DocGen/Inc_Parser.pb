ProcedureDLL DocGen_Parser(sFilename.s, ptrInclude.l)
  Protected plFile.l, plNbResults.l, plInc.l
  Protected psPathCur.s
  Protected psLine.s, psContent.s
  Protected pbInMultiline.b, pbInStructure.b, pbInEnumeration.b, pbInMacro.b
  Protected Dim ResRegex.s(0)
  
  ; Initialization of protected variables
  psPathCur = ""
  
  ; Extracts Data From File
  plFile = OpenFile(#PB_Any, sFilename)
  If plFile
    While Eof(plFile) = 0
      psLine = Trim(ReadString(plFile))
      If psLine > ""
        If pbInMultiline = #False
          plNbResults = ExtractRegularExpression(#Regex_CommentBefore, psLine, ResRegex())
          If plNbResults = 1
            psContent = ResRegex(0)
          Else
            psContent = ""
          EndIf
          ;{ IncludePath }
            plNbResults = ExtractRegularExpression(#Regex_IncPath, psContent, ResRegex())
            If plNbResults = 1
              psPathCur = ResRegex(0)
              Debug "IncludePath > " + psPathCur
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
                Debug "IncludeFile > " + ResRegex(0)
              EndWith
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
                Debug "Structure > " + ResRegex(0)
              EndWith
              pbInMultiline = #True
              pbInStructure = #True
            EndIf
          ;}
          ;{ Enumerations }
            plNbResults = ExtractRegularExpression(#Regex_Enumeration, psContent, ResRegex())
            If plNbResults = 1
              LastElement(LL_ListEnumerations())
              AddElement(LL_ListEnumerations())
              With LL_ListEnumerations()
                \ptrInclude = ptrInclude
                plNbResults = ExtractRegularExpression(#Regex_Doc, psContent, ResRegex())
                If plNbResults = 1
                  \sDescription = ResRegex(0)
                EndIf
                Debug "Enumeration > Found"
              EndWith
              pbInMultiline = #True
              pbInEnumeration = #True
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
                Debug "Macro > " + ResRegex(0)
              EndWith
              pbInMultiline = #True
              pbInMacro = #True
            EndIf
          ;}
          ;{ Tableaux }
          ;}
          ;{ Listes Chainees }
          ;}
          ;{ Constantes }
          ;}
          ;{ Procedure(C)(DLL) }
          ;}
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
                  Debug "Field > "+ ResRegex(0)
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
                  Debug "Field > "+ ResRegex(0)
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
                Debug "Content > "+ ResRegex(0)
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
        EndIf
      EndIf
    Wend
    CloseFile(plFile)
  Else
    MR_Error("Can't open the file : "+#DQuote+sFilename+#DQuote)
  EndIf
EndProcedure
