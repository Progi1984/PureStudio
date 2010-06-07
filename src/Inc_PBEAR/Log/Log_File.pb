;{ Object Management
  ; Structures
  Structure S_LogFile
    lDefaultLevel.l
    sDefaultCategory.s
    sDefaultFormatter.s
    sOutputFile.s
    lOutputFileAppend.l
    lFilterActivateLevel.l
    lFilterOperatorLevel.l
    lFilterContentLevel.l
    lFilterActivateDate.l
    lFilterOperatorDate.l
    lFilterContentDate.l
    lFilterActivateCategory.l
    lFilterOperatorCategory .l
    sFilterContentCategory.s
  EndStructure
  Structure S_LogFile_Log
    ptrIDLog.l
    lLevel.l
    lDate.l
    sContent.s
    sCategory.s
  EndStructure
  ; Macros
  Macro LogFile_ID(object)
    Object_GetObject(Objects_LogFile, object)
  EndMacro
  Macro LogFile_IS(object)
    Object_IsObject(Objects_LogFile, object)
  EndMacro
  Macro LogFile_NEW(object)
    Object_GetOrAllocateID(Objects_LogFile, object)
  EndMacro
  Macro LogFile_FREEID(object)
    If object <> #PB_Any And LogFile_IS(object) = #True
      Object_FreeID(Objects_LogFile, object)
    EndIf
  EndMacro
  Macro LogFile_INIT(PtrCloseFn)
    Object_Init(SizeOf(S_LogFile), 1, PtrCloseFn)
  EndMacro
  ; Initialization object
  If Defined(Objects_LogFile, #PB_Variable) = #False
    Declare.l LogFile_Free(ID.l)
    Global Objects_LogFile.l
    Objects_LogFile = LogFile_INIT(@LogFile_Free())
    Global NewList LL_LogFile_Logs.S_LogFile_Log()
  EndIf
;}

  Enumeration 1
    #LogFile_Level_Debug
    #LogFile_Level_Info
    #LogFile_Level_Notice
    #LogFile_Level_Warn
    #LogFile_Level_Error
    #LogFile_Level_Critical
    #LogFile_Level_Alert
    #LogFile_Level_Emergency
  EndEnumeration
  Enumeration 1
    #LogFile_Filter_Level
    #LogFile_Filter_Date
    #LogFile_Filter_Category
  EndEnumeration
  Enumeration 1
    #LogFile_Operator_Inferior
    #LogFile_Operator_InferiorOrEqual
    #LogFile_Operator_Superior
    #LogFile_Operator_SuperiorOrEqual
    #LogFile_Operator_Equal
    #LogFile_Operator_NotEqual
  EndEnumeration
  
  ; Private
  Procedure.l LogFile_WriteLineLog(*RObject.S_LogFile, lFileID.l, *Item.S_LogFile_Log)
    Protected bFilterOk.b
    Protected sContent.s
    If *RObject
      With *RObject
        bFilterOk = #True
        If \lFilterActivateLevel = #True
         If \lFilterOperatorLevel = #LogFile_Operator_Equal
            If *Item\lLevel =  \lFilterContentLevel  : bFilterOk = #True  : Else  : bFilterOk = #False : EndIf
          ElseIf \lFilterOperatorLevel = #LogFile_Operator_NotEqual
            If *Item\lLevel <> \lFilterContentLevel  : bFilterOk = #True  : Else  : bFilterOk = #False : EndIf
          ElseIf \lFilterOperatorLevel = #LogFile_Operator_Inferior
            If *Item\lLevel <  \lFilterContentLevel  : bFilterOk = #True  : Else  : bFilterOk = #False : EndIf
          ElseIf \lFilterOperatorLevel = #LogFile_Operator_InferiorOrEqual
            If *Item\lLevel <= \lFilterContentLevel  : bFilterOk = #True  : Else  : bFilterOk = #False : EndIf
          ElseIf \lFilterOperatorLevel = #LogFile_Operator_Superior
            If *Item\lLevel >  \lFilterContentLevel  : bFilterOk = #True  : Else  : bFilterOk = #False : EndIf
          ElseIf \lFilterOperatorLevel = #LogFile_Operator_SuperiorOrEqual
            If *Item\lLevel >= \lFilterContentLevel  : bFilterOk = #True  : Else  : bFilterOk = #False : EndIf
          EndIf
        EndIf
        If \lFilterActivateDate = #True And bFilterOk <> #False
          If \lFilterOperatorDate = #LogFile_Operator_Equal
            If *Item\lDate =  \lFilterContentDate  : bFilterOk = #True  : Else  : bFilterOk = #False : EndIf
          ElseIf \lFilterOperatorDate = #LogFile_Operator_NotEqual
            If *Item\lDate <> \lFilterContentDate  : bFilterOk = #True  : Else  : bFilterOk = #False : EndIf
          ElseIf \lFilterOperatorDate = #LogFile_Operator_Inferior
            If *Item\lDate <  \lFilterContentDate  : bFilterOk = #True  : Else  : bFilterOk = #False : EndIf
          ElseIf \lFilterOperatorDate = #LogFile_Operator_InferiorOrEqual
            If *Item\lDate <= \lFilterContentDate  : bFilterOk = #True  : Else  : bFilterOk = #False : EndIf
          ElseIf \lFilterOperatorDate = #LogFile_Operator_Superior
            If *Item\lDate >  \lFilterContentDate  : bFilterOk = #True  : Else  : bFilterOk = #False : EndIf
          ElseIf \lFilterOperatorDate = #LogFile_Operator_SuperiorOrEqual
            If *Item\lDate >= \lFilterContentDate  : bFilterOk = #True  : Else  : bFilterOk = #False : EndIf
          EndIf
        EndIf
        If \lFilterActivateCategory = #True And bFilterOk <> #False
          If \lFilterOperatorCategory = #LogFile_Operator_Equal
            If *Item\sCategory =  \sFilterContentCategory  : bFilterOk = #True  : Else  : bFilterOk = #False : EndIf
          ElseIf \lFilterOperatorCategory = #LogFile_Operator_NotEqual
            If *Item\sCategory <> \sFilterContentCategory  : bFilterOk = #True  : Else  : bFilterOk = #False : EndIf
          EndIf
        EndIf
        
        If bFilterOk = #True
          sContent = \sDefaultFormatter
          sContent = ReplaceString(sContent, "%yyyy", Str(Year(*Item\lDate)))
          sContent = ReplaceString(sContent, "%mm", Str(Month(*Item\lDate)))
          sContent = ReplaceString(sContent, "%dd", Str(Day(*Item\lDate)))
          sContent = ReplaceString(sContent, "%hh", Str(Month(*Item\lDate)))
          sContent = ReplaceString(sContent, "%ii", Str(Minute(*Item\lDate)))
          sContent = ReplaceString(sContent, "%ss", Str(Second(*Item\lDate)))
          sContent = ReplaceString(sContent, "%cat", *Item\sCategory)
          sContent = ReplaceString(sContent, "%level", Str(*Item\lLevel))
          sContent = ReplaceString(sContent, "%content", *Item\sContent)
          ; Tools
          sContent = ReplaceString(sContent, "%%",  "%")
          sContent = ReplaceString(sContent, "%n", Chr(10))
          sContent = ReplaceString(sContent, "%r", Chr(13))
          sContent = ReplaceString(sContent, "%t", Chr(9))
          sContent = ReplaceString(sContent, "%v", Chr(11))
          sContent = ReplaceString(sContent, "%f", Chr(12))
          WriteStringN(lFileID, sContent)
        EndIf
      EndWith
      ProcedureReturn #True
    Else
      ProcedureReturn #False
    EndIf
  EndProcedure
  ; Public
  ProcedureDLL LogFile_Create(ID.l)
    Protected *RObject.S_LogFile = LogFile_NEW(ID)
    If *RObject
      With *RObject
        \lDefaultLevel          = #LogFile_Level_Debug
        \sDefaultCategory   = "Main"
        \sDefaultFormatter = "[%yyyy.%mm.%dd %hh:%ii:%ss] (%cat) - %level - %content"
        \sOutputFile             = GetCurrentDirectory() + "LogFile_Debug.txt"
        \lOutputFileAppend  = #True
      EndWith    
      ProcedureReturn *RObject
    Else
      ProcedureReturn #False
    EndIf
  EndProcedure
  ProcedureDLL LogFile_IsLog(ID.l)
    ProcedureReturn LogFile_IS(ID)
  EndProcedure
  ProcedureDLL.l LogFile_Free(ID.l)
    Protected *Object.S_LogFile
    ; Releasing object
    If *Object
      LogFile_FREEID(ID)
    EndIf
    ProcedureReturn #True
  EndProcedure
  ProcedureDLL.l LogFile_AddLog(ID.l, sContent.s, sCategory.s = "", lLevel.l = -1)
    Protected *RObject.S_LogFile = LogFile_ID(ID)
    Protected lFileID.l
    If *RObject
      With *RObject
        LastElement(LL_LogFile_Logs())
        AddElement(LL_LogFile_Logs())
        LL_LogFile_Logs()\ptrIDLog = ID
        If lLevel = -1
          LL_LogFile_Logs()\lLevel    = \lDefaultLevel
        Else
          LL_LogFile_Logs()\lLevel    = lLevel
        EndIf
        LL_LogFile_Logs()\lDate = Date()
        LL_LogFile_Logs()\sContent = sContent
        If sCategory = ""
          LL_LogFile_Logs()\sCategory = \sDefaultCategory
        Else
          LL_LogFile_Logs()\sCategory = sCategory
        EndIf
        If \lOutputFileAppend = #True
          lFileID = OpenFile(#PB_Any, \sOutputFile)
          If lFileID
            FileSeek(lFileID, Lof(lFileID))
            LogFile_WriteLineLog(*RObject, lFileID, @LL_LogFile_Logs())
            CloseFile(lFileID)
          EndIf
        EndIf
      EndWith
      ProcedureReturn #True
    Else
      ProcedureReturn #False
    EndIf
  EndProcedure
  ProcedureDLL.l LogFile_ResetLog(ID.l)
    Protected *RObject.S_LogFile = LogFile_ID(ID)
    If *RObject
      With *RObject
        ForEach LL_LogFile_Logs()
          If LL_LogFile_Logs()\ptrIDLog = ID
            DeleteElement(LL_LogFile_Logs())
          EndIf
        Next
      EndWith
      ProcedureReturn #True
    Else
      ProcedureReturn #False
    EndIf
  EndProcedure
  ProcedureDLL.l LogFile_SetDefaultLevel(ID.l, lLevel.l)
    Protected *RObject.S_LogFile = LogFile_ID(ID)
    If *RObject
      With *RObject
        \lDefaultLevel = lLevel
      EndWith
      ProcedureReturn #True
    Else
      ProcedureReturn #False
    EndIf
  EndProcedure
  ProcedureDLL.l LogFile_GetDefaultLevel(ID.l)
    Protected *RObject.S_LogFile = LogFile_ID(ID)
    If *RObject
      With *RObject
        ProcedureReturn \lDefaultLevel
      EndWith
    Else
      ProcedureReturn #False
    EndIf
  EndProcedure
  ProcedureDLL.l LogFile_SetDefaultCategory(ID.l, sCategory.s)
    Protected *RObject.S_LogFile = LogFile_ID(ID)
    If *RObject
      With *RObject
        \sDefaultCategory = sCategory 
      EndWith
      ProcedureReturn #True
    Else
      ProcedureReturn #False
    EndIf
  EndProcedure
  ProcedureDLL.s LogFile_GetDefaultCategory(ID.l)
    Protected *RObject.S_LogFile = LogFile_ID(ID)
    If *RObject
      With *RObject
        ProcedureReturn \sDefaultCategory 
      EndWith
    Else
      ProcedureReturn ""
    EndIf
  EndProcedure
  ProcedureDLL.l LogFile_SetOutputFile(ID.l, sFilename.s)
    Protected *RObject.S_LogFile = LogFile_ID(ID)
    If *RObject
      With *RObject
        \sOutputFile =  sFilename
      EndWith
      ProcedureReturn #True
    Else
      ProcedureReturn #False
    EndIf
  EndProcedure
  ProcedureDLL.s LogFile_GetOutputFile(ID.l)
    Protected *RObject.S_LogFile = LogFile_ID(ID)
    If *RObject
      With *RObject
        ProcedureReturn \sOutputFile
      EndWith
    Else
      ProcedureReturn ""
    EndIf
  EndProcedure
  ProcedureDLL.l LogFile_SetMethod(ID.l, lAppend.l)
    Protected *RObject.S_LogFile = LogFile_ID(ID)
    If *RObject
      With *RObject
        If lAppend >= #True
          \lOutputFileAppend = #True
        Else
          \lOutputFileAppend = #False
        EndIf
      EndWith
      ProcedureReturn #True
    Else
      ProcedureReturn #False
    EndIf
  EndProcedure
  ProcedureDLL.l LogFile_GetMethod(ID.l)
    Protected *RObject.S_LogFile = LogFile_ID(ID)
    If *RObject
      With *RObject
        ProcedureReturn \lOutputFileAppend
      EndWith
    Else
      ProcedureReturn #False
    EndIf
  EndProcedure
  ProcedureDLL.l LogFile_SetFormatter(ID.l, sFormatter.s)
    Protected *RObject.S_LogFile = LogFile_ID(ID)
    If *RObject
      With *RObject
        \sDefaultFormatter = sFormatter
      EndWith
      ProcedureReturn #True
    Else
      ProcedureReturn #False
    EndIf
  EndProcedure
  ProcedureDLL.s LogFile_GetFormatter(ID.l)
    Protected *RObject.S_LogFile = LogFile_ID(ID)
    If *RObject
      With *RObject
        ProcedureReturn \sDefaultFormatter 
      EndWith
    Else
      ProcedureReturn ""
    EndIf
  EndProcedure
  ProcedureDLL.l LogFile_AddFilter(ID.l, lType.l, lOperator.l, sContent.s)
    Protected *RObject.S_LogFile = LogFile_ID(ID)
    If *RObject
      With *RObject
        Select lType
          Case #LogFile_Filter_Level
            \lFilterActivateLevel    = #True
            \lFilterOperatorLevel    = Operator
            \lFilterContentLevel     = Val(sContent)
          Case #LogFile_Filter_Date
            \lFilterActivateDate     = #True
            \lFilterOperatorDate     = Operator
            \lFilterContentDate      = Val(sContent)
          Case #LogFile_Filter_Category
            \lFilterActivateCategory = #True
            \lFilterOperatorCategory = Operator
            \sFilterContentCategory  = sContent
        EndSelect
      EndWith
      ProcedureReturn #True
    Else
      ProcedureReturn #False
    EndIf
  EndProcedure
  ProcedureDLL.l LogFile_ResetFilter(ID.l)
    Protected *RObject.S_LogFile = LogFile_ID(ID)
    If *RObject
      With *RObject
        \lFilterActivateLevel    = #False
        \lFilterOperatorLevel    = 0
        \lFilterContentLevel     = 0
        \lFilterActivateLevel    = #False
        \lFilterOperatorDate     = 0
        \lFilterContentDate      = 0
        \lFilterActivateLevel    = #False
        \lFilterOperatorCategory = 0
        \sFilterContentCategory  = ""
      EndWith
      ProcedureReturn #True
    Else
      ProcedureReturn #False
    EndIf
  EndProcedure
  ProcedureDLL.l LogFile_Save(ID.l)
    Protected *RObject.S_LogFile = LogFile_ID(ID)
    Protected lFileID.l
    If *RObject
      With *RObject
        lFileID = CreateFile(#PB_Any, \sOutputFile)
        If lFileID
          ForEach LL_LogFile_Logs()
            If LL_LogFile_Logs()\ptrIDLog = ID
              LogFile_WriteLineLog(*RObject, lFileID, @LL_LogFile_Logs())
            EndIf
          Next
          CloseFile(lFileID)
          ProcedureReturn #True
        Else
          ProcedureReturn #False
        EndIf
      EndWith
    Else
      ProcedureReturn #False
    EndIf
  EndProcedure
