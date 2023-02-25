;*******************************************************************************
;    Task Number: Task 06
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

  Main
  clrf PORTB ;all pins/LEDs should be off
  btfsc	PORTA,1 ;checks if button is pressed, 0 indicates pressed
  goto	$-1
  bsf PORTB,0
  bcf Direction
  bcf STATUS,C
  goto Loop
  
  Loop
  call Delay
  call CheckDirection
  call Rotate
  btfss	PORTA,1 ;checks if button is pressed, 0 indicates pressed
  goto Loop
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
  
  Delay
  clrf TMR0 ;Clearing TMR0
  bcf INTCON,2 ;Clearing TMR0 flag
  btfss INTCON,2 ;Checking if TMR0 has overflown, 1 if overflow
  goto $-1
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
  clrf PORTB ;all pins/LEDs should be off
  return
  
  end ; Finish Programing