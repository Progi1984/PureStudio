ProcedureDLL DocGen_ExportCHM(sPath.s)
  Protected lFileIDHTML.l, lIncA.l
  Protected psCSSforHTML.s
  Protected pFormatProcedureName.S_HTML_Style_Format
  
  psCSSforHTML = "body [background:#FFFFDF;}" + #System_EOL
  psCSSforHTML + "h1 {font-family:arial; text-align:center; font-size: 1.1em; font-weight: bold;}" + #System_EOL
  psCSSforHTML + "h2 {font-family:arial; font-weight: bold; font-size: 0.8em;} " + #System_EOL
  psCSSforHTML + "" + #System_EOL
  
  pFormatProcedureName\sBackgroundColor = "#006666"
  pFormatProcedureName\lFontStyle = #PB_Font_Bold
  
  CreateDirectory(sPath + "Functions")
  ;{ Export HTML > Procedure
    ForEach LL_ListProcedures()
      With LL_ListProcedures()
        Debug "-----START"
        Debug \bIsC.b
        Debug \bIsDLL.b
        Debug \sProcedure.s
        Debug \sName.s
        Debug \sType.s
        Debug \sParameterName.s
        Debug \sParameterType.s
        Debug \sDescription.s
        Debug \ptrInclude.l
        Debug "-----END"
        lFileIDHTML = HTML_CreateFile(#PB_Any, sPath  + "Functions\"+ \sName + ".html")
        ; head 
        HTML_SetGenerator(lFileIDHTML, "PS_DocGen from PureStudio - RootsLabs")
        HTML_AddInternFile(lFileIDHTML, #HTML_Extern_CSS, psCSSforHTML)
        ; body
        HTML_AddHeader(lFileIDHTML, 1, \sName+"()")
        HTML_AddHeader(lFileIDHTML, 2, "Syntax")
        ;{ Syntax
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
        HTML_AddHeader(lFileIDHTML, 2, "Description")
        ;{ Description
          HTML_OpenParagraph(lFileIDHTML)
          HTML_CloseParagraph(lFileIDHTML)
        ;}
        HTML_AddHeader(lFileIDHTML, 2, "Parameters")
        ;{ Parameters
          HTML_OpenParagraph(lFileIDHTML)
            If \sParameterName > ""
              For lIncA = 0 To CountString(\sParameterName, "|")
                HTML_AddText(lFileIDHTML, StringField(\sParameterName, lIncA + 1, "|") + "." + StringField(\sParameterType, lIncA + 1, "|") + " : ")
                HTML_AddNewLine()
              Next
            Else
              HTML_AddText(lFileIDHTML, "Aucun")
            EndIf
          HTML_CloseParagraph(lFileIDHTML)
        ;}
        HTML_AddHeader(lFileIDHTML, 2, "Returned value")
        ;{ Returned Value
          HTML_OpenParagraph(lFileIDHTML)
          If \sType > ""
            HTML_AddText(lFileIDHTML, \sType)
          Else
            HTML_AddText(lFileIDHTML, "Long")
          EndIf
          HTML_CloseParagraph(lFileIDHTML)
        ;}
        HTML_AddHeader(lFileIDHTML, 2, "Example")
        ;{ Example
          HTML_OpenParagraph(lFileIDHTML)
          HTML_CloseParagraph(lFileIDHTML)
        ;}
        HTML_AddHeader(lFileIDHTML, 2, "Source")
        ;{ Source
          HTML_OpenParagraph(lFileIDHTML)
            HTML_AddText(lFileIDHTML, \sContent)
          HTML_CloseParagraph(lFileIDHTML)
        ;}
        HTML_CloseFile(lFileIDHTML)
        lFileIDHTML = 0
      EndWith
    Next
  ;}
EndProcedure
