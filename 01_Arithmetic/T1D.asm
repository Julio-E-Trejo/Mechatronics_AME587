;*******************************************************************************
;    Task Number: Task 01-D
;    Group Number: Group 03
;    Semester:
;    Instructor:
;*******************************************************************************
  #include <p16f84a.inc> ; PIC Number
  
  cblock   0x0C ; Define Memory Bytes
  Apple
  Quotient
  Divisor
  Remainder
  
  endc
  
  #define  BitA    Apple,0 ; Define Memory Bit
  #define  BitB    Apple,1 ; Define Memory Bit
  #define  BitC    Apple,2 ; Define Memory Bit
  
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
  call     Initialization
  goto     Main

  org      04h ; Start Interrupt Service Routine - ISR
  retfie ; Finish Interrupt Service Routine - ISR
  
  Main
  movlw d'34'
  movwf Remainder
  movlw d'6'
  movwf Divisor
  clrf Quotient
  call Division
  nop
  goto $-1
  
  Division
  movfw Divisor
  subwf Remainder,w
  btfss STATUS,C
  return
  movwf Remainder
  incf Quotient,f
  goto Division
  
  
  
  Initialization
  BANK1
  
  BANK0
  
  return
  
  end ; Finish Programing