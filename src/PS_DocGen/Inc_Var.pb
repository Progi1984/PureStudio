;- Structures
Structure S_TypeExport
  lType.l
  sPathExport.s
EndStructure
Structure S_FileInclude
  sPath.s
  sFilename.s
EndStructure

;-Constantes
Enumeration ; ExportType
  #ExportType_CHM
  #ExportType_DOC_97
  #ExportType_DOC_2003
  #ExportType_DocBook
  #ExportType_DOCX
  #ExportType_FrameMaker
  #ExportType_H1S
  #ExportType_HLP
  #ExportType_HSX
  #ExportType_HTB
  #ExportType_HTML
  #ExportType_HXS
  #ExportType_Latex
  #ExportType_ODT
  #ExportType_PDF
  #ExportType_PostScript
  #ExportType_RTF
  #ExportType_SGML
  #ExportType_SXW
  #ExportType_TexInfo
  #ExportType_Text
  #ExportType_XPS
  #ExportType_Troff
EndEnumeration
Enumeration ; Regex
  #Regex_Array
  #Regex_Doc
  #Regex_Enumeration
  #Regex_IncFile
  #Regex_IncPath
  #Regex_LinkedList
  #Regex_Macro
  #Regex_Parameter
  #Regex_Procedure
  #Regex_ProcedureC
  #Regex_ProcedureCDLL
  #Regex_ProcedureDLL
  #Regex_Structure
EndEnumeration
#DQuote = Chr(34)
#sApplication_Name = "DocGen"

;- Linked Lists
Global NewList LL_IncludeFiles.S_FileInclude()
Global NewList LL_Exports.S_TypeExport()

;-Globals
Global gsMainFile.s

;-Macros
Macro MR_Error(sError)
  MessageRequester(#sApplication_Name, sError)
EndMacro

;-Regex
;@desc : Regex for detecting include files
If CreateRegularExpression(#Regex_IncFile, "(?<=((?i)includefile)\s"+#DQuote+")[^\"+#DQuote+"]+(?="+#DQuote+")")
  MR_Error("REGEX : IncFile > " + RegularExpressionError())
  End
EndIf
;@desc : Regex for defining include path
If CreateRegularExpression(#Regex_IncPath, "(?<=((?i)includepath)\s"+#DQuote+")[^\"+#DQuote+"]+(?="+#DQuote+")")
  MR_Error("REGEX : IncPath > " + RegularExpressionError())
  End
EndIf
;@desc : Regex for detecting structures
If CreateRegularExpression(#Regex_Structure, "(?<=((?i)structure))\s+[A-Za-z\_]+")
  MR_Error("REGEX : Structure > " + RegularExpressionError())
  End
EndIf
;@desc : Regex for detecting enumerations
If CreateRegularExpression(#Regex_Enumeration, "(?<=((?i)enumeration))")
  MR_Error("REGEX : Enumeration > " + RegularExpressionError())
  End
EndIf
;@desc : Regex for detecting macros
If CreateRegularExpression(#Regex_Macro, "(?<=((?i)macro))\s+[A-Za-z\_]+")
  MR_Error("REGEX : Macro > " + RegularExpressionError())
  End
EndIf
;@desc : Regex for detecting arrays
If CreateRegularExpression(#Regex_Array, "(?<=((?i)dim))\s+[A-Za-z\_]+")
  MR_Error("REGEX : Array > " + RegularExpressionError())
  End
EndIf
;@desc : Regex for detecting linked lists
If CreateRegularExpression(#Regex_LinkedList, "(?<=((?i)array))\s+[A-Za-z\_]+")
  MR_Error("REGEX : Linked List > " + RegularExpressionError())
  End
EndIf
;@desc : Regex for detecting structures
If CreateRegularExpression(#Regex_Procedure, "(?<=((?i)procedure\s))[A-Za-z\_]+")
  MR_Error("REGEX : Procedure > " + RegularExpressionError())
  End
EndIf
If CreateRegularExpression(#Regex_ProcedureC, "(?<=((?i)procedurec\s))[A-Za-z\_]+")
  MR_Error("REGEX : ProcedureC > " + RegularExpressionError())
  End
EndIf
If CreateRegularExpression(#Regex_ProcedureCDLL, "(?<=((?i)procedurecdll\s))[A-Za-z\_]+")
  MR_Error("REGEX : ProcedureCDLL > " + RegularExpressionError())
  End
EndIf
If CreateRegularExpression(#Regex_ProcedureDLL, "(?<=((?i)proceduredll\s))[A-Za-z\_]+")
  MR_Error("REGEX : ProcedureDLL > " + RegularExpressionError())
  End
EndIf
;@desc : Regex for detecting params
If CreateRegularExpression(#Regex_Parameter, "(?<=(\(|\,|\s))[A-Za-z\_\.]+(?=(\)|\,|\s))")
  MR_Error("REGEX : Parameter > " + RegularExpressionError())
  End
EndIf
;@desc : Regex for detecting doc
If CreateRegularExpression(#Regex_Doc, "(?<=(;@\s)).+")
  MR_Error("REGEX : Doc > " + RegularExpressionError())
  End
EndIf
