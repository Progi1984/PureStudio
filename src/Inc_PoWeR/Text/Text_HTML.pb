; http://xmlgraphics.apache.org/fop/dev/rtflib.html
; http://www.dokuwiki.org/syntax

;{ Object Management
  Global Objects_TextHtml.l
  ; Structures
  Structure S_TextHtml
    sFilename.s
    ; header
    sAuthor.s
    sTitle.s
    sDescription.s
    sGenerator.s
    sKeyword.s
    lEncoding.l
    ; javascript
    lJavascriptFileCount.l
    dimJavascriptFile.s[50]
    sJavascriptContent.s
    ; css
    lStylesheetFileCount.l
    dimStylesheetFile.s[50]
    sStylesheetContent.s
    ; body
    sHTMLBody.s
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
    Protected *Object.S_TextHtml = TextHtml_NEW(ID)
     With *Object
        \sFilename = Filename
     EndWith
    ProcedureReturn *Object
  EndProcedure
  ProcedureDLL.l HTML_CloseFile(ID.l)
    Protected *Object.S_TextHtml= TextHtml_ID(ID)
    ; CloseFile
    If *Object
      
    EndIf
    ; Releasing object
    If *Object
      TextHtml_FREEID(ID)
    EndIf
    ProcedureReturn #True
  EndProcedure

  ProcedureDLL HTML_SetAuthor(ID.l, Author.s)
    Protected *Object.S_TextHtml= TextHtml_ID(ID)
    If *Object
      With *Object
        \sAuthor = Author
      EndWith
    EndIf
  EndProcedure
  ProcedureDLL HTML_SetTitle(ID.l, Title.s)
    Protected *Object.S_TextHtml= TextHtml_ID(ID)
    If *Object
      With *Object
        \sTitle = Title
      EndWith
    EndIf
  EndProcedure
  ProcedureDLL HTML_SetDescription(ID.l, Description.s)
    Protected *Object.S_TextHtml= TextHtml_ID(ID)
      If *Object
        With *Object
          \sDescription = Description
        EndWith
      EndIf
  EndProcedure
  ProcedureDLL HTML_SetGenerator(ID.l, Generator.s)
    Protected *Object.S_TextHtml= TextHtml_ID(ID)
      If *Object
        With *Object
          \sGenerator = Generator
        EndWith
      EndIf
  EndProcedure
  ProcedureDLL HTML_SetKeywords(ID.l, Keywords.s)
    Protected *Object.S_TextHtml= TextHtml_ID(ID)
    If *Object
      With *Object
        \sKeyword = Keywords
      EndWith
    EndIf
  EndProcedure
  ProcedureDLL HTML_SetEncoding(ID.l, Encoding.l)
    Protected *Object.S_TextHtml= TextHtml_ID(ID)
    If *Object
      With *Object
        \lEncoding = Encoding
      EndWith
    EndIf
  EndProcedure
  ProcedureDLL HTML_AddExternFile(ID.l, Type.l, Filename.s)
    Protected *Object.S_TextHtml= TextHtml_ID(ID)
    If *Object
      With *Object
        If Type = #HTML_Extern_Javascript
          If Filename <> "" And \lJavascriptFileCount < 50
            \dimJavascriptFile[\lJavascriptFileCount] = Filename
            \lJavascriptFileCount + 1
          EndIf
        ElseIf Type = #HTML_Extern_CSS 
          If Filename <> "" And \lStylesheetFileCount < 50
            \dimStylesheetFile[\lStylesheetFileCount] = Filename
            \lStylesheetFileCount + 1
          EndIf
        EndIf
      EndWith
    EndIf
  EndProcedure
  ProcedureDLL HTML_AddInternFile(ID.l, Type.l, Content.s)
    Protected *Object.S_TextHtml= TextHtml_ID(ID)
    If *Object
      With *Object
        If Type = #HTML_Extern_Javascript
          If Content <> ""
            \sJavascriptContent + Content
          EndIf
        ElseIf Type = #HTML_Extern_CSS
          If Content <> ""
            \sStylesheetContent + Content
          EndIf
        EndIf
      EndWith
    EndIf
  EndProcedure
  ;- Paragraphs
  ProcedureDLL HTML_OpenParagraph(ID.l, *Style.S_HTML_Style_Paragraph)
    Protected *Object.S_TextHtml= TextHtml_ID(ID)
    If *Object
      With *Object
        \sBody + "<p>"
      EndWith
    EndIf
  EndProcedure
  ProcedureDLL HTML_CloseParagraph(ID.l)
    Protected *Object.S_TextHtml= TextHtml_ID(ID)
    If *Object
      With *Object
        \sBody + "</p>"
      EndWith
    EndIf
  EndProcedure
  ProcedureDLL HTML_OpenSection(ID.l, *Style.S_HTML_Style_Paragraph)
    Protected *Object.S_TextHtml= TextHtml_ID(ID)
    If *Object
      With *Object
        \sBody + "<div>"
      EndWith
    EndIf
  EndProcedure
  ProcedureDLL HTML_CloseSection(ID.l)
    Protected *Object.S_TextHtml= TextHtml_ID(ID)
    If *Object
      With *Object
        \sBody + "</div>"
      EndWith
    EndIf
  EndProcedure
  ;- Tables
  ProcedureDLL HTML_OpenTable(ID.l)
    Protected *Object.S_TextHtml= TextHtml_ID(ID)
    If *Object
      With *Object
        \sBody + "<table>"
      EndWith
    EndIf
  EndProcedure
  ProcedureDLL HTML_CloseTable(ID.l)
    Protected *Object.S_TextHtml= TextHtml_ID(ID)
    If *Object
      With *Object
        \sBody + "</table>"
      EndWith
    EndIf
  EndProcedure
  ProcedureDLL HTML_OpenTableHeader(ID.l)
    Protected *Object.S_TextHtml= TextHtml_ID(ID)
    If *Object
      With *Object
        \sBody + "<thead>"
      EndWith
    EndIf
  EndProcedure
  ProcedureDLL HTML_CloseTableHeader(ID.l)
    Protected *Object.S_TextHtml= TextHtml_ID(ID)
    If *Object
      With *Object
        \sBody + "</thead>"
      EndWith
    EndIf
  EndProcedure
  ProcedureDLL HTML_OpenTableBody(ID.l)
    Protected *Object.S_TextHtml= TextHtml_ID(ID)
    If *Object
      With *Object
        \sBody + "<tbody>"
      EndWith
    EndIf
  EndProcedure
  ProcedureDLL HTML_CloseTableBody(ID.l)
    Protected *Object.S_TextHtml= TextHtml_ID(ID)
    If *Object
      With *Object
        \sBody + "</tbody>"
      EndWith
    EndIf
  EndProcedure
  ProcedureDLL HTML_OpenTableRow(ID.l)
    Protected *Object.S_TextHtml= TextHtml_ID(ID)
    If *Object
      With *Object
        \sBody + "<tr>"
      EndWith
    EndIf
  EndProcedure
  ProcedureDLL HTML_CloseTableRow(ID.l)
    Protected *Object.S_TextHtml= TextHtml_ID(ID)
    If *Object
      With *Object
        \sBody + "</tr>"
      EndWith
    EndIf
  EndProcedure
  ProcedureDLL HTML_OpenTableCell(ID.l)
    Protected *Object.S_TextHtml= TextHtml_ID(ID)
    If *Object
      With *Object
        \sBody + "<td>"
      EndWith
    EndIf
  EndProcedure
  ProcedureDLL HTML_CloseTableCell(ID.l)
    Protected *Object.S_TextHtml= TextHtml_ID(ID)
    If *Object
      With *Object
        \sBody + "</td>"
      EndWith
    EndIf
  EndProcedure
  ;- Lists
  ProcedureDLL HTML_OpenList(ID.l)
    Protected *Object.S_TextHtml= TextHtml_ID(ID)
    If *Object
      With *Object
        \sBody + "<ul>"
      EndWith
    EndIf
  EndProcedure
  ProcedureDLL HTML_CloseList(ID.l)
    Protected *Object.S_TextHtml= TextHtml_ID(ID)
    If *Object
      With *Object
       \sBody + "</ul>" 
      EndWith
    EndIf
  EndProcedure
  ProcedureDLL HTML_AddListElement(ID.l, Text.s)
    Protected *Object.S_TextHtml= TextHtml_ID(ID)
    If *Object
      With *Object
        \sBody + "<li>" + Text + "</li>"
      EndWith
    EndIf
  EndProcedure
  ;- Content
  ProcedureDLL HTML_AddImage(ID.l, Filename.s)
    Protected *Object.S_TextHtml= TextHtml_ID(ID)
    If *Object
      With *Object
        \sBody + "<img src="+Chr(34)+Filename+Chr(34)+" />"
      EndWith
    EndIf
  EndProcedure
  ProcedureDLL HTML_AddNewLine()
    Protected *Object.S_TextHtml= TextHtml_ID(ID)
    If *Object
      With *Object
        \sBody + "<br />"
      EndWith
    EndIf
  EndProcedure
  ProcedureDLL HTML_AddText(ID.l, Text.s, *Style.S_HTML_Style_Format)
    Protected *Object.S_TextHtml= TextHtml_ID(ID)
    If *Object
      With *Object
        \sBody + Text
      EndWith
    EndIf
  EndProcedure
  ProcedureDLL HTML_AddTextWiki(ID.l, Text.s)
    Protected *Object.S_TextHtml= TextHtml_ID(ID)
    If *Object
      With *Object
        \sBody + Text
      EndWith
    EndIf
  EndProcedure
  ProcedureDLL HTML_AddHeader(ID.l, HeaderLevel.l, Text.s)
    Protected *Object.S_TextHtml= TextHtml_ID(ID)
    If *Object
      With *Object
        \sBody + "<h"+Str(HeaderLevel)+">"
        \sBody + Text
        \sBody + "</h"+Str(HeaderLevel)+">"
      EndWith
    EndIf
  EndProcedure
