IncludePath "Inc"
  XIncludeFile "Misc.pb"
  XIncludeFile "StringBuilder.pb"
IncludePath "Inc_PBEAR"
  XIncludeFile "PBEAR.pb"
  XIncludeFile "Text/Text.pb"
  XIncludeFile "Text/Text_HTML.pb"
  XIncludeFile "Log/Log_File.pb"
IncludePath "Inc_System"
  CompilerSelect #PB_Compiler_OS
    CompilerCase #PB_OS_Linux : XIncludeFile "Inc_Linux.pb"
    CompilerCase #PB_OS_Windows : XIncludeFile "Inc_Windows.pb"
  CompilerEndSelect
IncludePath "PS_DocGen"
  XIncludeFile "Inc_Var.pb"
  XIncludeFile "Inc_Parser.pb"
  XIncludeFile "Inc_Export_CHM.pb"
  XIncludeFile "Inc_Export.pb"
  XIncludeFile "Main.pb"

Main_Init()
If FileSize(gsProject\sFilename) > 0
  LogFile_AddLog(glLogFile, "=====")
  Main_ParseFiles()
  LogFile_AddLog(glLogFile, "=====")
  Main_ExportDoc()
  LogFile_AddLog(glLogFile, "=====")
EndIf
Main_End()