Macro M_IsDigit(c)
  ((c >= '0') And (c <= '9'))
EndMacro 
;@author Dr. Dri
;@desc Permits to know if a string is a numeric
;@return #True if it's a numeric, else #False
ProcedureDLL.l IsNumeric(String.s)
  Protected Numeric.l, *String.Character
  If String
    String = Trim(String)
    If Left(String, 1) = "-"
      String =  Right(String, Len(String) -1)
    EndIf
    Numeric = #True
    *String = @String
    While Numeric And *String\c
      Numeric = M_IsDigit(*String\c)
      *String + SizeOf(Character)
    Wend
  EndIf
  ProcedureReturn Numeric
EndProcedure
