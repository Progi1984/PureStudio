ProcedureDLL DocGen_ExportCHM(sPath.s)
  Protected lFileIDHTML.l
  Protected psCSSforHTML.s

  psCSSforHTML = "h1 {font-family:arial; text-align:center; font-size: 1.1em; font-weight: bold;}" + #System_EOL
  psCSSforHTML + "" + #System_EOL
  
  CreateDirectory(sPath + "Functions")
  ;{ Export HTML > Procedure
    ForEach LL_ListProcedures()
      With LL_ListProcedures()
        lFileIDHTML = HTML_CreateFile(#PB_Any, sPath  + "Functions\"+ \sName + ".html")
        ; head 
        HTML_SetGenerator(lFileIDHTML, "PS_DocGen from PureStudio - RootsLabs")
        HTML_AddInternFile(lFileIDHTML, #HTML_Extern_CSS, 
        ; body
        HTML_AddHeader(lFileIDHTML, 1, \sName+"()")
        HTML_AddHeader(lFileIDHTML, 2, "Overview")
        HTML_AddHeader(lFileIDHTML, 2, "Author")
        Debug \sName
        HTML_CloseFile(lFileIDHTML)
        lFileIDHTML = 0
      EndWith
    Next
  ;}
EndProcedure
