IncludePath "Inc"
  XIncludeFile "StringBuilder.pb"
IncludePath "Inc_PBEAR"
  XIncludeFile "PBEAR.pb"
  XIncludeFile "Text/Text.pb"
  XIncludeFile "Text/Text_HTML.pb"
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

gsMainFile = "/home/franklin/Documents/Projets/Moebius/Moebius_Main.pb"
AddElement(LL_Exports())
LL_Exports()\lType             = #ExportType_CHM
LL_Exports()\sPathExport  = "/home/franklin/Documents/Projets/PureStudio/data/PS_DocGen_CHM/"
If FileSize(gsMainFile) > 0
  Main_DocGen()
Else
  MR_Error("FileSize("+gsMainFile + ") >0")
EndIf
