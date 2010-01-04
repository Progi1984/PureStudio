ProcedureDLL DocGen_Parser(sFilename.s)
  Protected plFile.l, plNbResults.l, plInc.l
  Protected psLine.s, psPathCur.s
  Protected Dim ResRegex.s(0)
  
  ; Initialization of protected variables
  
  ; 
  plFile = OpenFile(#PB_Any, sFilename)
  If plFile
    While Eof(plFile) = 0
      psLine = ReadString(plFile)
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
    Wend
    CloseFile(plFile)
  Else
    MR_Error("Can't open the file : "+#DQuote+sFilename+#DQuote)
  EndIf
EndProcedure
