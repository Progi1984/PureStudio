IncludePath "Inc"
  XIncludeFile "Misc.pb"
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

CompilerSelect #PB_Compiler_OS
  CompilerCase #PB_OS_Linux : gsProject\sFilename = "/home/franklin/Documents/Projets/Moebius/Moebius_Main.pb"
  CompilerCase #PB_OS_Windows : gsProject\sFilename = "K:\Moebius\Moebius_Main.pb"
CompilerEndSelect
gsProject\sName = "Moebius"
gsProject\sAuthor = "Progi1984"

AddElement(LL_Exports())
LL_Exports()\lType             = #ExportType_CHM
CompilerSelect #PB_Compiler_OS
  CompilerCase #PB_OS_Linux : LL_Exports()\sPathExport  = "/home/franklin/Documents/Projets/PureStudio/data/PS_DocGen_CHM/"
  CompilerCase #PB_OS_Windows : LL_Exports()\sPathExport = "K:\PureStudio\data\PS_DocGen_CHM\"
CompilerEndSelect

LL_Exports()\sFileExport   = "Moebius.chm"

If FileSize(gsProject\sFilename) > 0
  Main_DocGen()
Else
  MR_Error("FileSize("+gsProject\sFilename + ") >0")
EndIf
