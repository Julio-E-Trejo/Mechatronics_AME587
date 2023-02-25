;*******************************************************************************
;    Task Number: Task 04
;    Group Number: Group 03
;    Semester:
;    Instructor:
;*******************************************************************************
  #include <p16f84a.inc> ; PIC Number
  
  cblock   0x0C ; Define Memory Bytes
  Apple
  ByteA
  
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
  
  org      0h 
  call     Initialization 
  goto     Main 

  Main
  btfsc	PORTA,1 ;checks if button is pressed, 0 indicates pressed
  goto	$-1
  btfss PORTA,1 ;checks if button is not pressed
  goto	$-1
  movfw ByteA
  movwf PORTB
  movlw d'15'
  subwf ByteA,w ;decrements ByteA by 15
  btfsc STATUS,Z ;skip next line if ByteA != 0
  clrf ByteA ;clears ByteA
  incf ByteA,f ;increments ByteA
  goto  Main
  
  Initialization
  BANK1
  bsf TRISA,1 ;PortA = input
  clrf TRISB ;set all pins of PORTB as outputs
  BANK0
  clrf PORTB ;all pins/LEDs should be off
  clrf ByteA
  return
  
  end ; Finish Programing
