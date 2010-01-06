;- Structures
Structure S_TypeExport
  lType.l
  sPathExport.s
EndStructure
Structure S_FileInclude
  sPath.s
  sFilename.s
EndStructure
Structure S_TypeStructure
  sName.s
  sDescription.s
  sField.s
  sFieldDescription.s
  ptrInclude.l
EndStructure
Structure S_TypeEnum
  sDescription.s
  sField.s
  sFieldDescription.s
  ptrInclude.l
EndStructure
Structure S_TypeMacro
  sName.s
  sDescription.s
  sContent.s
  ptrInclude.l
EndStructure
Structure S_TypeArray
  sName.s
  sDescription.s
  bIsGlobal.b
  ptrInclude.l
EndStructure
Structure S_TypeLinkedList
  sName.s
  sDescription.s
  bIsGlobal.b
  ptrInclude.l
EndStructure
Structure S_TypeConstant
  sName.s
  sValue.s
  sDescription.s
  ptrInclude.l
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
  #Regex_CommentBefore
  #Regex_Constant
  #Regex_ConstantValue
  #Regex_Doc
  #Regex_EndGroup
  #Regex_Enumeration
  #Regex_IncFile
  #Regex_IncPath
  #Regex_IsGlobal
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
Global NewList LL_ListStructures.S_TypeStructure()
Global NewList LL_ListEnumerations.S_TypeEnum()
Global NewList LL_ListMacros.S_TypeMacro()
Global NewList LL_ListArrays.S_TypeArray()
Global NewList LL_ListLinkedLists.S_TypeLinkedList()
Global NewList LL_ListConstants.S_TypeConstant()

;-Globals
Global gsMainFile.s

;-Macros
Macro MR_Error(sError)
  MessageRequester(#sApplication_Name, sError)
EndMacro

;-Regex
;@desc : Regex for detecting include files
If CreateRegularExpression(#Regex_IncFile, "(?<=((?i)includefile)\s"+#DQuote+")[^\"+#DQuote+"]+(?="+#DQuote+")") = #False
  MR_Error("REGEX : IncFile > " + RegularExpressionError())
  End
EndIf
;@desc : Regex for defining include path
If CreateRegularExpression(#Regex_IncPath, "(?<=((?i)includepath)\s"+#DQuote+")[^\"+#DQuote+"]+(?="+#DQuote+")") = #False
  MR_Error("REGEX : IncPath > " + RegularExpressionError())
  End
EndIf
;@desc : Regex for detecting structures
If CreateRegularExpression(#Regex_Structure, "(?<=((?i)structure))\s+[A-Za-z\_]+") = #False
  MR_Error("REGEX : Structure > " + RegularExpressionError())
  End
EndIf
;@desc : Regex for detecting enumerations
If CreateRegularExpression(#Regex_Enumeration, "(?<=((?i)enumeration))") = #False
  MR_Error("REGEX : Enumeration > " + RegularExpressionError())
  End
EndIf
;@desc : Regex for detecting macros
If CreateRegularExpression(#Regex_Macro, "(?<=((?i)macro))\s+[A-Za-z\_]+") = #False
  MR_Error("REGEX : Macro > " + RegularExpressionError())
  End
EndIf
;@desc : Regex for detecting arrays
If CreateRegularExpression(#Regex_Array, "(?<=((?i)dim))\s+[A-Za-z0-9\_\(\)\.]+") = #False
  MR_Error("REGEX : Array > " + RegularExpressionError())
  End
EndIf
;@desc : Regex for detecting linked lists
If CreateRegularExpression(#Regex_LinkedList, "(?<=((?i)newlist))\s+[A-Za-z\_\(\)\.]+") = #False
  MR_Error("REGEX : Linked List > " + RegularExpressionError())
  End
EndIf
;@desc : Regex for detecting structures
If CreateRegularExpression(#Regex_Procedure, "(?<=((?i)procedure\s))[A-Za-z\_]+") = #False
  MR_Error("REGEX : Procedure > " + RegularExpressionError())
  End
EndIf
If CreateRegularExpression(#Regex_ProcedureC, "(?<=((?i)procedurec\s))[A-Za-z\_]+") = #False
  MR_Error("REGEX : ProcedureC > " + RegularExpressionError())
  End
EndIf
If CreateRegularExpression(#Regex_ProcedureCDLL, "(?<=((?i)procedurecdll\s))[A-Za-z\_]+") = #False
  MR_Error("REGEX : ProcedureCDLL > " + RegularExpressionError())
  End
EndIf
If CreateRegularExpression(#Regex_ProcedureDLL, "(?<=((?i)proceduredll\s))[A-Za-z\_]+") = #False
  MR_Error("REGEX : ProcedureDLL > " + RegularExpressionError())
  End
EndIf
;@desc : Regex for detecting params
If CreateRegularExpression(#Regex_Parameter, "(?<=(\(|\,|\s))[A-Za-z\_\.]+(?=(\)|\,|\s))") = #False
  MR_Error("REGEX : Parameter > " + RegularExpressionError())
  End
EndIf
;@desc : Regex for detecting doc
If CreateRegularExpression(#Regex_Doc, "(?<=(;@\s)).+") = #False
  MR_Error("REGEX : Doc > " + RegularExpressionError())
  End
EndIf
;@desc : Regex for detecting whatever before comment
If CreateRegularExpression(#Regex_CommentBefore, "^[^;]+(?=(;{0,}))") = #False
  MR_Error("REGEX : CommentBefore > " + RegularExpressionError())
  End
EndIf
;@desc : Regex for detecting EndGroup (EndStructure, EndEnumeration)
If CreateRegularExpression(#Regex_EndGroup, "(?i)end[A-Za-z]+") = #False
  MR_Error("REGEX : EndGroup > " + RegularExpressionError())
  End
EndIf
;@desc : Regex for detecting if it is a global
If CreateRegularExpression(#Regex_IsGlobal, "(?i)Global") = #False
  MR_Error("REGEX : IsGlobal > " + RegularExpressionError())
  End
EndIf
;@desc : Regex for detecting comment
If CreateRegularExpression(#Regex_Constant, "#[A-Za-z\_]{1,}(?=\s{0,}=)") = #False
  MR_Error("REGEX : Comment > " + RegularExpressionError())
  End
EndIf
;@desc : Regex for detecting if it is a global
If CreateRegularExpression(#Regex_ConstantValue, "(?<==\s).+") = #False
  MR_Error("REGEX : CommentValue > " + RegularExpressionError())
  End
EndIf
