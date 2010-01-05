ProcedureDLL DocGen_Parser(sFilename.s, ptrInclude.l)
  Protected plFile.l, plNbResults.l, plInc.l
  Protected psLine.s, psPathCur.s
  Protected pbInMultiline.b, pbInStructure.b
  Protected Dim ResRegex.s(0)
  
  ; Initialization of protected variables
  psPathCur = ""
  
  ; Extracts Data From File
  plFile = OpenFile(#PB_Any, sFilename)
  If plFile
    While Eof(plFile) = 0
      psLine = ReadString(plFile)
        If pbInMultiline = #False
        ;{ IncludePath }
          plNbResults = ExtractRegularExpression(#Regex_IncPath, psLine, ResRegex())
          If plNbResults = 1
            psPathCur = ResRegex(0)
          EndIf
        ;}
        ;{ (X)IncludeFile }
          plNbResults = ExtractRegularExpression(#Regex_IncFile, psLine, ResRegex())
          If plNbResults = 1
            LastElement(LL_IncludeFiles())
            AddElement(LL_IncludeFiles())
            With LL_IncludeFiles()
              \sPath = psPathCur
              \sFilename = ResRegex(0)
            EndWith
          EndIf
        ;}
        ;{ Structures }
          plNbResults = ExtractRegularExpression(#Regex_Structure, psLine, ResRegex())
          If plNbResults = 1
            LastElement(LL_ListStructures())
            AddElement(LL_ListStructures())
            With LL_ListStructures()
              \ptrInclude = ptrInclude
              \sName = ResRegex(0)
            EndWith
            pbInMultiline = #True
            pbInStructure = #True
          EndIf
        ;}
        ;{ Enumerations }
        ;}
        ;{ Macros }
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
            pbInStructure = #False
          EndIf
        EndIf
      EndIf
    Wend
    CloseFile(plFile)
  Else
    MR_Error("Can't open the file : "+#DQuote+sFilename+#DQuote)
  EndIf
EndProcedure
