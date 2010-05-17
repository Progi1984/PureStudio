  ; Macros for double quotes
  Macro DQuote
    "
  EndMacro
  ; Define the ImportLib
  CompilerSelect #PB_Compiler_Thread
    CompilerCase #False ;{ THREADSAFE : OFF
      CompilerSelect #PB_Compiler_OS
        CompilerCase #PB_OS_Linux         : #Power_ObjectManagerLib = #PB_Compiler_Home + "compilers/objectmanager.a"
        CompilerCase #PB_OS_Windows   : #Power_ObjectManagerLib = "ObjectManager.lib"
      CompilerEndSelect
    ;}
    CompilerCase #True ;{ THREADSAFE : ON
      CompilerSelect #PB_Compiler_OS
        CompilerCase #PB_OS_Linux         : #Power_ObjectManagerLib = #PB_Compiler_Home + "compilers/objectmanagerthread.a"
        CompilerCase #PB_OS_Windows   : #Power_ObjectManagerLib = "ObjectManager.lib"
      CompilerEndSelect
    ;}
  CompilerEndSelect
  ; Macro ImportFunction
  CompilerSelect #PB_Compiler_OS
    CompilerCase #PB_OS_Linux ;{
      Macro ImportFunction(Name, Param)
        DQuote#Name#DQuote
      EndMacro
    ;}
    CompilerCase #PB_OS_Windows ;{
      Macro ImportFunction(Name, Param)
        DQuote _#Name@Param#DQuote
      EndMacro
    ;}
  CompilerEndSelect
  ; Import the ObjectManager library
  ImportC #Power_ObjectManagerLib
    Object_GetOrAllocateID(Objects, Object.l) As ImportFunction(PB_Object_GetOrAllocateID, 8)
    Object_GetObject(Objects, Object.l) As ImportFunction(PB_Object_GetObject,8)
    Object_IsObject(Objects, Object.l) As ImportFunction(PB_Object_IsObject,8)
    Object_EnumerateAll(Objects, ObjectEnumerateAllCallback, *VoidData) As ImportFunction(PB_Object_EnumerateAll,12)
    Object_EnumerateStart(Objects) As ImportFunction(PB_Object_EnumerateStart,4)
    Object_EnumerateNext(Objects, *object.Long) As ImportFunction(PB_Object_EnumerateNext,8)
    Object_EnumerateAbort(Objects) As ImportFunction(PB_Object_EnumerateAbort,4)
    Object_FreeID(Objects, Object.l) As ImportFunction(PB_Object_FreeID,8)
    Object_Init(StructureSize.l, IncrementStep.l, ObjectFreeFunction) As ImportFunction(PB_Object_Init,12)
    Object_GetThreadMemory(MemoryID.l) As ImportFunction(PB_Object_GetThreadMemory,4)
    Object_InitThreadMemory(Size.l, InitFunction, EndFunction) As ImportFunction(PB_Object_InitThreadMemory,12)
  EndImport
