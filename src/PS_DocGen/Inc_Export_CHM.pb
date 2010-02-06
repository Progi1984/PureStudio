ProcedureDLL DocGen_ExportCHM(sPath.s)
  Protected lFileIDHTML.l, lIncA.l
  Protected psCSSforHTML.s, psContent.s
  Protected pFormatBody.S_HTML_Style_Format
  Protected pFormatP.S_HTML_Style_Format
  Protected pFormatParagraph.S_HTML_Style_Format
  Protected pFormatProcedureName.S_HTML_Style_Format
  
  pFormatBody\sFontFamily = "Arial"
  pFormatBody\sBackgroundColor = "#FFFFDF"
  
  pFormatProcedureName\sFontColor = "#006666"
  pFormatProcedureName\bFontStyleBold = #True
  
  pFormatP\sFontSize = "0.8em"
  pFormatP\sFontFamily = "Arial"
  
  psCSSforHTML = "body {"+HTML_ReturnCSSFormat(@pFormatBody)+"}" + #System_EOL
  psCSSforHTML + "h1 {font-family:arial; text-align:center; font-size: 1.1em; font-weight: bold;}" + #System_EOL
  psCSSforHTML + "h2 {font-family:arial; font-weight: bold; font-size: 0.8em;} " + #System_EOL
  psCSSforHTML + "a {font-family:Arial; color:#009999;}" + #System_EOL
  psCSSforHTML + "p {"+HTML_ReturnCSSFormat(@pFormatP)+"}" + #System_EOL
  ;psCSSforHTML + "" + #System_EOL
 
  
  ;{ Export HTML > All Procedures
    lFileIDHTML = HTML_CreateFile(#PB_Any, sPath  + "Functions.html")
      HTML_SetGenerator(lFileIDHTML, "PS_DocGen from PureStudio - RootsLabs")
      HTML_SetTitle(lFileIDHTML, "Functions")
      HTML_AddInternFile(lFileIDHTML, #HTML_Extern_CSS, psCSSforHTML)
      HTML_AddHeader(lFileIDHTML, 1, "Functions")
      HTML_AddHeader(lFileIDHTML, 2, "Command Index")
      HTML_OpenParagraph(lFileIDHTML)
        ForEach LL_ListProcedures()
          With LL_ListProcedures()
            HTML_AddText(lFileIDHTML, "<a href=" + #DQuote + "Functions/"+ \sName + ".html" + #DQuote + ">" + \sName + "</a>")
            HTML_AddNewLine(lFileIDHTML)
          EndWith
        Next
      HTML_CloseParagraph(lFileIDHTML)
    HTML_CloseFile(lFileIDHTML)
  ;}
  CreateDirectory(sPath + "Functions")
  ;{ Export HTML > Procedure
    ForEach LL_ListProcedures()
      With LL_ListProcedures()
        DocGen_ParserDoc(\sDescription, @LL_ListProcedures()\ptrDoc)
        lFileIDHTML = HTML_CreateFile(#PB_Any, sPath  + "Functions" + #System_Separator + \sName + ".html")
        ; head 
        HTML_SetGenerator(lFileIDHTML, "PS_DocGen from PureStudio - RootsLabs")
        HTML_SetTitle(lFileIDHTML, \sName+"()")
        HTML_AddInternFile(lFileIDHTML, #HTML_Extern_CSS, psCSSforHTML)
        ; body
        HTML_AddHeader(lFileIDHTML, 1, \sName+"()")
        ;{ Syntax
          HTML_AddHeader(lFileIDHTML, 2, "Syntax")
          HTML_OpenParagraph(lFileIDHTML)
            HTML_OpenBlock(lFileIDHTML, @pFormatProcedureName)
              HTML_AddText(lFileIDHTML, \sName)
            HTML_CloseBlock(lFileIDHTML)
            HTML_AddText(lFileIDHTML, "(")
            If \sParameterName > ""
              For lIncA = 0 To CountString(\sParameterName, "|")
                HTML_AddText(lFileIDHTML, StringField(\sParameterName, lIncA + 1, "|") + "." + StringField(\sParameterType, lIncA + 1, "|"))
              Next
            EndIf
            HTML_AddText(lFileIDHTML, ")")
          HTML_CloseParagraph(lFileIDHTML)
        ;}
        ;{ Description
          If \PtrDoc\sDescription > ""
            HTML_AddHeader(lFileIDHTML, 2, "Description")
            HTML_OpenParagraph(lFileIDHTML)
              HTML_AddText(lFileIDHTML, \PtrDoc\sDescription)
            HTML_CloseParagraph(lFileIDHTML)
          EndIf
        ;}
        ;{ Parameters
          If \sParameterName > ""
            HTML_AddHeader(lFileIDHTML, 2, "Parameters")
            HTML_OpenParagraph(lFileIDHTML)
            For lIncA = 0 To CountString(\sParameterName, "|")
              HTML_AddText(lFileIDHTML, StringField(\sParameterName, lIncA + 1, "|") + "." + StringField(\sParameterType, lIncA + 1, "|"))
              HTML_AddNewLine(lFileIDHTML)
            Next
            HTML_CloseParagraph(lFileIDHTML)
          EndIf
        ;}
        ;{ Returned Value
          HTML_AddHeader(lFileIDHTML, 2, "Returned value")
          HTML_OpenParagraph(lFileIDHTML)
          If \sType > ""
            HTML_AddText(lFileIDHTML, \sType)
          Else
            HTML_AddText(lFileIDHTML, "Long")
          EndIf
          HTML_CloseParagraph(lFileIDHTML)
        ;}
        ;{ Example
          If \ptrDoc\sSample > ""
            HTML_AddHeader(lFileIDHTML, 2, "Example")
            HTML_OpenParagraph(lFileIDHTML)
              HTML_AddText(lFileIDHTML, \ptrDoc\sSample)
            HTML_CloseParagraph(lFileIDHTML)
          EndIf
        ;}
        ;{ Source
          If \sContent > ""
            HTML_AddHeader(lFileIDHTML, 2, "Source")
            HTML_OpenParagraph(lFileIDHTML)
              psContent = ReplaceString(\sContent, Chr(13) + Chr(10), "<br />")
              psContent = ReplaceString(psContent, Chr(10), "<br />")
              HTML_AddText(lFileIDHTML, psContent)
            HTML_CloseParagraph(lFileIDHTML)
          EndIf
        ;}
        HTML_CloseFile(lFileIDHTML)
        lFileIDHTML = 0
      EndWith
    Next
  ;}
EndProcedure
