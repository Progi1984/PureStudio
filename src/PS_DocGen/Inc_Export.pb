ProcedureDLL DocGen_Export(lType.l)
  Select lType
    Case #ExportType_CHM              : DocGen_ExportCHM()
    Case #ExportType_DOC_97
    Case #ExportType_DOC_2003
    Case #ExportType_DocBook
    Case #ExportType_DOCX
    Case #ExportType_FrameMaker
    Case #ExportType_H1S
    Case #ExportType_HLP
    Case #ExportType_HSX
    Case #ExportType_HTB
    Case #ExportType_HTML
    Case #ExportType_HXS
    Case #ExportType_Latex
    Case #ExportType_ODT
    Case #ExportType_PDF
    Case #ExportType_PostScript
    Case #ExportType_RTF
    Case #ExportType_SGML
    Case #ExportType_SXW
    Case #ExportType_TexInfo
    Case #ExportType_Text
    Case #ExportType_XPS
    Case #ExportType_Troff
  EndSelect
EndProcedure