;*******************************************************************************
;    Task Number: Task 00
;    Group Number: Group 00
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
  
  #define  BitA    ByteA,0 ; Define Memory Bit
  #define  BitB    ByteA,1 ; Define Memory Bit
  #define  BitC    ByteA,2 ; Define Memory Bit
  
  
  
  BANK0    macro
  bcf      STATUS,RP0
  bcf      STATUS,RP1
  endm
  BANK1    macro
  bsf      STATUS,RP0
  bcf      STATUS,RP1
  endm
  
  __CONFIG (_HS_OSC & _CP_OFF & _WDT_OFF & _PWRTE_ON) ; Configuration
  
  org      0h ; Start Programing, origin = location of program; must come first
  goto	   Main
  Main
  movlw d'5' ;Move value 25 into work register; w = 5
  movwf Apple
  
  movlw d'5'
  movwf ByteA
  movlw d'46'
  addwf ByteA,w
  movwf Result
  
  nop
  goto $-1
  
  end ; Finish Programing