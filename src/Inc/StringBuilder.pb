;-Structure
Structure S_StringBuilder
  pString.l
  StringSize.l
  MemSize.l
  BlockSize.l
  InitDone.l
  ; Initialized to 0 (FALSE) at creation.  Means by default
  ; we have not initialized the structure/class.
EndStructure 
  
;@author Xombie
;@url http://www.purebasic.fr/english/viewtopic.php?t=13015
ProcedureDLL.l sbCreate(BlockSize.l)
  Protected *sbClass.S_StringBuilder
  *sbClass = AllocateMemory(SizeOf(S_StringBuilder))
  If *sbClass\InitDone
    If *sbClass\pString
      FreeMemory(*sbClass\pString)
    EndIf
  EndIf
  ; If the stringbuilder is already initialized, free the memory of the string.
  ; BlockSize min. 1024 ($400) Byte
  If BlockSize < $400
    BlockSize = $400
  EndIf
  ; BlockSize max. 1 MByte ($100000) Byte
  If BlockSize > $100000
    BlockSize = $100000
  EndIf
  If BlockSize <> (BlockSize & $FC00)
    BlockSize = (BlockSize & $FC00) + 1024
  EndIf
  *sbClass\BlockSize = BlockSize
  *sbClass\StringSize = 0
  If BlockSize > 0
    *sbClass\pString = AllocateMemory(BlockSize)
  EndIf
  ; Allocate the memory needed for our string
  If *sbClass\pString <> 0
    ; Allocation went fine, let the structure know we initialized everything fine.
    *sbClass\InitDone = #True
    *sbClass\MemSize = *sbClass\BlockSize
    ; Set our memory size used to the size of the block.
  Else
    ; Problem with allocation - let it know we did not initialize
    *sbClass\InitDone = #False
    *sbClass\MemSize = 0
  EndIf
  ProcedureReturn *sbClass
  ; Return the pointer to our new stringbuilder class.
EndProcedure
;@author Xombie
;@url http://www.purebasic.fr/english/viewtopic.php?t=13015
ProcedureDLL sbClear(*inSBClass.S_StringBuilder)
  If *inSBClass\InitDone
    If *inSBClass\pString
      FreeMemory(*inSBClass\pString)
    EndIf
    *inSBClass\pString = 0
    *inSBClass\StringSize = 0
    *inSBClass\BlockSize = 0
    *inSBClass\InitDone = #False
    *inSBClass\MemSize = 0
  EndIf
EndProcedure
;@author Xombie
;@url http://www.purebasic.fr/english/viewtopic.php?t=13015
ProcedureDLL sbDestroy(*inSBClass.S_StringBuilder)
  If *inSBClass\InitDone
    If *inSBClass\pString
      FreeMemory(*inSBClass\pString)
    EndIf
    *inSBClass\pString = 0
    *inSBClass\StringSize = 0
    *inSBClass\BlockSize = 0
    *inSBClass\InitDone = #False
    *inSBClass\MemSize = 0
  EndIf
  If *inSBClass
    FreeMemory(*inSBClass)
  EndIf
EndProcedure
;@author Xombie
;@url http://www.purebasic.fr/english/viewtopic.php?t=13015
ProcedureDLL sbAdd(*inSBClass.S_StringBuilder, inString.l)
  Protected StrLen.l
  Protected pNewString.l
  Protected NewMemSize.l
  Protected NewStringSize.l
  StrLen = MemoryStringLength(inString)
  NewStringSize = StrLen + *inSBClass\StringSize
  If NewStringSize + 1 > *inSBClass\MemSize
    NewMemSize = *inSBClass\MemSize + *inSBClass\BlockSize
    pNewString = AllocateMemory(NewMemSize)
    If pNewString = 0
      ProcedureReturn #False
    EndIf
    CopyMemory(*inSBClass\pString, pNewString, *inSBClass\StringSize)
    If *inSBClass\pString
      FreeMemory(*inSBClass\pString)
    EndIf
    *inSBClass\pString = pNewString
    *inSBClass\MemSize = NewMemSize
  EndIf
  CopyMemory(inString, *inSBClass\pString + *inSBClass\StringSize, StrLen)
  *inSBClass\StringSize = NewStringSize
EndProcedure
;@author Xombie
;@url http://www.purebasic.fr/english/viewtopic.php?t=13015
ProcedureDLL sbAddLiteral(*inSBClass.S_StringBuilder, inString.s)
  Protected sAddress.l, StrLen.l, pNewString.l, NewMemSize.l, NewStringSize.l
  sAddress = @inString
  StrLen = MemoryStringLength(sAddress)
  NewStringSize = StrLen + *inSBClass\StringSize
  If (NewStringSize + 1) > *inSBClass\MemSize
    NewMemSize = *inSBClass\MemSize + *inSBClass\BlockSize
    pNewString = AllocateMemory(NewMemSize)
    If pNewString = 0
      ProcedureReturn #False
    EndIf
    CopyMemory(*inSBClass\pString, pNewString, *inSBClass\StringSize)
    If *inSBClass\pString
      FreeMemory(*inSBClass\pString)
    EndIf
    *inSBClass\pString = pNewString
    *inSBClass\MemSize = NewMemSize
  EndIf
  CopyMemory(sAddress, *inSBClass\pString + *inSBClass\StringSize, StrLen)
  *inSBClass\StringSize = NewStringSize
EndProcedure
;@author Xombie
;@url http://www.purebasic.fr/english/viewtopic.php?t=13015
ProcedureDLL.s sbGetString(*inSBClass.S_StringBuilder)
  Protected WholeString.s = PeekS(*inSBClass\pString)
  ProcedureReturn WholeString
EndProcedure
;@author Xombie
;@url http://www.purebasic.fr/english/viewtopic.php?t=13015
ProcedureDLL.s sbGetStringAndDestroy(*inSBClass.S_StringBuilder)
  Protected WholeString.s = PeekS(*inSBClass\pString)
  sbDestroy(*inSBClass)
  ProcedureReturn WholeString
EndProcedure
;@author Xombie
;@url http://www.purebasic.fr/english/viewtopic.php?t=13015
ProcedureDLL.l sbLength(*inSBClass.S_StringBuilder)
  Protected iLength.l
  iLength = *inSBClass\StringSize
  ProcedureReturn iLength
EndProcedure 
