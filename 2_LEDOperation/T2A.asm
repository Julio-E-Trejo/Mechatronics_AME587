;*******************************************************************************
;    Task Number: Task 02A
;    Group Number: Group 03
;    Semester:
;    Instructor:
;*******************************************************************************
  #include <p16f84a.inc> ; PIC Number
  
  cblock   0x0C ; Define Memory Bytes
  Apple
  ByteA
  ByteB
  
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
  
  org      0h ; Start Programing, origin = location of program; must come first
  call     Initialization ; For a defined function, returns after done
  goto     Main ; Goes to the specified location, and DOES NOT return

  
  Main
  movfw PORTA
  movwf PORTB
  goto     Main
  
  Initialization
  BANK1
  bsf TRISA,1
  bcf TRISB,1 ;set PORTB as output
  BANK0
  bsf PORTB,1 ;turn off LED 1
  
  return
  
  end ; Finish Programing
