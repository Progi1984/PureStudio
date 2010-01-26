; http://xmlgraphics.apache.org/fop/dev/rtflib.html
; http://www.dokuwiki.org/syntax

;{ Object Management
  Global Objects_TextHtml.l
  ; Structures
  Structure S_TextHtml
    sFilename.s
  EndStructure
  ; Macros
  Macro TextHtml_ID(object)
    Object_GetObject(Objects_TextHtml, object)
  EndMacro
  Macro TextHtml_IS(object)
    Object_IsObject(Objects_TextHtml, object)
  EndMacro
  Macro TextHtml_NEW(object)
    Object_GetOrAllocateID(Objects_TextHtml, object)
  EndMacro
  Macro TextHtml_FREEID(object)
    If object <> #PB_Any And TextHtml_IS(object) = #True
      Object_FreeID(Objects_TextHtml, object)
    EndIf
  EndMacro
  Macro TextHtml_INIT(PtrCloseFn)
    Object_Init(SizeOf(S_TextHtml), 1, PtrCloseFn)
  EndMacro
;}

Enumeration
  #HTML_Alignment_Left
  #HTML_Alignment_Right
  #HTML_Alignment_Center
  #HTML_Alignment_Justify
EndEnumeration
Enumeration
  #HTML_Extern_Javascript
  #HTML_Extern_CSS
EndEnumeration
Structure S_HTML_Side
  Bottom.l
  Top.l
  Left.l
  Right.l
EndStructure
Structure S_HTML_Style_Paragraph
  Alignment.l
  Padding.S_HTML_Side
  Border.S_HTML_Side
  BorderStyle.S_HTML_Side
EndStructure
Structure S_HTML_Style_Format
  FontColor.l
  FontFamily.s
  FontSize.l
  FontStyle.l
  BackgroundColor.l
EndStructure

  Declare.l HTML_CloseFile(ID.l)
  ProcedureDLL.l HTML_CreateFile(ID.l, Filename.s)
    ; Initialization object
    If Objects_TextHtml = 0
      Objects_TextHtml = TextHtml_INIT(@HTML_CloseFile())
    EndIf
    ; CreateFile
    Protected *RObject.S_TextHtml = TextHtml_NEW(ID)
     With *RObject
        \sFilename = Filename
     EndWith
    ProcedureReturn *RObject
  EndProcedure
  ProcedureDLL.l HTML_CloseFile(ID.l)
    Protected *Object.S_TextHtml= TextHtml_ID(ID)
    ; CloseFile
    If *RObject
      
    EndIf
    ; Releasing object
    If *RObject
      TextHtml_FREEID(ID)
    EndIf
    ProcedureReturn #True
  EndProcedure

ProcedureDLL HTML_SetAuthor(ID.l, Author.s)
EndProcedure
ProcedureDLL HTML_SetTitle(ID.l, Title.s)
EndProcedure
ProcedureDLL HTML_SetDescription(ID.l, Description.s)
EndProcedure
ProcedureDLL HTML_SetGenerator(ID.l, Generator.s)
EndProcedure
ProcedureDLL HTML_SetKeywords(ID.l, Keywords.s)
EndProcedure
ProcedureDLL HTML_SetEncoding(ID.l, Encoding.l)
EndProcedure
ProcedureDLL HTML_AddExternFile(ID.l, Type.l, Filename.s)
  ; javascript
  ; stylesheet
EndProcedure
ProcedureDLL HTML_AddInternFile(ID.l, Type.l, Content.s)
  ; javascript
  ; stylesheet
EndProcedure

ProcedureDLL HTML_OpenParagraph(ID.l, *Style.S_HTML_Style_Paragraph)
EndProcedure
ProcedureDLL HTML_CloseParagraph(ID.l)
EndProcedure
ProcedureDLL HTML_OpenSection(ID.l, *Style.S_HTML_Style_Paragraph)
EndProcedure
ProcedureDLL HTML_CloseSection(ID.l)
EndProcedure
;- Tables
ProcedureDLL HTML_OpenTable(ID.l)
EndProcedure
ProcedureDLL HTML_CloseTable(ID.l)
EndProcedure
ProcedureDLL HTML_OpenTableHeader(ID.l)
EndProcedure
ProcedureDLL HTML_CloseTableHeader(ID.l)
EndProcedure
ProcedureDLL HTML_OpenTableRow(ID.l)
EndProcedure
ProcedureDLL HTML_CloseTableRow(ID.l)
EndProcedure
ProcedureDLL HTML_OpenTableCell(ID.l)
EndProcedure
ProcedureDLL HTML_CloseTableCell(ID.l)
EndProcedure

ProcedureDLL HTML_OpenList(ID.l)
EndProcedure
ProcedureDLL HTML_CloseList(ID.l)
EndProcedure
ProcedureDLL HTML_AddListElement(ID.l, Text.s)
EndProcedure

ProcedureDLL HTML_AddImage(ID.l, Filename.s)
EndProcedure
ProcedureDLL HTML_AddNewLine()
EndProcedure
ProcedureDLL HTML_AddText(ID.l, Text.s, *Style.S_HTML_Style_Format)
EndProcedure
ProcedureDLL HTML_AddTextWiki(ID.l, Text.s)
EndProcedure
ProcedureDLL HTML_AddHeader(ID.l, HeaderLevel.l, Text.s)
EndProcedure