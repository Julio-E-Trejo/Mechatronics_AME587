;*******************************************************************************
;    Task Number: Task 00
;    Group Number: Group 00
;    Semester:
;    Instructor:
;*******************************************************************************
  #include <p16f84a.inc> ; PIC Number
  
  cblock   0x0C ; Define Memory Bytes
  Multiplicand
  Multiplier
  Result
  endc
  
  
  
  
  __CONFIG (_HS_OSC & _CP_OFF & _WDT_OFF & _PWRTE_ON) ; Configuration
  
  org      0h ; Start Programing, origin = location of program; must come first
  
  Multiplication
  clrf Result
  movfw Multiplicand
  addwf Result,f
  decfsz Multiplier
  goto $-3
  return
  
  movlw d'5' 
  movwf Multiplicand
  
  movlw d'5'
  movwf Multiplier
  
  call Multiplication
  
  nop
  goto $-1
  
  end ; Finish Programing