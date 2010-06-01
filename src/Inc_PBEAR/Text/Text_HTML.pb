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
Enumeration 1 ; #HTML_Extern
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
  bAlignment.b
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
      If *Format\sBackgroundColor <> ""
        sCSS + "background-color:" + *Format\sBackgroundColor + ";"
      EndIf
      ProcedureReturn sCSS.s
    Else
      ProcedureReturn ""
    EndIf
  EndProcedure
  ProcedureDLL.s HTML_ReturnCSSParagraph(*Format.S_HTML_Style_Paragraph)
    Protected sCSS.s
    If *Format <> #Null
      If *Format\bAlignment > 0
        Select *Format\bAlignment
          Case #HTML_Alignment_Left : sCSS + "text-align:left;"
          Case #HTML_Alignment_Right : sCSS + "text-align:right;"
          Case #HTML_Alignment_Center : sCSS + "text-align:center;"
          Case #HTML_Alignment_Justify : sCSS + "text-align:justify;"
        EndSelect
      EndIf
      If *Format\bMargin = #True
        sCSS + "margin:"
        If *Format\S_Margin\sTop <> "" : sCSS + *Format\S_Margin\sTop : Else : sCSS + "0px" : EndIf
        sCSS + " " 
        If *Format\S_Margin\sRight <> "" : sCSS + *Format\S_Margin\sRight : Else : sCSS + "0px" : EndIf
        sCSS + " " 
        If *Format\S_Margin\sBottom <> "" : sCSS + *Format\S_Margin\sBottom : Else : sCSS + "0px" : EndIf
        sCSS + " " 
        If *Format\S_Margin\sLeft <> "" : sCSS + *Format\S_Margin\sLeft : Else : sCSS + "0px" : EndIf
        sCSS + ";" 
      EndIf
      If *Format\bPadding = #True
        sCSS + "padding:"
        If *Format\S_Padding\sTop <> "" : sCSS + *Format\S_Padding\sTop : Else : sCSS + "0px" : EndIf
        sCSS + " " 
        If *Format\S_Padding\sRight <> "" : sCSS + *Format\S_Padding\sRight : Else : sCSS + "0px" : EndIf
        sCSS + " " 
        If *Format\S_Padding\sBottom <> "" : sCSS + *Format\S_Padding\sBottom : Else : sCSS + "0px" : EndIf
        sCSS + " " 
        If *Format\S_Padding\sLeft <> "" : sCSS + *Format\S_Padding\sLeft : Else : sCSS + "0px" : EndIf
        sCSS + ";" 
      EndIf
      If *Format\bBorder = #True
        ; BORDER WIDTH
        sCSS + "border-width:"
        If *Format\S_Border\sTop <> "" : sCSS + *Format\S_Border\sTop : Else : sCSS + "0px" : EndIf
        sCSS + " " 
        If *Format\S_Border\sRight <> "" : sCSS + *Format\S_Border\sRight : Else : sCSS + "0px" : EndIf
        sCSS + " " 
        If *Format\S_Border\sBottom <> "" : sCSS + *Format\S_Border\sBottom : Else : sCSS + "0px" : EndIf
        sCSS + " " 
        If *Format\S_Border\sLeft <> "" : sCSS + *Format\S_Border\sLeft : Else : sCSS + "0px" : EndIf
        sCSS + ";" 
        ; BORDER STYLE
        sCSS + "border-style:"
        If *Format\S_BorderStyle\sTop <> "" : sCSS + *Format\S_BorderStyle\sTop : Else : sCSS + "solid" : EndIf
        sCSS + " " 
        If *Format\S_BorderStyle\sRight <> "" : sCSS + *Format\S_BorderStyle\sRight : Else : sCSS + "solid" : EndIf
        sCSS + " " 
        If *Format\S_BorderStyle\sBottom <> "" : sCSS + *Format\S_BorderStyle\sBottom : Else : sCSS + "solid" : EndIf
        sCSS + " " 
        If *Format\S_BorderStyle\sLeft <> "" : sCSS + *Format\S_BorderStyle\sLeft : Else : sCSS + "solid" : EndIf
        sCSS + ";" 
        ; BORDER COLOR
        sCSS + "border-color:"
        If *Format\S_BorderColor\sTop <> "" : sCSS + *Format\S_BorderColor\sTop : Else : sCSS + "	#000000" : EndIf
        sCSS + " " 
        If *Format\S_BorderColor\sRight <> "" : sCSS + *Format\S_BorderColor\sRight : Else : sCSS + "	#000000" : EndIf
        sCSS + " " 
        If *Format\S_BorderColor\sBottom <> "" : sCSS + *Format\S_BorderColor\sBottom : Else : sCSS + "	#000000" : EndIf
        sCSS + " " 
        If *Format\S_BorderColor\sLeft <> "" : sCSS + *Format\S_BorderColor\sLeft : Else : sCSS + "	#000000" : EndIf
        sCSS + ";" 
      EndIf
      ProcedureReturn sCSS
    Else
      ProcedureReturn ""
    EndIf
  EndProcedure
  
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
    Protected sHTMLContent.s
    Protected lHTMLFile.l
    If *Object
      With *Object
        ; html
        sHTMLContent + "<!DOCTYPE html PUBLIC "+Chr(34)+"-//W3C//DTD XHTML 1.1//EN"+Chr(34)+" "+Chr(34)+"http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd"+Chr(34)+">" + #CRLF$
        sHTMLContent + "<html>" + #CRLF$
        ; head
        sHTMLContent + "<head>"+ #CRLF$
        If \sTitle <> ""
          sHTMLContent + "<title>"+ \sTitle + "</title>"+ #CRLF$
        EndIf
        If \sAuthor <> ""
          sHTMLContent + "<meta name="+Chr(34)+"author"+Chr(34)+" content="+Chr(34)+\sAuthor+Chr(34)+" />"+ #CRLF$
        EndIf
        If \sDescription <> ""
          sHTMLContent + "<meta name="+Chr(34)+"description"+Chr(34)+" content="+Chr(34)+\sDescription+Chr(34)+" />"+ #CRLF$
        EndIf
        If \sKeywords <> ""
          sHTMLContent + "<meta name="+Chr(34)+"keywords"+Chr(34)+" content="+Chr(34)+\sKeywords+Chr(34)+" />"+ #CRLF$
        EndIf
        If \sGenerator <> ""
          sHTMLContent + "<meta name="+Chr(34)+"generator"+Chr(34)+" content="+Chr(34)+\sGenerator+Chr(34)+" />"+ #CRLF$
        EndIf
        If \lEncoding > 0
          ; http://htmlhelp.com/tools/validator/supported-encodings.html.en
          sHTMLContent + "<meta name="+Chr(34)+"Content-Type"+Chr(34)+" content="+Chr(34)+"text/html; charset="
          Select \lEncoding
            Case #PB_UTF16 : sHTMLContent + "UTF-16"
            Case #PB_UTF16BE : sHTMLContent + "UTF-16BE"
            Case #PB_UTF32 : sHTMLContent + "UTF-16"
            Case #PB_UTF32BE : sHTMLContent + "UTF-16BE"
            Case #PB_UTF8 : sHTMLContent + "UTF-8"
            Case #PB_Ascii : sHTMLContent + "ISO-8859-1"
            Case #PB_Unicode : sHTMLContent + "UTF-8"
          EndSelect
          sHTMLContent+Chr(34)+" />"+ #CRLF$
        EndIf
        If \lExternJSFileNb > 0
          For lInc = 0 To \lExternJSFileNb -1
            sHTMLContent + "<script src="+Chr(34)+\dimExternJSFile[lInc]+Chr(34)+" type="+Chr(34)+"text/javascript"+Chr(34)+">"+ #CRLF$
          Next
        EndIf
        If \lExternCSSFileNb > 0
          For lInc = 0 To \lExternCSSFileNb -1
            sHTMLContent + "<link href="+Chr(34)+\dimExternJSFile[lInc]+Chr(34)+" rel="+Chr(34)+"stylesheet"+Chr(34)+" type="+Chr(34)+"text/css"+Chr(34)+">"+ #CRLF$
          Next
        EndIf
        If \sInternJSFile <> ""
          sHTMLContent + "<script language="+Chr(34)+"javascript"+Chr(34)+">"+#CRLF$+\sInternJSFile+"</script>"+ #CRLF$
        EndIf
        If \sInternCSSFile <> ""
          sHTMLContent + "<style type="+Chr(34)+"text/css"+Chr(34)+">"+#CRLF$+\sInternCSSFile+"</style>"+ #CRLF$
        EndIf
        sHTMLContent + "</head>"+ #CRLF$
        ; body
        sHTMLContent + "<body>"+ #CRLF$
        sHTMLContent + \sContent+ #CRLF$
        sHTMLContent + "</body>"+ #CRLF$
        ; html
        sHTMLContent + "</html>"
        
        ;Write HTML File
        lHTMLFile = CreateFile(#PB_Any, \sFilename)
        If lHTMLFile
          WriteString(lHTMLFile, sHTMLContent)
          CloseFile(lHTMLFile)
        EndIf
      EndWith
    EndIf
    ; Releasing object
    If *Object
      TextHtml_FREEID(ID)
    EndIf
    ProcedureReturn #True
  EndProcedure
  ;- Header
  ProcedureDLL HTML_SetAuthor(ID.l, Author.s)
      Protected *Object.S_TextHtml= TextHtml_ID(ID)
      If *Object
        With *Object
          \sAuthor = Author
        EndWith
        ProcedureReturn #True
      Else
        ProcedureReturn #False
      EndIf
  EndProcedure
  ProcedureDLL HTML_SetTitle(ID.l, Title.s)
      Protected *Object.S_TextHtml= TextHtml_ID(ID)
      If *Object
        With *Object
          \sTitle = Title
        EndWith
        ProcedureReturn #True
      Else
        ProcedureReturn #False
      EndIf
  EndProcedure
  ProcedureDLL HTML_SetDescription(ID.l, Description.s)
      Protected *Object.S_TextHtml= TextHtml_ID(ID)
      If *Object
        With *Object
          \sDescription = Description
        EndWith
        ProcedureReturn #True
      Else
        ProcedureReturn #False
      EndIf
  EndProcedure
  ProcedureDLL HTML_SetGenerator(ID.l, Generator.s)
      Protected *Object.S_TextHtml= TextHtml_ID(ID)
      If *Object
        With *Object
          \sGenerator = Generator
        EndWith
        ProcedureReturn #True
      Else
        ProcedureReturn #False
      EndIf
  EndProcedure
  ProcedureDLL HTML_SetKeywords(ID.l, Keywords.s)
      Protected *Object.S_TextHtml= TextHtml_ID(ID)
      If *Object
        With *Object
          \sKeywords = Keywords
        EndWith
        ProcedureReturn #True
      Else
        ProcedureReturn #False
      EndIf
  EndProcedure
  ProcedureDLL HTML_SetEncoding(ID.l, Encoding.l)
      Protected *Object.S_TextHtml= TextHtml_ID(ID)
      If *Object
        With *Object
          \lEncoding = lEncoding
        EndWith
        ProcedureReturn #True
      Else
        ProcedureReturn #False
      EndIf
  EndProcedure
  ProcedureDLL HTML_AddExternFile(ID.l, Type.l, Filename.s)
      Protected *Object.S_TextHtml= TextHtml_ID(ID)
      If *Object
        With *Object
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
      If *Object
        With *Object
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
  ;- Boxes
  ProcedureDLL HTML_OpenParagraph(ID.l, *Style.S_HTML_Style_Paragraph = #Null, *Format.S_HTML_Style_Format = #Null)
      Protected *Object.S_TextHtml= TextHtml_ID(ID)
      If *Object
        With *Object
          \sContent + "<p"
          If *Style <> #Null Or *Format <> #Null
            \sContent + " style="+ Chr(34)
            If *Style <> #Null 
              \sContent + HTML_ReturnCSSParagraph(*Style)
            EndIf
            If *Format <> #Null 
              \sContent + HTML_ReturnCSSFormat(*Format)
            EndIf
            \sContent + Chr(34)
          EndIf
          \sContent + ">"
        EndWith
        ProcedureReturn #True
      Else
        ProcedureReturn #False
      EndIf
  EndProcedure
  ProcedureDLL HTML_CloseParagraph(ID.l)
      Protected *Object.S_TextHtml= TextHtml_ID(ID)
      If *Object
        With *Object
          \sContent + "</p>"
        EndWith
        ProcedureReturn #True
      Else
        ProcedureReturn #False
      EndIf
  EndProcedure
  ProcedureDLL HTML_OpenSection(ID.l, *Style.S_HTML_Style_Paragraph = #Null, *Format.S_HTML_Style_Format = #Null)
      Protected *Object.S_TextHtml= TextHtml_ID(ID)
      If *Object
        With *Object
          \sContent + "<div"
          If *Style <> #Null Or *Format <> #Null
            \sContent + " style="+ Chr(34)
            If *Style <> #Null 
              \sContent + HTML_ReturnCSSParagraph(*Style)
            EndIf
            If *Format <> #Null 
              \sContent + HTML_ReturnCSSFormat(*Format)
            EndIf
            \sContent + Chr(34)
          EndIf
          \sContent + ">"
        EndWith
        ProcedureReturn #True
      Else
        ProcedureReturn #False
      EndIf
  EndProcedure
  ProcedureDLL HTML_CloseSection(ID.l)
      Protected *Object.S_TextHtml= TextHtml_ID(ID)
      If *Object
        With *Object
          \sContent + "</div>"
        EndWith
        ProcedureReturn #True
      Else
        ProcedureReturn #False
      EndIf
  EndProcedure
  ProcedureDLL HTML_OpenBlock(ID.l, *Style.S_HTML_Style_Paragraph = #Null, *Format.S_HTML_Style_Format = #Null)
      Protected *Object.S_TextHtml= TextHtml_ID(ID)
      If *Object
        With *Object
          \sContent + "<span"
          If *Style <> #Null Or *Format <> #Null
            \sContent + " style="+ Chr(34)
            If *Style <> #Null 
              \sContent + HTML_ReturnCSSParagraph(*Style)
            EndIf
            If *Format <> #Null 
              \sContent + HTML_ReturnCSSFormat(*Format)
            EndIf
            \sContent + Chr(34)
          EndIf
          \sContent + ">"
        EndWith
        ProcedureReturn #True
      Else
        ProcedureReturn #False
      EndIf
  EndProcedure
  ProcedureDLL HTML_CloseBlock(ID.l)
      Protected *Object.S_TextHtml= TextHtml_ID(ID)
      If *Object
        With *Object
          \sContent + "</span>"
        EndWith
        ProcedureReturn #True
      Else
        ProcedureReturn #False
      EndIf
  EndProcedure
  ;- Tables
  ProcedureDLL HTML_OpenTable(ID.l)
      Protected *Object.S_TextHtml= TextHtml_ID(ID)
      If *Object
        With *Object
          \sContent + "<table>"
        EndWith
        ProcedureReturn #True
      Else
        ProcedureReturn #False
      EndIf
  EndProcedure
  ProcedureDLL HTML_CloseTable(ID.l)
      Protected *Object.S_TextHtml= TextHtml_ID(ID)
      If *Object
        With *Object
          \sContent + "</table>"
        EndWith
        ProcedureReturn #True
      Else
        ProcedureReturn #False
      EndIf
  EndProcedure
  ProcedureDLL HTML_OpenTableHeader(ID.l)
      Protected *Object.S_TextHtml= TextHtml_ID(ID)
      If *Object
        With *Object
          \sContent + "<th>"
        EndWith
        ProcedureReturn #True
      Else
        ProcedureReturn #False
      EndIf
  EndProcedure
  ProcedureDLL HTML_CloseTableHeader(ID.l)
      Protected *Object.S_TextHtml= TextHtml_ID(ID)
      If *Object
        With *Object
          \sContent + "</th>"
        EndWith
        ProcedureReturn #True
      Else
        ProcedureReturn #False
      EndIf
  EndProcedure
  ProcedureDLL HTML_OpenTableRow(ID.l)
      Protected *Object.S_TextHtml= TextHtml_ID(ID)
      If *Object
        With *Object
          \sContent + "<tr>"
        EndWith
        ProcedureReturn #True
      Else
        ProcedureReturn #False
      EndIf
  EndProcedure
  ProcedureDLL HTML_CloseTableRow(ID.l)
      Protected *Object.S_TextHtml= TextHtml_ID(ID)
      If *Object
        With *Object
          \sContent + "</tr>"
        EndWith
        ProcedureReturn #True
      Else
        ProcedureReturn #False
      EndIf
  EndProcedure
  ProcedureDLL HTML_OpenTableCell(ID.l)
      Protected *Object.S_TextHtml= TextHtml_ID(ID)
      If *Object
        With *Object
          \sContent + "<td>"
        EndWith
        ProcedureReturn #True
      Else
        ProcedureReturn #False
      EndIf
  EndProcedure
  ProcedureDLL HTML_CloseTableCell(ID.l)
      Protected *Object.S_TextHtml= TextHtml_ID(ID)
      If *Object
        With *Object
          \sContent + "</td>"
        EndWith
        ProcedureReturn #True
      Else
        ProcedureReturn #False
      EndIf
  EndProcedure
  ;- Lists
  ProcedureDLL HTML_OpenList(ID.l, bWithOrder)
      Protected *Object.S_TextHtml= TextHtml_ID(ID)
      If *Object
        With *Object
          If bWithOrder = #True
            \sContent + "<ol>"
          Else
            \sContent + "<ul>"
          EndIf
        EndWith
        ProcedureReturn #True
      Else
        ProcedureReturn #False
      EndIf
  EndProcedure
  ProcedureDLL HTML_CloseList(ID.l, bWithOrder)
      Protected *Object.S_TextHtml= TextHtml_ID(ID)
      If *Object
        With *Object
          If bWithOrder = #True
            \sContent + "</ol>"
          Else
            \sContent + "</ul>"
          EndIf
        EndWith
        ProcedureReturn #True
      Else
        ProcedureReturn #False
      EndIf
  EndProcedure
  ProcedureDLL HTML_AddListElement(ID.l, Text.s)
      Protected *Object.S_TextHtml= TextHtml_ID(ID)
      If *Object
        With *Object
          \sContent + "<li>" + Text + "</li>"
        EndWith
        ProcedureReturn #True
      Else
        ProcedureReturn #False
      EndIf
  EndProcedure
  ;- Misc
  ProcedureDLL HTML_AddImage(ID.l, Filename.s)
      Protected *Object.S_TextHtml= TextHtml_ID(ID)
      If *Object
        With *Object
          \sContent + "<img src="+Chr(34)+Filename+Chr(34)+">"
        EndWith
        ProcedureReturn #True
      Else
        ProcedureReturn #False
      EndIf
  EndProcedure
  ProcedureDLL HTML_AddNewLine(ID.l)
      Protected *Object.S_TextHtml= TextHtml_ID(ID)
      If *Object
        With *Object
          \sContent + "<br />"
        EndWith
        ProcedureReturn #True
      Else
        ProcedureReturn #False
      EndIf
  EndProcedure
  ProcedureDLL HTML_AddText(ID.l, Text.s, *Style.S_HTML_Style_Format = #Null)
      Protected *Object.S_TextHtml= TextHtml_ID(ID)
      If *Object
        With *Object
          If *Style <> #Null
            \sContent + "<span style="+Chr(34) + HTML_ReturnCSSFormat(*Style) + Chr(34)+">"+Text+"</span>"
          Else
            \sContent + Text
          EndIf
        EndWith
        ProcedureReturn #True
      Else
        ProcedureReturn #False
      EndIf
  EndProcedure
  ProcedureDLL HTML_AddHeader(ID.l, HeaderLevel.l, Text.s)
      Protected *Object.S_TextHtml= TextHtml_ID(ID)
      If *Object
        With *Object
          If HeaderLevel < 1 : HeaderLevel = 1 : EndIf
          If HeaderLevel > 1 : HeaderLevel = 6 : EndIf
          \sContent + "<h"+Str(HeaderLevel)+">"+Text+"</h"+Str(HeaderLevel)+">"
        EndWith
        ProcedureReturn #True
      Else
        ProcedureReturn #False
      EndIf
  EndProcedure
  