ProcedureDLL DocGen_ExportCHM(sPath.s)
  Protected lFileIDHTML.l
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
        lFileIDHTML = HTML_CreateFile(#PB_Any, sPath  + "Functions\"+ \sName + ".html")
        ; head 
        HTML_SetGenerator(lFileIDHTML, "PS_DocGen from PureStudio - RootsLabs")
        HTML_AddInternFile(lFileIDHTML, #HTML_Extern_CSS, psCSSforHTML)
        ; body
        HTML_AddHeader(lFileIDHTML, 1, \sName+"()")
        HTML_AddHeader(lFileIDHTML, 2, "Syntax")
          HTML_OpenParagraph(lFileIDHTML)
            HTML_OpenBlock(lFileIDHTML, @pFormatProcedureName)
              Debug \sParameterName
            HTML_CloseBlock(lFileIDHTML)
          HTML_CloseParagraph(lFileIDHTML)
        HTML_AddHeader(lFileIDHTML, 2, "Description")
        HTML_AddHeader(lFileIDHTML, 2, "Parameters")
        HTML_AddHeader(lFileIDHTML, 2, "Returned value")
        HTML_AddHeader(lFileIDHTML, 2, "Example")
        Debug \sName
        HTML_CloseFile(lFileIDHTML)
        lFileIDHTML = 0
      EndWith
    Next
  ;}
EndProcedure
