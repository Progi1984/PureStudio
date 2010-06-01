Procedure Main_DocGen()
  ; Parsing files
  Debug "==Parsing Files"
  DocGen_Parser(gsProject\sFilename, -1)
  If ListSize(LL_IncludeFiles()) > 0
    ForEach LL_IncludeFiles()
      With LL_IncludeFiles()
        DocGen_Parser(GetPathPart(gsProject\sFilename) + \sPath + \sFilename, ListIndex(LL_IncludeFiles()))
      EndWith
    Next
  EndIf
    
  ; Export docs
  Debug "==Export docs"
  If ListSize(LL_Exports()) > 0
    ForEach LL_Exports()
      With LL_Exports()
        DocGen_Export(\lType, \sPathExport, \sFileExport)
      EndWith
    Next
   EndIf
EndProcedure

