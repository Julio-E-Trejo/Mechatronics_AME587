;*******************************************************************************
;    Task Number: Task 07
;    Group Number: Group 03
;    Semester: Spring 2023
;    Instructor: 
;*******************************************************************************
  #include <p16f84a.inc> ; PIC Number
  
  cblock   0x0C ; Define Memory Bytes
  Apple
  Bits
  ByteD
  endc
  
  #define  BitA    Apple,0 ; Define Memory Bit
  #define  BitB    Apple,1 ; Define Memory Bit
  #define  BitC    Apple,2 ; Define Memory Bit
  #define  Direction	ByteD,0 ;Direction memory bit
  
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
  call     Initialization 
  goto     Main 
  org	   4h ; Interrupt memory location, MUST be included for using interrupts
  
  ISR
  call CheckDirection
  call Rotate
  clrf TMR0
  bcf INTCON,2
  retfie ; Return from Interrupt
  
  Main
  bcf INTCON,5 ;Turn off internal interrupt
  clrf PORTB ;all pins/LEDs should be off
  btfsc	PORTA,1 ;checks if button is pressed, 0 indicates pressed
  goto	$-1
  bcf STATUS,C ;Clear carry bit before running Interrupt to avoid Double LEDs
  
  ;Turn on internal interrupt & clear Timer0 and its flag
  bsf INTCON,5
  clrf TMR0
  bcf INTCON,2
  
  ;Turn on right-most LED
  bsf PORTB,0
  bcf Direction
  bcf STATUS,C
  btfss PORTA,1
  goto $-1
  goto Main
  
  CheckDirection
  btfsc PORTB,0 ;clears Direction if the 1 is on the far left bit
  bcf Direction
  btfsc PORTB,7 ;sets Direction if the 1 is on the far right bit
  bsf Direction
  return
  
  Rotate
  btfss Direction ;moves the 1 left if Direction == 0
  rlf PORTB
  btfsc Direction ;moves the 1 right if Direction == 1
  rrf  PORTB
  return
  
  Initialization
  BANK1
  bsf TRISA,1 ;PortA,1 = input
  clrf TRISB ;set all pins of PORTB as outputs
  bsf OPTION_REG,0
  bsf OPTION_REG,1
  bsf OPTION_REG,2
  bcf OPTION_REG,3
  bcf OPTION_REG,5
  BANK0
  bsf INTCON,7
  clrf PORTB ;all pins/LEDs should be off
  return
  
  end ; Finish Programing
