Declare Main_LoadPrefs()

Procedure Main_End()
  LogFile_Save(glLogFile)
EndProcedure
Procedure Main_ExportDoc()
  LogFile_AddLog(glLogFile, "Export docs")
  If ListSize(LL_Exports()) > 0
    ForEach LL_Exports()
      With LL_Exports()
        LogFile_AddLog(glLogFile, "> Export : Type (" + Str(\lType) + ") - File ("+\sPathExport + \sFileExport+")")
        DocGen_Export(\lType)
      EndWith
    Next
   EndIf
EndProcedure
Procedure Main_Init()
  glLogFile = LogFile_Create(#PB_Any)
  If FileSize(GetTemporaryDirectory() + #sApplication_Name + #System_Separator) <> -2
    CreateDirectory(GetTemporaryDirectory() + #sApplication_Name + #System_Separator) 
  EndIf
  LogFile_SetOutputFile(glLogFile, GetTemporaryDirectory() + #sApplication_Name + #System_Separator + "LogFile.log")
  LogFile_SetFormatter(glLogFile, "[%yyyy.%mm.%dd %hh:%ii:%ss](%cat) - %content")
  LogFile_AddLog(glLogFile, "Initialisation Completed...")
  
  Main_LoadPrefs()
EndProcedure
Procedure Main_LoadPrefs()
  Protected psIniFile.s = ProgramParameter()
  Protected pbExportCHM.b, pbExportDocbook.b
  If FileSize(psIniFile) > 0
    If OpenPreferences(psIniFile) > 0
      LogFile_AddLog(glLogFile, "Load Prefs")
      PreferenceGroup("PROJECT")
      ;{ Project
        gsProject\sFilename = ReadPreferenceString("Filename", "")
        LogFile_AddLog(glLogFile, "> Filename : "+ gsProject\sFilename)
        gsProject\sName = ReadPreferenceString("Name", "")
        LogFile_AddLog(glLogFile, "> Name : "+ gsProject\sName)
        gsProject\sAuthor = ReadPreferenceString("Author", "")
        LogFile_AddLog(glLogFile, "> Author : "+ gsProject\sAuthor)
      ;}
      PreferenceGroup("PROJECT_FORMAT")
      ;{ Project Format
        pbExportCHM = ReadPreferenceLong("ExportCHM", #False)
      ;}
      If pbExportCHM = #True
        PreferenceGroup("EXPORT_CHM")
        AddElement(LL_Exports())
        LL_Exports()\lType             = #ExportType_CHM
        LL_Exports()\sFileExport   = ReadPreferenceString("FileOutput", "")
        LL_Exports()\sPathExport  = ReadPreferenceString("PathOutput", "")
        LogFile_AddLog(glLogFile, "> CHM : FileOutput : " + LL_Exports()\sPathExport + LL_Exports()\sFileExport) 
        LL_Exports()\ExportCHM\sCHMCompiler = ReadPreferenceString("CHMCompiler", "")
        LogFile_AddLog(glLogFile, "> CHM : CHMCompiler : " + LL_Exports()\ExportCHM\sCHMCompiler)
      EndIf
      ClosePreferences()
    Else
      LogFile_AddLog(glLogFile, "ERROR : <" + psIniFile + "> can't be opened as a preferences file")
    EndIf 
  Else
    LogFile_AddLog(glLogFile, "ERROR : <" + psIniFile + "> has a filesize equal to 0")
  EndIf
EndProcedure
Procedure Main_ParseFiles()
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
EndProcedure
