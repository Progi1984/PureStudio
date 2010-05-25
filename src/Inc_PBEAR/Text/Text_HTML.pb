; http://xmlgraphics.apache.org/fop/dev/rtflib.html
; http://www.dokuwiki.org/syntax

;{ Object Management
  Global Objects_TextHtml.l
  ; Structures
  Structure S_TextHtml
    sFilename.s
    ; head
    lExternJSFileNb.l
    dimExternJSFile.s[100]
    sInternJSFile.s
    lExternCSSFileNb.l
    dimExternCSSFile.s[100]
    sInternCSSFile.s
    sTitle.s
    sDescription.s
    sAuthor.s
    sGenerator.s
    sKeywords.s
    lEncoding.l
    ; body
    sContent.s
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

Enumeration 1 ; #HTML_Alignment
  #HTML_Alignment_Left
  #HTML_Alignment_Right
  #HTML_Alignment_Center
  #HTML_Alignment_Justify
EndEnumeration
Enumeration ; #HTML_Extern
  #HTML_Extern_Javascript
  #HTML_Extern_CSS
EndEnumeration
Structure S_HTML_Side
  sBottom.s
  sTop.s
  sLeft.s
  sRight.s
EndStructure
Structure S_HTML_Style_Paragraph
  ; Margin
  bMargin.b
  S_Margin.S_HTML_Side
  ; Padding
  bPadding.b
  S_Padding.S_HTML_Side
  ; Border
  bBorder.b
  S_Border.S_HTML_Side
  S_BorderColor.S_HTML_Side
  S_BorderStyle.S_HTML_Side
EndStructure
Structure S_HTML_Style_Format
  bAlignment.b
  sFontColor.s
  sFontFamily.s
  sFontSize.s
  bFontStyleBold.b
  bFontStyleItalic.b
  bFontStyleOblique.b
  sBackgroundColor.s
EndStructure

  Declare.l HTML_CloseFile(ID.l)
  
  ProcedureDLL.s HTML_ReturnCSSFormat(*Format.S_HTML_Style_Format)
    Protected sCSS.s
    If *Format <> #Null
      If *Format\sFontColor <> ""
        sCSS + "color:" + *Format\sFontColor + ";"
      EndIf
      If *Format\sFontFamily <> ""
        sCSS + "font-family:" + *Format\sFontFamily + ";"
      EndIf
      If *Format\sFontSize <> ""
        sCSS + "font-size:" + *Format\sFontSize+ ";"
      EndIf
      If *Format\bFontStyleBold > 0
        sCSS + "font-weight:bold;"
      EndIf
      If *Format\bFontStyleItalic > 0
        sCSS + "font-style:italic;"
      EndIf
      If *Format\bFontStyleOblique > 0
        sCSS + "font-style:oblique;"
      EndIf
      If *Format\bAlignment > 0
        Select *Format\bAlignment
          Case #HTML_Alignment_Left : sCSS + "text-align:left;"
          Case #HTML_Alignment_Right : sCSS + "text-align:right;"
          Case #HTML_Alignment_Center : sCSS + "text-align:center;"
          Case #HTML_Alignment_Justify : sCSS + "text-align:justify;"
        EndSelect
      EndIf
      If *Format\sBackgroundColor <> ""
        sCSS + "background-color:" + *Format\sBackgroundColor + ";"
      EndIf
      ProcedureReturn sCSS.s
    Else
      ProcedureReturn ""
    EndIf
  EndProcedure
  ProcedureDLL.s HTML_ReturnCSSParagraph(*Format.S_HTML_Style_Paragraph)
  EndProcedure
  
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
      With *RObject
        
      EndWith
    EndIf
    ; Releasing object
    If *RObject
      TextHtml_FREEID(ID)
    EndIf
    ProcedureReturn #True
  EndProcedure

  ProcedureDLL HTML_SetAuthor(ID.l, Author.s)
      Protected *Object.S_TextHtml= TextHtml_ID(ID)
      If *RObject
        With *RObject
          \sAuthor = Author
        EndWith
        ProcedureReturn #True
      Else
        ProcedureReturn #False
      EndIf
  EndProcedure
  ProcedureDLL HTML_SetTitle(ID.l, Title.s)
      Protected *Object.S_TextHtml= TextHtml_ID(ID)
      If *RObject
        With *RObject
          \sTitle = Title
        EndWith
        ProcedureReturn #True
      Else
        ProcedureReturn #False
      EndIf
  EndProcedure
  ProcedureDLL HTML_SetDescription(ID.l, Description.s)
      Protected *Object.S_TextHtml= TextHtml_ID(ID)
      If *RObject
        With *RObject
          \sDescription = Description
        EndWith
        ProcedureReturn #True
      Else
        ProcedureReturn #False
      EndIf
  EndProcedure
  ProcedureDLL HTML_SetGenerator(ID.l, Generator.s)
      Protected *Object.S_TextHtml= TextHtml_ID(ID)
      If *RObject
        With *RObject
          \sGenerator = Generator
        EndWith
        ProcedureReturn #True
      Else
        ProcedureReturn #False
      EndIf
  EndProcedure
  ProcedureDLL HTML_SetKeywords(ID.l, Keywords.s)
      Protected *Object.S_TextHtml= TextHtml_ID(ID)
      If *RObject
        With *RObject
          \sKeywords = Keywords
        EndWith
        ProcedureReturn #True
      Else
        ProcedureReturn #False
      EndIf
  EndProcedure
  ProcedureDLL HTML_SetEncoding(ID.l, Encoding.l)
      Protected *Object.S_TextHtml= TextHtml_ID(ID)
      If *RObject
        With *RObject
          \lEncoding = lEncoding
        EndWith
        ProcedureReturn #True
      Else
        ProcedureReturn #False
      EndIf
  EndProcedure
  ProcedureDLL HTML_AddExternFile(ID.l, Type.l, Filename.s)
      Protected *Object.S_TextHtml= TextHtml_ID(ID)
      If *RObject
        With *RObject
          If Type = #HTML_Extern_Javascript
            \dimExternJSFile[\lExternJSFileNb] = Filename
            \lExternJSFileNb +1
          ElseIf Type = #HTML_Extern_CSS
            \dimExternCSSFile[\lExternCSSFileNb] = Filename
            \lExternCSSFileNb +1
          EndIf
        EndWith
        ProcedureReturn #True
      Else
        ProcedureReturn #False
      EndIf
  EndProcedure
  ProcedureDLL HTML_AddInternFile(ID.l, Type.l, Content.s)
      Protected *Object.S_TextHtml= TextHtml_ID(ID)
      If *RObject
        With *RObject
          If Type = #HTML_Extern_Javascript
            \sInternJSFile + Content
          ElseIf Type = #HTML_Extern_CSS
            \sInternCSSFile + Content
          EndIf
        EndWith
        ProcedureReturn #True
      Else
        ProcedureReturn #False
      EndIf
  EndProcedure
  
  ProcedureDLL HTML_OpenParagraph(ID.l, *Style.S_HTML_Style_Paragraph)
      Protected *Object.S_TextHtml= TextHtml_ID(ID)
      If *RObject
        With *RObject
          
        EndWith
        ProcedureReturn #True
      Else
        ProcedureReturn #False
      EndIf
  EndProcedure
  ProcedureDLL HTML_CloseParagraph(ID.l)
      Protected *Object.S_TextHtml= TextHtml_ID(ID)
      If *RObject
        With *RObject
          \sContent + "</p>"
        EndWith
        ProcedureReturn #True
      Else
        ProcedureReturn #False
      EndIf
  EndProcedure
  ProcedureDLL HTML_OpenSection(ID.l, *Style.S_HTML_Style_Paragraph)
      Protected *Object.S_TextHtml= TextHtml_ID(ID)
      If *RObject
        With *RObject
          \sContent + "<div>"
        EndWith
        ProcedureReturn #True
      Else
        ProcedureReturn #False
      EndIf
  EndProcedure
  ProcedureDLL HTML_CloseSection(ID.l)
      Protected *Object.S_TextHtml= TextHtml_ID(ID)
      If *RObject
        With *RObject
          \sContent + "</div>"
        EndWith
        ProcedureReturn #True
      Else
        ProcedureReturn #False
      EndIf
  EndProcedure
  ;- Tables
  ProcedureDLL HTML_OpenTable(ID.l)
      Protected *Object.S_TextHtml= TextHtml_ID(ID)
      If *RObject
        With *RObject
          
        EndWith
        ProcedureReturn #True
      Else
        ProcedureReturn #False
      EndIf
  EndProcedure
  ProcedureDLL HTML_CloseTable(ID.l)
      Protected *Object.S_TextHtml= TextHtml_ID(ID)
      If *RObject
        With *RObject
          
        EndWith
        ProcedureReturn #True
      Else
        ProcedureReturn #False
      EndIf
  EndProcedure
  ProcedureDLL HTML_OpenTableHeader(ID.l)
      Protected *Object.S_TextHtml= TextHtml_ID(ID)
      If *RObject
        With *RObject
          
        EndWith
        ProcedureReturn #True
      Else
        ProcedureReturn #False
      EndIf
  EndProcedure
  ProcedureDLL HTML_CloseTableHeader(ID.l)
      Protected *Object.S_TextHtml= TextHtml_ID(ID)
      If *RObject
        With *RObject
          
        EndWith
        ProcedureReturn #True
      Else
        ProcedureReturn #False
      EndIf
  EndProcedure
  ProcedureDLL HTML_OpenTableRow(ID.l)
      Protected *Object.S_TextHtml= TextHtml_ID(ID)
      If *RObject
        With *RObject
          
        EndWith
        ProcedureReturn #True
      Else
        ProcedureReturn #False
      EndIf
  EndProcedure
  ProcedureDLL HTML_CloseTableRow(ID.l)
      Protected *Object.S_TextHtml= TextHtml_ID(ID)
      If *RObject
        With *RObject
          
        EndWith
        ProcedureReturn #True
      Else
        ProcedureReturn #False
      EndIf
  EndProcedure
  ProcedureDLL HTML_OpenTableCell(ID.l)
      Protected *Object.S_TextHtml= TextHtml_ID(ID)
      If *RObject
        With *RObject
          
        EndWith
        ProcedureReturn #True
      Else
        ProcedureReturn #False
      EndIf
  EndProcedure
  ProcedureDLL HTML_CloseTableCell(ID.l)
      Protected *Object.S_TextHtml= TextHtml_ID(ID)
      If *RObject
        With *RObject
          
        EndWith
        ProcedureReturn #True
      Else
        ProcedureReturn #False
      EndIf
  EndProcedure
  
  ProcedureDLL HTML_OpenList(ID.l)
      Protected *Object.S_TextHtml= TextHtml_ID(ID)
      If *RObject
        With *RObject
          
        EndWith
        ProcedureReturn #True
      Else
        ProcedureReturn #False
      EndIf
  EndProcedure
  ProcedureDLL HTML_CloseList(ID.l)
      Protected *Object.S_TextHtml= TextHtml_ID(ID)
      If *RObject
        With *RObject
          
        EndWith
        ProcedureReturn #True
      Else
        ProcedureReturn #False
      EndIf
  EndProcedure
  ProcedureDLL HTML_AddListElement(ID.l, Text.s)
      Protected *Object.S_TextHtml= TextHtml_ID(ID)
      If *RObject
        With *RObject
          
        EndWith
        ProcedureReturn #True
      Else
        ProcedureReturn #False
      EndIf
  EndProcedure
  
  ProcedureDLL HTML_AddImage(ID.l, Filename.s)
      Protected *Object.S_TextHtml= TextHtml_ID(ID)
      If *RObject
        With *RObject
          
        EndWith
        ProcedureReturn #True
      Else
        ProcedureReturn #False
      EndIf
  EndProcedure
  ProcedureDLL HTML_AddNewLine()
      Protected *Object.S_TextHtml= TextHtml_ID(ID)
      If *RObject
        With *RObject
          
        EndWith
        ProcedureReturn #True
      Else
        ProcedureReturn #False
      EndIf
  EndProcedure
  ProcedureDLL HTML_AddText(ID.l, Text.s, *Style.S_HTML_Style_Format)
      Protected *Object.S_TextHtml= TextHtml_ID(ID)
      If *RObject
        With *RObject
          
        EndWith
        ProcedureReturn #True
      Else
        ProcedureReturn #False
      EndIf
  EndProcedure
  ProcedureDLL HTML_AddTextWiki(ID.l, Text.s)
      Protected *Object.S_TextHtml= TextHtml_ID(ID)
      If *RObject
        With *RObject
          
        EndWith
        ProcedureReturn #True
      Else
        ProcedureReturn #False
      EndIf
  EndProcedure
  ProcedureDLL HTML_AddHeader(ID.l, HeaderLevel.l, Text.s)
      Protected *Object.S_TextHtml= TextHtml_ID(ID)
      If *RObject
        With *RObject
          
        EndWith
        ProcedureReturn #True
      Else
        ProcedureReturn #False
      EndIf
  EndProcedure