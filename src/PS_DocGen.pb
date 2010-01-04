IncludePath "Inc"
  XIncludeFile "StringBuilder.pb"
IncludePath "PS_DocGen"
  XIncludeFile "Inc_Var.pb"
  XIncludeFile "Inc_Parser.pb"
  XIncludeFile "Inc_Export.pb"
  XIncludeFile "Main.pb"

gsMainFile = "/home/franklin/Documents/Projets/Moebius/Moebius_Main.pb"
If FileSize(gsMainFile) > 0
  Debug CreateThread(@Main_DocGen(), #True)
Else
  MR_Error("FileSize("+gsMainFile + ") >0")
EndIf
