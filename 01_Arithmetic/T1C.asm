;*******************************************************************************
;    Task Number: Task 01-C
;    Group Number: Group 03
;    Semester:
;    Instructor:
;*******************************************************************************
  #include <p16f84a.inc> ; PIC Number
  
  cblock   0x0C ; Define Memory Bytes
  Apple
  ByteA
  ByteB
  Result
  
  endc
  
  #define  BitA    Apple,0 ; Define Memory Bit
  
  BANK0    macro
  bcf      STATUS,RP0
  bcf      STATUS,RP1
  endm
  BANK1    macro
  bsf      STATUS,RP0
  bcf      STATUS,RP1
  endm
  
  __CONFIG (_HS_OSC & _CP_OFF & _WDT_OFF & _PWRTE_ON) ; Configuration
  
  org      0h ; Start Programing
  
  
  Main
  movlw d'30'
  movwf ByteA
  
  movlw d'40'
  movwf ByteB
  
  call Subtraction
  nop
  
  goto $-1
  
  Subtraction
  bsf BitA
  movfw ByteB
  subwf ByteA,w
  movwf Result
  btfsc STATUS,C
  return
  bcf BitA
  comf Result,f
  incf Result,f
  return
  
  Initialization
  BANK1
  
  BANK0
  
  return
  
  end ; Finish Programing