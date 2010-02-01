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

#DQuote = Chr(34)
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
  sFontColor.s
  sFontFamily.s
  lFontSize.l
  lFontStyle.l
  sBackgroundColor.s
EndStructure

  Declare HTML_CloseFile(ID.l)
  ProcedureDLL HTML_CreateFile(ID.l, Filename.s)
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
  ProcedureDLL HTML_CloseFile(ID.l)
    Protected *Object.S_TextHtml= TextHtml_ID(ID)
    Protected plFile.l, plIncA.l
    ; CloseFile
    If *Object
      With *Object
        plFile = CreateFile(#PB_Any, \sFilename)
        If plFile
          WriteStringN(plFile, "<html>")
          WriteStringN(plFile, "<head>")
          If \sTitle > ""
            WriteStringN(plFile, "<title>" + \sTitle + "</title>")
          EndIf
          If \sAuthor > ""
            WriteStringN(plFile, "<meta name="+#DQuote+"author"+#DQuote+" content="+#DQuote+\sAuthor+#DQuote+" />")
          EndIf
          If \sDescription > ""
            WriteStringN(plFile, "<meta name="+#DQuote+"description"+#DQuote+" content="+#DQuote+\sDescription+#DQuote+" />")
          EndIf
          If \sGenerator > ""
            WriteStringN(plFile, "<meta name="+#DQuote+"generator"+#DQuote+" content="+#DQuote+\sGenerator+#DQuote+" />")
          EndIf
          If \sKeyword > ""
            WriteStringN(plFile, "<meta name="+#DQuote+"keywords"+#DQuote+" content="+#DQuote+\sKeyword+#DQuote+" />")
          EndIf
          If \lEncoding > 0
            ; http://htmlhelp.com/tools/validator/supported-encodings.html.fr
            Select \lEncoding
              Case #PB_Ascii : WriteStringN(plFile, "<meta http-equiv="+#DQuote+"content-type"+#DQuote+" content=text/html; charset=ISO-8859-1"+#DQuote+" />")
              Case #PB_UTF8 : WriteStringN(plFile, "<meta http-equiv="+#DQuote+"content-type"+#DQuote+" content=text/html; charset=UTF-8"+#DQuote+" />")     
              Case #PB_UTF16 : WriteStringN(plFile, "<meta http-equiv="+#DQuote+"content-type"+#DQuote+" content=text/html; charset=UTF-16"+#DQuote+" />")     
              Case #PB_UTF16BE : WriteStringN(plFile, "<meta http-equiv="+#DQuote+"content-type"+#DQuote+" content=text/html; charset=UTF-16BE"+#DQuote+" />")     
            EndSelect
          EndIf
          ; javascript
          If \lJavascriptFileCount > 0
            WriteStringN(plFile, "<!-- js-file -->")
            For plIncA = 0 To \lJavascriptFileCount
              WriteStringN(plFile, "<script type="+#DQuote+"text/javascript"+#DQuote+" src="+#DQuote+\dimJavascriptFile[plIncA]+#DQuote+" />")
            Next
          EndIf
          If \sJavascriptContent > ""
            WriteStringN(plFile, "<!-- js-script -->")
            WriteStringN(plFile, "<script type="+#DQuote+"text/javascript"+#DQuote+" src="+#DQuote+\dimJavascriptFile[plIncA]+#DQuote+">"+\sJavascriptContent+"</script>")
          EndIf
          ; css
          If \lStylesheetFileCount > 0
            WriteStringN(plFile, "<!-- css-file -->")
            For plIncA = 0 To \lStylesheetFileCount
              WriteStringN(plFile, "<link rel="+#DQuote+"stylesheet"+#DQuote+" href="+#DQuote+\dimStylesheetFile[plIncA]+#DQuote+" type="+#DQuote+"text/css"+#DQuote+">")
            Next
          EndIf
          If \sStylesheetContent > ""
            WriteStringN(plFile, "<!-- css-script -->")
            WriteStringN(plFile, "<style type="+#DQuote+"text/css"+">"+\sStylesheetContent+"</style>")
          EndIf
          WriteStringN(plFile, "</head>")
          WriteStringN(plFile, "<body>")
          If \sHTMLBody > ""
            WriteStringN(plFile, \sHTMLBody)
          EndIf
          WriteStringN(plFile, "</body>")
          WriteStringN(plFile, "</html>")
          CloseFile(plFile)
        EndIf
      EndWith
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
  ProcedureDLL HTML_OpenParagraph(ID.l, *Format.S_HTML_Style_Format = #Null, *Style.S_HTML_Style_Paragraph = #Null)
    Protected *Object.S_TextHtml= TextHtml_ID(ID)
    Protected sStyleFormat.s
    If *Object
      With *Object
        If *Format > #Null
          If *Format\sFontColor > "" 
            sStyleFormat + "font-color:" + *Format\sFontColor + ";"
          EndIf
          If *Format\sFontFamily > ""
            sStyleFormat + "font-family:" + *Format\sFontFamily + ";"
          EndIf
          If *Format\lFontSize > #Null
            sStyleFormat + "font-size:" + Str(*Format\lFontSize) + "px;"
          EndIf
          If *Format\lFontStyle > #Null
            If *Format\lFontStyle & #PB_Font_Italic
              *Format\lFontStyle - #PB_Font_Italic
              sStyleFormat + "font-style:italic;"
            EndIf
            If *Format\lFontStyle & #PB_Font_Bold
              *Format\lFontStyle - #PB_Font_Bold
              sStyleFormat + "font-weight:bold;"
            EndIf
            If *Format\lFontStyle & #PB_Font_StrikeOut
              *Format\lFontStyle - #PB_Font_StrikeOut
              sStyleFormat + "font-style:strike-out;"
            EndIf
            If *Format\lFontStyle & #PB_Font_Underline
              *Format\lFontStyle - #PB_Font_Underline
              sStyleFormat + "text-decoration:underline;"
            EndIf
          EndIf
          If *Format\sBackgroundColor > ""
            sStyleFormat + " background-color:" + *Format\sBackgroundColor + ";"
          EndIf
        EndIf
        If sStyleFormat > ""
          \sHTMLBody + "<p style=" + #DQuote + sStyleFormat + #DQuote + ">"
        Else
          \sHTMLBody + "<p>"
        EndIf
      EndWith
    EndIf
  EndProcedure
  ProcedureDLL HTML_CloseParagraph(ID.l)
    Protected *Object.S_TextHtml= TextHtml_ID(ID)
    If *Object
      With *Object
        \sHTMLBody + "</p>"
      EndWith
    EndIf
  EndProcedure
  ProcedureDLL HTML_OpenSection(ID.l, *Format.S_HTML_Style_Format = #Null, *Style.S_HTML_Style_Paragraph = #Null)
    Protected *Object.S_TextHtml= TextHtml_ID(ID)
    Protected sStyleFormat.s
    If *Object
      With *Object
        If *Format > #Null
          If *Format\sFontColor > "" 
            sStyleFormat + "font-color:" + *Format\sFontColor + ";"
          EndIf
          If *Format\sFontFamily > ""
            sStyleFormat + "font-family:" + *Format\sFontFamily + ";"
          EndIf
          If *Format\lFontSize > #Null
            sStyleFormat + "font-size:" + Str(*Format\lFontSize) + "px;"
          EndIf
          If *Format\lFontStyle > #Null
            If *Format\lFontStyle & #PB_Font_Italic
              *Format\lFontStyle - #PB_Font_Italic
              sStyleFormat + "font-style:italic;"
            EndIf
            If *Format\lFontStyle & #PB_Font_Bold
              *Format\lFontStyle - #PB_Font_Bold
              sStyleFormat + "font-weight:bold;"
            EndIf
            If *Format\lFontStyle & #PB_Font_StrikeOut
              *Format\lFontStyle - #PB_Font_StrikeOut
              sStyleFormat + "font-style:strike-out;"
            EndIf
            If *Format\lFontStyle & #PB_Font_Underline
              *Format\lFontStyle - #PB_Font_Underline
              sStyleFormat + "text-decoration:underline;"
            EndIf
          EndIf
          If *Format\sBackgroundColor > ""
            sStyleFormat + " background-color:" + *Format\sBackgroundColor + ";"
          EndIf
        EndIf
        If sStyleFormat > ""
          \sHTMLBody + "<div style=" + #DQuote + sStyleFormat + #DQuote + ">"
        Else
          \sHTMLBody + "<div>"
        EndIf
      EndWith
    EndIf
  EndProcedure
  ProcedureDLL HTML_CloseSection(ID.l)
    Protected *Object.S_TextHtml= TextHtml_ID(ID)
    If *Object
      With *Object
        \sHTMLBody + "</div>"
      EndWith
    EndIf
  EndProcedure
  ProcedureDLL HTML_OpenBlock(ID.l, *Format.S_HTML_Style_Format = #Null, *Style.S_HTML_Style_Paragraph = #Null)
    Protected *Object.S_TextHtml= TextHtml_ID(ID)
    Protected sStyleFormat.s
    If *Object
      With *Object
        If *Format > #Null
          If *Format\sFontColor > "" 
            sStyleFormat + "font-color:" + *Format\sFontColor + ";"
          EndIf
          If *Format\sFontFamily > ""
            sStyleFormat + "font-family:" + *Format\sFontFamily + ";"
          EndIf
          If *Format\lFontSize > #Null
            sStyleFormat + "font-size:" + Str(*Format\lFontSize) + "px;"
          EndIf
          If *Format\lFontStyle > #Null
            If *Format\lFontStyle & #PB_Font_Italic
              *Format\lFontStyle - #PB_Font_Italic
              sStyleFormat + "font-style:italic;"
            EndIf
            If *Format\lFontStyle & #PB_Font_Bold
              *Format\lFontStyle - #PB_Font_Bold
              sStyleFormat + "font-weight:bold;"
            EndIf
            If *Format\lFontStyle & #PB_Font_StrikeOut
              *Format\lFontStyle - #PB_Font_StrikeOut
              sStyleFormat + "font-style:strike-out;"
            EndIf
            If *Format\lFontStyle & #PB_Font_Underline
              *Format\lFontStyle - #PB_Font_Underline
              sStyleFormat + "text-decoration:underline;"
            EndIf
          EndIf
          If *Format\sBackgroundColor > ""
            sStyleFormat + " background-color:" + *Format\sBackgroundColor + ";"
          EndIf
        EndIf
        If sStyleFormat > ""
          \sHTMLBody + "<span style=" + #DQuote + sStyleFormat + #DQuote + ">"
        Else
          \sHTMLBody + "<span>"
        EndIf
      EndWith
    EndIf
  EndProcedure
  ProcedureDLL HTML_CloseBlock(ID.l)
    Protected *Object.S_TextHtml= TextHtml_ID(ID)
    If *Object
      With *Object
        \sHTMLBody + "</span>"
      EndWith
    EndIf
  EndProcedure
  ;- Tables
  ProcedureDLL HTML_OpenTable(ID.l)
    Protected *Object.S_TextHtml= TextHtml_ID(ID)
    If *Object
      With *Object
        \sHTMLBody + "<table>"
      EndWith
    EndIf
  EndProcedure
  ProcedureDLL HTML_CloseTable(ID.l)
    Protected *Object.S_TextHtml= TextHtml_ID(ID)
    If *Object
      With *Object
        \sHTMLBody + "</table>"
      EndWith
    EndIf
  EndProcedure
  ProcedureDLL HTML_OpenTableHeader(ID.l)
    Protected *Object.S_TextHtml= TextHtml_ID(ID)
    If *Object
      With *Object
        \sHTMLBody + "<thead>"
      EndWith
    EndIf
  EndProcedure
  ProcedureDLL HTML_CloseTableHeader(ID.l)
    Protected *Object.S_TextHtml= TextHtml_ID(ID)
    If *Object
      With *Object
        \sHTMLBody + "</thead>"
      EndWith
    EndIf
  EndProcedure
  ProcedureDLL HTML_OpenTableBody(ID.l)
    Protected *Object.S_TextHtml= TextHtml_ID(ID)
    If *Object
      With *Object
        \sHTMLBody + "<tbody>"
      EndWith
    EndIf
  EndProcedure
  ProcedureDLL HTML_CloseTableBody(ID.l)
    Protected *Object.S_TextHtml= TextHtml_ID(ID)
    If *Object
      With *Object
        \sHTMLBody + "</tbody>"
      EndWith
    EndIf
  EndProcedure
  ProcedureDLL HTML_OpenTableRow(ID.l)
    Protected *Object.S_TextHtml= TextHtml_ID(ID)
    If *Object
      With *Object
        \sHTMLBody + "<tr>"
      EndWith
    EndIf
  EndProcedure
  ProcedureDLL HTML_CloseTableRow(ID.l)
    Protected *Object.S_TextHtml= TextHtml_ID(ID)
    If *Object
      With *Object
        \sHTMLBody + "</tr>"
      EndWith
    EndIf
  EndProcedure
  ProcedureDLL HTML_OpenTableCell(ID.l)
    Protected *Object.S_TextHtml= TextHtml_ID(ID)
    If *Object
      With *Object
        \sHTMLBody + "<td>"
      EndWith
    EndIf
  EndProcedure
  ProcedureDLL HTML_CloseTableCell(ID.l)
    Protected *Object.S_TextHtml= TextHtml_ID(ID)
    If *Object
      With *Object
        \sHTMLBody + "</td>"
      EndWith
    EndIf
  EndProcedure
  ;- Lists
  ProcedureDLL HTML_OpenList(ID.l)
    Protected *Object.S_TextHtml= TextHtml_ID(ID)
    If *Object
      With *Object
        \sHTMLBody + "<ul>"
      EndWith
    EndIf
  EndProcedure
  ProcedureDLL HTML_CloseList(ID.l)
    Protected *Object.S_TextHtml= TextHtml_ID(ID)
    If *Object
      With *Object
       \sHTMLBody + "</ul>" 
      EndWith
    EndIf
  EndProcedure
  ProcedureDLL HTML_AddListElement(ID.l, Text.s)
    Protected *Object.S_TextHtml= TextHtml_ID(ID)
    If *Object
      With *Object
        \sHTMLBody + "<li>" + Text + "</li>"
      EndWith
    EndIf
  EndProcedure
  ;- Content
  ProcedureDLL HTML_AddImage(ID.l, Filename.s)
    Protected *Object.S_TextHtml= TextHtml_ID(ID)
    If *Object
      With *Object
        \sHTMLBody + "<img src="+Chr(34)+Filename+Chr(34)+" />"
      EndWith
    EndIf
  EndProcedure
  ProcedureDLL HTML_AddNewLine()
    Protected *Object.S_TextHtml= TextHtml_ID(ID)
    If *Object
      With *Object
        \sHTMLBody + "<br />"
      EndWith
    EndIf
  EndProcedure
  ProcedureDLL HTML_AddText(ID.l, Text.s, *Style.S_HTML_Style_Format)
    Protected *Object.S_TextHtml= TextHtml_ID(ID)
    If *Object
      With *Object
        \sHTMLBody + Text
      EndWith
    EndIf
  EndProcedure
  ProcedureDLL HTML_AddTextWiki(ID.l, Text.s)
    Protected *Object.S_TextHtml= TextHtml_ID(ID)
    If *Object
      With *Object
        \sHTMLBody + Text
      EndWith
    EndIf
  EndProcedure
  ProcedureDLL HTML_AddHeader(ID.l, HeaderLevel.l, Text.s)
    Protected *Object.S_TextHtml= TextHtml_ID(ID)
    If *Object
      With *Object
        \sHTMLBody + "<h"+Str(HeaderLevel)+">"
        \sHTMLBody + Text
        \sHTMLBody + "</h"+Str(HeaderLevel)+">"
      EndWith
    EndIf
  EndProcedure
  ProcedureDLL HTML_AddComment(ID.l, Comment.s)
    Protected *Object.S_TextHtml= TextHtml_ID(ID)
    If *Object
      With *Object
        \sHTMLBody + "<!-- "+Comment+" -->"
      EndWith
    EndIf
  EndProcedure
