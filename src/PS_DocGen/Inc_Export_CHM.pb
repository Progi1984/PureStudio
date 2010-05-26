ProcedureDLL DocGen_ExportCHM(sPath.s)
  Protected lFileIDHTML.l, lIncA.l,plNbItems.l
  Protected psCSSforHTML.s, psContent.s
  Protected pFormatBody.S_HTML_Style_Format
  Protected pFormatP.S_HTML_Style_Format
  Protected pFormatProcedureName.S_HTML_Style_Format
  Protected pStyleCenter.S_HTML_Style_Paragraph
  Protected pStyleP.S_HTML_Style_Paragraph
  
  pFormatBody\sFontFamily = "Arial"
  pFormatBody\sBackgroundColor = "#FFFFDF"
  
  pFormatProcedureName\sFontColor = "#006666"
  pFormatProcedureName\bFontStyleBold = #True
  
  pFormatP\sFontSize = "12px"
  pFormatP\sFontFamily = "Arial"
  pStyleP\bMargin = #True
  pStyleP\S_Margin\sLeft = "20px"
  
  pStyleCenter\bAlignment = #HTML_Alignment_Center
  pStyleCenter\bMargin = #True
  pStyleCenter\S_Margin\sTop = "15px"
  
  psCSSforHTML = "body {"+HTML_ReturnCSSFormat(@pFormatBody)+"}" + #System_EOL
  psCSSforHTML + "h1 {font-family:arial; text-align:center; font-size: 1.1em; font-weight: bold;}" + #System_EOL
  psCSSforHTML + "h2 {font-family:arial; font-weight: bold; font-size: 0.8em;} " + #System_EOL
  psCSSforHTML + "a {font-family:Arial; color:#009999;}" + #System_EOL
  psCSSforHTML + "p, div {"+HTML_ReturnCSSFormat(@pFormatP)+HTML_ReturnCSSParagraph(@pStyleP)+"}" + #System_EOL
 
  ; Procedures
  ;- TODO : Procedures > Source : ajouter le nom, les paramètres et le type
  SortStructuredList(LL_ListProcedures(), #PB_Sort_Ascending|#PB_Sort_NoCase, OffsetOf(S_TypeProcedure\sName), #PB_Sort_String)
  ;{ Export HTML > All Procedures
    lFileIDHTML = HTML_CreateFile(#PB_Any, sPath  + "functions.html")
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
      HTML_OpenParagraph(lFileIDHTML, @pStyleCenter)
        HTML_AddText(lFileIDHTML, "<a href="+#DQuote+"index.html"+#DQuote+">Index</a>")
      HTML_CloseParagraph(lFileIDHTML)
    HTML_CloseFile(lFileIDHTML)
  ;}
  ;{ Export HTML > Procedure
    CreateDirectory(sPath + "Functions")
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
        ;{ Home
          HTML_OpenParagraph(lFileIDHTML, @pStyleCenter)
            HTML_AddText(lFileIDHTML, "<a href="+#DQuote+"../functions.html"+#DQuote+">Functions</a> - <a href="+#DQuote+"../index.html"+#DQuote+">Index</a>")
          HTML_CloseParagraph(lFileIDHTML)
        ;}
        HTML_CloseFile(lFileIDHTML)
        lFileIDHTML = 0
      EndWith
    Next
  ;}
  
  ; Constantes
  ;- TODO : Constants > Vérifier l'existence des constantes dans la LL
  ;- TODO : Constants > Ne pas prendre les constantes en PB_
  SortStructuredList(LL_ListConstants(),#PB_Sort_Ascending|#PB_Sort_NoCase, OffsetOf(S_TypeConstant\sName), #PB_Sort_String)
  ;{ Export HTML > All Constants
    lFileIDHTML = HTML_CreateFile(#PB_Any, sPath  + "constants.html")
      HTML_SetGenerator(lFileIDHTML, "PS_DocGen from PureStudio - RootsLabs")
      HTML_SetTitle(lFileIDHTML, "Constants")
      HTML_AddInternFile(lFileIDHTML, #HTML_Extern_CSS, psCSSforHTML)
      HTML_AddHeader(lFileIDHTML, 1, "Constants")
      HTML_AddHeader(lFileIDHTML, 2, "Constants Index")
      HTML_OpenParagraph(lFileIDHTML)
        ForEach LL_ListConstants()
          With LL_ListConstants()
            HTML_AddText(lFileIDHTML, "<a href=" + #DQuote + "Constants/"+ ReplaceString(\sName, "#", "") + ".html" + #DQuote + ">" + \sName + "</a>")
            HTML_AddNewLine(lFileIDHTML)
          EndWith
        Next
      HTML_CloseParagraph(lFileIDHTML)
      HTML_OpenParagraph(lFileIDHTML, @pStyleCenter)
        HTML_AddText(lFileIDHTML, "<a href="+#DQuote+"index.html"+#DQuote+">Index</a>")
      HTML_CloseParagraph(lFileIDHTML)
    HTML_CloseFile(lFileIDHTML)
  ;}
  ;{ Export HTML > Constant
    CreateDirectory(sPath + "Constants")
    ForEach LL_ListConstants()
      With LL_ListConstants()
        DocGen_ParserDoc(\sDescription, @LL_ListConstants()\ptrDoc)
        lFileIDHTML = HTML_CreateFile(#PB_Any, sPath  + "Constants"+ #System_Separator + ReplaceString(\sName, "#", "") + ".html")
        ; head 
        HTML_SetGenerator(lFileIDHTML, "PS_DocGen from PureStudio - RootsLabs")
        HTML_SetTitle(lFileIDHTML, \sName)
        HTML_AddInternFile(lFileIDHTML, #HTML_Extern_CSS, psCSSforHTML)
        ; body
        HTML_AddHeader(lFileIDHTML, 1, \sName)
        ;{ Name
          HTML_AddHeader(lFileIDHTML, 2, "Name")
          HTML_OpenParagraph(lFileIDHTML)
            HTML_OpenBlock(lFileIDHTML, @pFormatProcedureName)
              HTML_AddText(lFileIDHTML, \sName)
            HTML_CloseBlock(lFileIDHTML)
          HTML_CloseParagraph(lFileIDHTML)
        ;}
        ;{ Value
          HTML_AddHeader(lFileIDHTML, 2, "Value")
          HTML_OpenParagraph(lFileIDHTML)
            HTML_OpenBlock(lFileIDHTML)
              HTML_AddText(lFileIDHTML, \sValue)
            HTML_CloseBlock(lFileIDHTML)
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
        ;{ Home
          HTML_OpenParagraph(lFileIDHTML, @pStyleCenter)
            HTML_AddText(lFileIDHTML, "<a href="+#DQuote+"../constants.html"+#DQuote+">Constants</a> - <a href="+#DQuote+"../index.html"+#DQuote+">Index</a>")
          HTML_CloseParagraph(lFileIDHTML)
        ;}
        HTML_CloseFile(lFileIDHTML)
        lFileIDHTML = 0
      EndWith
    Next
  ;}

  ; Listes Chainées
  ;- TODO : LinkedLists > Pointer la structure de la LL vers la page web de la structure
  SortStructuredList(LL_ListLinkedLists(),#PB_Sort_Ascending|#PB_Sort_NoCase, OffsetOf(S_TypeLinkedList\sName), #PB_Sort_String)
  ;{ Export HTML > All LinkedLists
    lFileIDHTML = HTML_CreateFile(#PB_Any, sPath  + "linkedlists.html")
      HTML_SetGenerator(lFileIDHTML, "PS_DocGen from PureStudio - RootsLabs")
      HTML_SetTitle(lFileIDHTML, "LinkedLists")
      HTML_AddInternFile(lFileIDHTML, #HTML_Extern_CSS, psCSSforHTML)
      HTML_AddHeader(lFileIDHTML, 1, "LinkedLists")
      HTML_AddHeader(lFileIDHTML, 2, "LinkedLists Index")
      HTML_OpenParagraph(lFileIDHTML)
        ForEach LL_ListLinkedLists()
          With LL_ListLinkedLists()
            HTML_AddText(lFileIDHTML, "<a href=" + #DQuote + "LinkedLists/"+ StringField(\sName, 1, ".") + ".html" + #DQuote + ">" + \sName + "</a>")
            HTML_AddNewLine(lFileIDHTML)
          EndWith
        Next
      HTML_CloseParagraph(lFileIDHTML)
      HTML_OpenParagraph(lFileIDHTML, @pStyleCenter)
        HTML_AddText(lFileIDHTML, "<a href="+#DQuote+"index.html"+#DQuote+">Index</a>")
      HTML_CloseParagraph(lFileIDHTML)
    HTML_CloseFile(lFileIDHTML)
  ;}
  ;{ Export HTML > LinkedList
    CreateDirectory(sPath + "LinkedLists")
    ForEach LL_ListLinkedLists()
      With LL_ListLinkedLists()
        DocGen_ParserDoc(\sDescription, @LL_ListLinkedLists()\ptrDoc)
        lFileIDHTML = HTML_CreateFile(#PB_Any, sPath  + "LinkedLists"+ #System_Separator + StringField(\sName, 1, ".") + ".html")
        ; head 
        HTML_SetGenerator(lFileIDHTML, "PS_DocGen from PureStudio - RootsLabs")
        HTML_SetTitle(lFileIDHTML, \sName)
        HTML_AddInternFile(lFileIDHTML, #HTML_Extern_CSS, psCSSforHTML)
        ; body
        HTML_AddHeader(lFileIDHTML, 1, \sName)
        ;{ Syntax
          HTML_AddHeader(lFileIDHTML, 2, "Syntax")
          HTML_OpenParagraph(lFileIDHTML)
            HTML_OpenBlock(lFileIDHTML, @pFormatProcedureName)
              HTML_AddText(lFileIDHTML, \sName)
            HTML_CloseBlock(lFileIDHTML)
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
        ;{ Home
          HTML_OpenParagraph(lFileIDHTML, @pStyleCenter)
            HTML_AddText(lFileIDHTML, "<a href="+#DQuote+"../linkedlists.html"+#DQuote+">Linked Lists</a> - <a href="+#DQuote+"../index.html"+#DQuote+">Index</a>")
          HTML_CloseParagraph(lFileIDHTML)
        ;}
        HTML_CloseFile(lFileIDHTML)
        lFileIDHTML = 0
      EndWith
    Next
  ;}

  ; Tableaux
  ;- TODO : Arrays > Pointer la structure de la LL vers la page web de la structure
  ;- TODO : Arrays > Taille du tableau (si constante, donne la valeur et pointe vers la page web de la structure)
  SortStructuredList(LL_ListArrays(),#PB_Sort_Ascending|#PB_Sort_NoCase, OffsetOf(S_TypeArray\sName), #PB_Sort_String)
  ;{ Export HTML > All Arrays
    lFileIDHTML = HTML_CreateFile(#PB_Any, sPath  + "arrays.html")
      HTML_SetGenerator(lFileIDHTML, "PS_DocGen from PureStudio - RootsLabs")
      HTML_SetTitle(lFileIDHTML, "Arrays")
      HTML_AddInternFile(lFileIDHTML, #HTML_Extern_CSS, psCSSforHTML)
      HTML_AddHeader(lFileIDHTML, 1, "Arrays")
      HTML_AddHeader(lFileIDHTML, 2, "Arrays Index")
      HTML_OpenParagraph(lFileIDHTML)
        ForEach LL_ListArrays()
          With LL_ListArrays()
            HTML_AddText(lFileIDHTML, "<a href=" + #DQuote + "Arrays/"+ StringField(\sName, 1, ".") + ".html" + #DQuote + ">" + \sName + "</a>")
            HTML_AddNewLine(lFileIDHTML)
          EndWith
        Next
      HTML_CloseParagraph(lFileIDHTML)
      HTML_OpenParagraph(lFileIDHTML, @pStyleCenter)
        HTML_AddText(lFileIDHTML, "<a href="+#DQuote+"index.html"+#DQuote+">Index</a>")
      HTML_CloseParagraph(lFileIDHTML)
    HTML_CloseFile(lFileIDHTML)
  ;}
  ;{ Export HTML > Array
    CreateDirectory(sPath + "Arrays")
    ForEach LL_ListArrays()
      With LL_ListArrays()
        DocGen_ParserDoc(\sDescription, @LL_ListArrays()\ptrDoc)
        lFileIDHTML = HTML_CreateFile(#PB_Any, sPath  + "Arrays"+ #System_Separator + StringField(\sName, 1, ".") + ".html")
        ; head 
        HTML_SetGenerator(lFileIDHTML, "PS_DocGen from PureStudio - RootsLabs")
        HTML_SetTitle(lFileIDHTML, StringField(\sName, 1, "."))
        HTML_AddInternFile(lFileIDHTML, #HTML_Extern_CSS, psCSSforHTML)
        ; body
        HTML_AddHeader(lFileIDHTML, 1, StringField(\sName, 1, "."))
        ;{ Syntax
          HTML_AddHeader(lFileIDHTML, 2, "Syntax")
          HTML_OpenParagraph(lFileIDHTML)
            HTML_OpenBlock(lFileIDHTML, @pFormatProcedureName)
              HTML_AddText(lFileIDHTML, \sName)
            HTML_CloseBlock(lFileIDHTML)
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
        ;{ Home
          HTML_OpenParagraph(lFileIDHTML, @pStyleCenter)
            HTML_AddText(lFileIDHTML, "<a href="+#DQuote+"../arrays.html"+#DQuote+">Arrays</a> - <a href="+#DQuote+"../index.html"+#DQuote+">Index</a>")
          HTML_CloseParagraph(lFileIDHTML)
        ;}
        HTML_CloseFile(lFileIDHTML)
        lFileIDHTML = 0
      EndWith
    Next
  ;}

  ; Macros
  SortStructuredList(LL_ListMacros(),#PB_Sort_Ascending|#PB_Sort_NoCase, OffsetOf(S_TypeMacro\sName), #PB_Sort_String)
  ;{ Export HTML > All Macros
    lFileIDHTML = HTML_CreateFile(#PB_Any, sPath  + "macros.html")
      HTML_SetGenerator(lFileIDHTML, "PS_DocGen from PureStudio - RootsLabs")
      HTML_SetTitle(lFileIDHTML, "Macros")
      HTML_AddInternFile(lFileIDHTML, #HTML_Extern_CSS, psCSSforHTML)
      HTML_AddHeader(lFileIDHTML, 1, "Macros")
      HTML_AddHeader(lFileIDHTML, 2, "Macros Index")
      HTML_OpenParagraph(lFileIDHTML)
        ForEach LL_ListMacros()
          With LL_ListMacros()
            HTML_AddText(lFileIDHTML, "<a href=" + #DQuote + "Macros/"+ \sName + ".html" + #DQuote + ">" + \sName + "</a>")
            HTML_AddNewLine(lFileIDHTML)
          EndWith
        Next
      HTML_CloseParagraph(lFileIDHTML)
      HTML_OpenParagraph(lFileIDHTML, @pStyleCenter)
        HTML_AddText(lFileIDHTML, "<a href="+#DQuote+"index.html"+#DQuote+">Index</a>")
      HTML_CloseParagraph(lFileIDHTML)
    HTML_CloseFile(lFileIDHTML)
  ;}
  ;{ Export HTML > Macro
    CreateDirectory(sPath + "Macros")
    ForEach LL_ListMacros()
      With LL_ListMacros()
        DocGen_ParserDoc(\sDescription, @LL_ListMacros()\ptrDoc)
        lFileIDHTML = HTML_CreateFile(#PB_Any, sPath  + "Macros"+ #System_Separator + \sName + ".html")
        ; head 
        HTML_SetGenerator(lFileIDHTML, "PS_DocGen from PureStudio - RootsLabs")
        HTML_SetTitle(lFileIDHTML, \sName)
        HTML_AddInternFile(lFileIDHTML, #HTML_Extern_CSS, psCSSforHTML)
        ; body
        HTML_AddHeader(lFileIDHTML, 1, \sName)
        ;{ Syntax
          HTML_AddHeader(lFileIDHTML, 2, "Syntax")
          HTML_OpenParagraph(lFileIDHTML)
            HTML_OpenBlock(lFileIDHTML, @pFormatProcedureName)
              HTML_AddText(lFileIDHTML, \sName)
            HTML_CloseBlock(lFileIDHTML)
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
        ;{ Home
          HTML_OpenParagraph(lFileIDHTML, @pStyleCenter)
            HTML_AddText(lFileIDHTML, "<a href="+#DQuote+"../macros.html"+#DQuote+">Macros</a> - <a href="+#DQuote+"../index.html"+#DQuote+">Index</a>")
          HTML_CloseParagraph(lFileIDHTML)
        ;}
        HTML_CloseFile(lFileIDHTML)
        lFileIDHTML = 0
      EndWith
    Next
  ;}

  ; Enumerations
  ;{ Export HTML > All Enumerations
    lFileIDHTML = HTML_CreateFile(#PB_Any, sPath  + "enumerations.html")
      HTML_SetGenerator(lFileIDHTML, "PS_DocGen from PureStudio - RootsLabs")
      HTML_SetTitle(lFileIDHTML, "Enumerations")
      HTML_AddInternFile(lFileIDHTML, #HTML_Extern_CSS, psCSSforHTML)
      HTML_AddHeader(lFileIDHTML, 1, "Enumerations")
      HTML_AddHeader(lFileIDHTML, 2, "Enumerations Index")
      HTML_OpenParagraph(lFileIDHTML)
        ForEach LL_ListEnumerations()
          With LL_ListEnumerations()
            HTML_AddText(lFileIDHTML, "<a href=" + #DQuote + "Enumerations/Enum_"+ Str(ListIndex(LL_ListEnumerations())) + ".html" + #DQuote + ">Enumeration</a>")
            HTML_AddNewLine(lFileIDHTML)
          EndWith
        Next
      HTML_CloseParagraph(lFileIDHTML)
      HTML_OpenParagraph(lFileIDHTML, @pStyleCenter)
        HTML_AddText(lFileIDHTML, "<a href="+#DQuote+"index.html"+#DQuote+">Index</a>")
      HTML_CloseParagraph(lFileIDHTML)
    HTML_CloseFile(lFileIDHTML)
  ;}
  ;{ Export HTML > Enumeration
    CreateDirectory(sPath + "Enumerations")
    ForEach LL_ListEnumerations()
      With LL_ListEnumerations()
        DocGen_ParserDoc(\sDescription, @LL_ListEnumerations()\ptrDoc)
        lFileIDHTML = HTML_CreateFile(#PB_Any, sPath  + "Enumerations"+ #System_Separator + "Enum_"+ Str(ListIndex(LL_ListEnumerations())) + ".html")
        ; head 
        HTML_SetGenerator(lFileIDHTML, "PS_DocGen from PureStudio - RootsLabs")
        HTML_SetTitle(lFileIDHTML, "Enumeration")
        HTML_AddInternFile(lFileIDHTML, #HTML_Extern_CSS, psCSSforHTML)
        ; body
        HTML_AddHeader(lFileIDHTML, 1, "Enumeration")
        ;{ Content
          HTML_AddHeader(lFileIDHTML, 2, "Content")
          For lIncA = 0 To CountString(\sItem, "|")
            HTML_OpenParagraph(lFileIDHTML)
              ; Name
              HTML_AddText(lFileIDHTML, "Name : ")
              HTML_OpenBlock(lFileIDHTML, @pFormatProcedureName)
                HTML_AddText(lFileIDHTML, StringField(\sItem, lIncA + 1, "|"))
              HTML_CloseBlock(lFileIDHTML)
              HTML_AddNewLine(lFileIDHTML)
              ; Description
              If StringField(\sItemDescription, lIncA + 1, "|") > ""
                HTML_AddText(lFileIDHTML, "Description : ")
                HTML_OpenBlock(lFileIDHTML)
                  HTML_AddText(lFileIDHTML, StringField(\sItemDescription, lIncA + 1, "|"))
                HTML_CloseBlock(lFileIDHTML)
              EndIf
            HTML_CloseParagraph(lFileIDHTML)
          Next
        ;}
        ;{ Home
          HTML_OpenParagraph(lFileIDHTML, @pStyleCenter)
            HTML_AddText(lFileIDHTML, "<a href="+#DQuote+"../enumerations.html"+#DQuote+">Enumerations</a> - <a href="+#DQuote+"../index.html"+#DQuote+">Index</a>")
          HTML_CloseParagraph(lFileIDHTML)
        ;}
        HTML_CloseFile(lFileIDHTML)
        lFileIDHTML = 0
      EndWith
    Next
  ;}

  ; Structures
  ;- TODO : Structures > Pointer la structure de la LL vers la page web de la structure
  SortStructuredList(LL_ListStructures(),#PB_Sort_Ascending|#PB_Sort_NoCase, OffsetOf(S_TypeStructure\sName), #PB_Sort_String)
  ;{ Export HTML > All Structures
    lFileIDHTML = HTML_CreateFile(#PB_Any, sPath  + "structures.html")
      HTML_SetGenerator(lFileIDHTML, "PS_DocGen from PureStudio - RootsLabs")
      HTML_SetTitle(lFileIDHTML, "Structures")
      HTML_AddInternFile(lFileIDHTML, #HTML_Extern_CSS, psCSSforHTML)
      HTML_AddHeader(lFileIDHTML, 1, "Structures")
      HTML_AddHeader(lFileIDHTML, 2, "Structures Index")
      HTML_OpenParagraph(lFileIDHTML)
        ForEach LL_ListStructures()
          With LL_ListStructures()
            HTML_AddText(lFileIDHTML, "<a href=" + #DQuote + "Structures/"+ \sName + ".html" + #DQuote + ">" + \sName + "</a>")
            HTML_AddNewLine(lFileIDHTML)
          EndWith
        Next
      HTML_CloseParagraph(lFileIDHTML)
      HTML_OpenParagraph(lFileIDHTML, @pStyleCenter)
        HTML_AddText(lFileIDHTML, "<a href="+#DQuote+"index.html"+#DQuote+">Index</a>")
      HTML_CloseParagraph(lFileIDHTML)
    HTML_CloseFile(lFileIDHTML)
  ;}
  ;{ Export HTML > Structure
    CreateDirectory(sPath + "Structures")
    ForEach LL_ListStructures()
      With LL_ListStructures()
        DocGen_ParserDoc(\sDescription, @LL_ListStructures()\ptrDoc)
        lFileIDHTML = HTML_CreateFile(#PB_Any, sPath  + "Structures"+ #System_Separator + \sName + ".html")
        ; head 
        HTML_SetGenerator(lFileIDHTML, "PS_DocGen from PureStudio - RootsLabs")
        HTML_SetTitle(lFileIDHTML, \sName)
        HTML_AddInternFile(lFileIDHTML, #HTML_Extern_CSS, psCSSforHTML)
        ; body
        HTML_AddHeader(lFileIDHTML, 1, \sName)
        ;{ Syntax
          HTML_AddHeader(lFileIDHTML, 2, "Syntax")
          HTML_OpenParagraph(lFileIDHTML)
            HTML_OpenBlock(lFileIDHTML, @pFormatProcedureName)
              HTML_AddText(lFileIDHTML, \sName)
            HTML_CloseBlock(lFileIDHTML)
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
        ;{ Content
          HTML_AddHeader(lFileIDHTML, 2, "Content")
          For lIncA = 0 To CountString(\sField, "|")
            If LCase(StringField(\sField, lIncA + 1, "|")) = "structureunion"
              HTML_OpenSection(lFileIDHTML)
              HTML_AddText(lFileIDHTML, "StructureUnion")
            ElseIf LCase(StringField(\sField, lIncA + 1, "|")) = "endstructureunion"
              HTML_AddText(lFileIDHTML, "EndStructureUnion")
              HTML_CloseSection(lFileIDHTML)
            Else
              HTML_OpenParagraph(lFileIDHTML)
                ; Name
                HTML_AddText(lFileIDHTML, "Name : ")
                HTML_OpenBlock(lFileIDHTML, @pFormatProcedureName)
                  HTML_AddText(lFileIDHTML, StringField(\sField, lIncA + 1, "|"))
                HTML_CloseBlock(lFileIDHTML)
                HTML_AddNewLine(lFileIDHTML)
                ; Description
                If StringField(\sFieldDescription, lIncA + 1, "|") > ""
                  HTML_AddText(lFileIDHTML, "Description : ")
                  HTML_AddText(lFileIDHTML, StringField(\sFieldDescription, lIncA + 1, "|"))
                EndIf
              HTML_CloseParagraph(lFileIDHTML)
            EndIf
          Next
        ;}
        ;{ Home
          HTML_OpenParagraph(lFileIDHTML, @pStyleCenter)
            HTML_AddText(lFileIDHTML, "<a href="+#DQuote+"../structures.html"+#DQuote+">Structures</a> - <a href="+#DQuote+"../index.html"+#DQuote+">Index</a>")
          HTML_CloseParagraph(lFileIDHTML)
        ;}
        HTML_CloseFile(lFileIDHTML)
        lFileIDHTML = 0
      EndWith
    Next
  ;}

  ; IncludeFiles
  SortStructuredList(LL_IncludeFiles(),#PB_Sort_Ascending|#PB_Sort_NoCase, OffsetOf(S_FileInclude\sFilename), #PB_Sort_String)
  ;{ Export HTML > All IncludeFiles
    lFileIDHTML = HTML_CreateFile(#PB_Any, sPath  + "includefiles.html")
      HTML_SetGenerator(lFileIDHTML, "PS_DocGen from PureStudio - RootsLabs")
      HTML_SetTitle(lFileIDHTML, "IncludeFiles")
      HTML_AddInternFile(lFileIDHTML, #HTML_Extern_CSS, psCSSforHTML)
      HTML_AddHeader(lFileIDHTML, 1, "IncludeFiles")
      HTML_AddHeader(lFileIDHTML, 2, "IncludeFiles Index")
      HTML_OpenParagraph(lFileIDHTML)
        ForEach LL_IncludeFiles()
          With LL_IncludeFiles()
            If \sPath = ""
              HTML_AddText(lFileIDHTML, "<a href=" + #DQuote + "IncludeFiles/"+ \sFilename + ".html" + #DQuote + ">" + \sFilename + "</a>")
            Else
              HTML_AddText(lFileIDHTML, "<a href=" + #DQuote + "IncludeFiles/"+ \sPath + "_" + \sFilename + ".html" + #DQuote + ">" + \sPath + "/" + \sFilename + "</a>")
            EndIf
            HTML_AddNewLine(lFileIDHTML)
          EndWith
        Next
      HTML_CloseParagraph(lFileIDHTML)
      HTML_OpenParagraph(lFileIDHTML, @pStyleCenter)
        HTML_AddText(lFileIDHTML, "<a href="+#DQuote+"index.html"+#DQuote+">Index</a>")
      HTML_CloseParagraph(lFileIDHTML)
    HTML_CloseFile(lFileIDHTML)
  ;}
  ;{ Export HTML > IncludeFile
    CreateDirectory(sPath + "IncludeFiles")
    ForEach LL_IncludeFiles()
      With LL_IncludeFiles()
        If \sPath = ""
          psContent = \sFilename
        Else
          psContent = \sPath + "_" + \sFilename
        EndIf
        lFileIDHTML = HTML_CreateFile(#PB_Any, sPath  + "IncludeFiles"+ #System_Separator + psContent + ".html")
        ; head 
        HTML_SetGenerator(lFileIDHTML, "PS_DocGen from PureStudio - RootsLabs")
        HTML_SetTitle(lFileIDHTML, \sFileName)
        HTML_AddInternFile(lFileIDHTML, #HTML_Extern_CSS, psCSSforHTML)
        ; body
        HTML_AddHeader(lFileIDHTML, 1, \sFilename)
        ;{ Arrays
        HTML_AddHeader(lFileIDHTML, 2, "Arrays")
          HTML_OpenParagraph(lFileIDHTML)
            plNbItems =0
            ForEach LL_ListArrays()
              If LL_ListArrays()\ptrInclude = ListIndex(LL_IncludeFiles())
                HTML_AddText(lFileIDHTML, "<a href="+#DQuote + "../Arrays/"+StringField(LL_ListArrays()\sName, 1, ".")+".html"+#DQuote+">"+LL_ListArrays()\sName+"</a>")
                HTML_AddNewLine(lFileIDHTML)
                plNbItems + 1
              EndIf
            Next
            If plNbItems = 0
              HTML_AddText(lFileIDHTML, "None")
              HTML_AddNewLine(lFileIDHTML)
            EndIf
          HTML_CloseParagraph(lFileIDHTML)
        ;}
        ;{ Constants
        HTML_AddHeader(lFileIDHTML, 2, "Constants")
          HTML_OpenParagraph(lFileIDHTML)
            plNbItems =0
            ForEach LL_ListConstants()
              If LL_ListConstants()\ptrInclude = ListIndex(LL_IncludeFiles())
                HTML_AddText(lFileIDHTML, "<a href="+#DQuote + "../Constants/"+ReplaceString(LL_ListConstants()\sName, "#", "")+".html"+#DQuote+">"+LL_ListConstants()\sName+"</a>")
                HTML_AddNewLine(lFileIDHTML)
                plNbItems + 1
              EndIf
            Next
            If plNbItems = 0
              HTML_AddText(lFileIDHTML, "None")
              HTML_AddNewLine(lFileIDHTML)
            EndIf
          HTML_CloseParagraph(lFileIDHTML)
        ;}
        ;{ LinkedLists
        HTML_AddHeader(lFileIDHTML, 2, "LinkedLists")
          HTML_OpenParagraph(lFileIDHTML)
            plNbItems =0
            ForEach LL_ListLinkedLists()
              If LL_ListLinkedLists()\ptrInclude = ListIndex(LL_IncludeFiles())
                HTML_AddText(lFileIDHTML, "<a href="+#DQuote + "../LinkedLists/"+StringField(LL_ListLinkedLists()\sName, 1, ".")+".html"+#DQuote+">"+LL_ListLinkedLists()\sName+"</a>")
                HTML_AddNewLine(lFileIDHTML)
                plNbItems + 1
              EndIf
            Next
            If plNbItems = 0
              HTML_AddText(lFileIDHTML, "None")
              HTML_AddNewLine(lFileIDHTML)
            EndIf
          HTML_CloseParagraph(lFileIDHTML)
        ;}
        ;{ Macros
        HTML_AddHeader(lFileIDHTML, 2, "Macros")
          HTML_OpenParagraph(lFileIDHTML)
            plNbItems =0
            ForEach LL_ListMacros()
              If LL_ListMacros()\ptrInclude = ListIndex(LL_IncludeFiles())
                HTML_AddText(lFileIDHTML, "<a href="+#DQuote + "../Macros/"+LL_ListMacros()\sName+".html"+#DQuote+">"+LL_ListMacros()\sName+"</a>")
                HTML_AddNewLine(lFileIDHTML)
                plNbItems + 1
              EndIf
            Next
            If plNbItems = 0
              HTML_AddText(lFileIDHTML, "None")
              HTML_AddNewLine(lFileIDHTML)
            EndIf
          HTML_CloseParagraph(lFileIDHTML)
        ;}
        ;{ Procedures
        HTML_AddHeader(lFileIDHTML, 2, "Procedures")
          HTML_OpenParagraph(lFileIDHTML)
            plNbItems =0
            ForEach LL_ListProcedures()
              If LL_ListProcedures()\ptrInclude = ListIndex(LL_IncludeFiles())
                HTML_AddText(lFileIDHTML, "<a href="+#DQuote + "../Functions/"+LL_ListProcedures()\sName+".html"+#DQuote+">"+LL_ListProcedures()\sName+"()</a>")
                HTML_AddNewLine(lFileIDHTML)
                plNbItems + 1
              EndIf
            Next
            If plNbItems = 0
              HTML_AddText(lFileIDHTML, "None")
              HTML_AddNewLine(lFileIDHTML)
            EndIf
          HTML_CloseParagraph(lFileIDHTML)
        ;}
        ;{ Structures
        HTML_AddHeader(lFileIDHTML, 2, "Structures")
          HTML_OpenParagraph(lFileIDHTML)
            plNbItems =0
            ForEach LL_ListStructures()
              If LL_ListStructures()\ptrInclude = ListIndex(LL_IncludeFiles())
                HTML_AddText(lFileIDHTML, "<a href="+#DQuote + "../Structures/"+LL_ListStructures()\sName+".html"+#DQuote+">"+LL_ListStructures()\sName+"</a>")
                HTML_AddNewLine(lFileIDHTML)
                plNbItems + 1
              EndIf
            Next
            If plNbItems = 0
              HTML_AddText(lFileIDHTML, "None")
              HTML_AddNewLine(lFileIDHTML)
            EndIf
          HTML_CloseParagraph(lFileIDHTML)
        ;}
        ;{ Home
          HTML_OpenParagraph(lFileIDHTML, @pStyleCenter)
            HTML_AddText(lFileIDHTML, "<a href="+#DQuote+"../includefiles.html"+#DQuote+">Include Files</a> - <a href="+#DQuote+"../index.html"+#DQuote+">Index</a>")
          HTML_CloseParagraph(lFileIDHTML)
        ;}
        HTML_CloseFile(lFileIDHTML)
        lFileIDHTML = 0
      EndWith
    Next
  ;}

  ; INDEX
  ;{ Export HTML > Index
    lFileIDHTML = HTML_CreateFile(#PB_Any, sPath  + "index.html")
      HTML_SetGenerator(lFileIDHTML, "PS_DocGen from PureStudio - RootsLabs")
      HTML_SetTitle(lFileIDHTML, "Project")
      HTML_AddInternFile(lFileIDHTML, #HTML_Extern_CSS, psCSSforHTML)
      HTML_AddHeader(lFileIDHTML, 1, "Project")
      HTML_AddHeader(lFileIDHTML, 2, "Description")
      HTML_OpenParagraph(lFileIDHTML)
        HTML_AddText(lFileIDHTML, "Description of the project")
      HTML_CloseParagraph(lFileIDHTML)
      HTML_AddHeader(lFileIDHTML, 2, "Tables of Contents")
      HTML_OpenParagraph(lFileIDHTML)
        HTML_AddText(lFileIDHTML, "<a href=" + #DQuote + "arrays.html" + #DQuote + ">Arrays</a>")
        HTML_AddNewLine(lFileIDHTML)
        HTML_AddText(lFileIDHTML, "<a href=" + #DQuote + "constants.html" + #DQuote + ">Constants</a>")
        HTML_AddNewLine(lFileIDHTML)
        HTML_AddText(lFileIDHTML, "<a href=" + #DQuote + "enumerations.html" + #DQuote + ">Enumerations</a>")
        HTML_AddNewLine(lFileIDHTML)
        HTML_AddText(lFileIDHTML, "<a href=" + #DQuote + "includefiles.html" + #DQuote + ">Include Files</a>")
        HTML_AddNewLine(lFileIDHTML)
        HTML_AddText(lFileIDHTML, "<a href=" + #DQuote + "linkedlists.html" + #DQuote + ">LinkedLists</a>")
        HTML_AddNewLine(lFileIDHTML)
        HTML_AddText(lFileIDHTML, "<a href=" + #DQuote + "macros.html" + #DQuote + ">Macros</a>")
        HTML_AddNewLine(lFileIDHTML)
        HTML_AddText(lFileIDHTML, "<a href=" + #DQuote + "functions.html" + #DQuote + ">Procedures</a>")
        HTML_AddNewLine(lFileIDHTML)
        HTML_AddText(lFileIDHTML, "<a href=" + #DQuote + "structures.html" + #DQuote + ">Structures</a>")
      HTML_CloseParagraph(lFileIDHTML)
    HTML_CloseFile(lFileIDHTML)
  ;}
EndProcedure
