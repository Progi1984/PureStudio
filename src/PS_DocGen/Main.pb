Procedure Main_DocGen()
  ; Initialisation
  glLogFile = LogFile_Create(#PB_Any)
  If FileSize(GetTemporaryDirectory() + #sApplication_Name + #System_Separator) <> -2
    CreateDirectory(GetTemporaryDirectory() + #sApplication_Name + #System_Separator) 
  EndIf
  LogFile_SetOutputFile(glLogFile, GetTemporaryDirectory() + #sApplication_Name + #System_Separator + "LogFile.log")
  LogFile_SetFormatter(glLogFile, "[%yyyy.%mm.%dd %hh:%ii:%ss](%cat) - %content")
  LogFile_AddLog(glLogFile, "Initialisation Completed...")

  LogFile_AddLog(glLogFile, "=====")

  ; Parsing files
  LogFile_AddLog(glLogFile, "Parsing Files")
  LogFile_AddLog(glLogFile, "> Parser : " + gsProject\sFilename)
  DocGen_Parser(gsProject\sFilename, -1)
  If ListSize(LL_IncludeFiles()) > 0
    ForEach LL_IncludeFiles()
      With LL_IncludeFiles()
        LogFile_AddLog(glLogFile, "> Parser : " + GetPathPart(gsProject\sFilename) + \sPath + \sFilename)
        DocGen_Parser(GetPathPart(gsProject\sFilename) + \sPath + \sFilename, ListIndex(LL_IncludeFiles()))
      EndWith
    Next
  EndIf
  
  LogFile_AddLog(glLogFile, "=====")
    
  ; Export docs
  LogFile_AddLog(glLogFile, "Export docs")
  If ListSize(LL_Exports()) > 0
    ForEach LL_Exports()
      With LL_Exports()
        LogFile_AddLog(glLogFile, "> Export : Type (" + Str(\lType) + ") - File ("+\sPathExport + \sFileExport+")")
        DocGen_Export(\lType, \sPathExport, \sFileExport)
      EndWith
    Next
   EndIf
   LogFile_Save(glLogFile)
EndProcedure

