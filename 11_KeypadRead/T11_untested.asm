;*******************************************************************************
;    Task Number: Task 00
;    Group Number: Group 00
;    Semester:
;    Instructor:
;*******************************************************************************
  #include <p16f690.inc> ; PIC Number
  
  cblock   0x20 ; Define Memory Bytes
  Apple
  ByteA
  Digit
  Save
  endc
  
  #define  BitA    Apple,0 ; Define Memory Bit
  #define  BitB    Apple,1 ; Define Memory Bit
  #define  BitC    Apple,2 ; Define Memory Bit

  BANK0    MACRO
  bcf      STATUS,RP0
  bcf      STATUS,RP1
  endm
  BANK1    MACRO
  bsf      STATUS,RP0
  bcf      STATUS,RP1
  endm
  BANK2    MACRO
  bcf      STATUS,RP0
  bsf      STATUS,RP1
  endm
  BANK3    MACRO
  bsf      STATUS,RP0
  bsf      STATUS,RP1
  endm
  
  __CONFIG (_INTRC_OSC_NOCLKOUT & _FOSC_INTRCIO & _WDTE_OFF & _PWRTE_ON & _MCLRE_OFF & _CP_OFF & _CPD_OFF & _BOR_OFF & _BOREN_OFF & _IESO_OFF & _FCMEN_OFF) ; Configuration
  
  org      0x00 ; Start Programing
  call     Initialization
  goto     Main
  
  Main
  call	KeypadColumn
  movfw	Digit
  call	GetCode
  movwf	PORTC
  goto  Main
  
  KeypadColumn
  ;Clear PORTA0 and set PORTA1 and PORTA2
  bcf PORTA,0
  bsf PORTA,1
  bsf PORTA,2
  ;Move 1 into Digit
  movlw d'1'
  movwf Digit
  ;Move PORTB to Save
  movfw PORTB
  movwf Save
  ;XOR wreg with b'11110000'
  xorwf b'11110000'
  btfss STATUS,Z ;Skip next line if Zero bit (Z) is 1
  goto	KeypadRow
  
  ;Clear PORTA1 and set PORTA0 and PORTA2
  bsf PORTA,0
  bcf PORTA,1
  bsf PORTA,2
  ;Increment Digit
  incf  Digit,f
  ;Move PORTB to Save
  movfw PORTB
  movwf Save
  ;XOR wreg with b'11110000'
  xorwf b'11110000'
  btfss STATUS,Z ;Skip next line if Zero bit (Z) is 1
  goto	KeypadRow
  
  ;Clear PORTA2 and set PORTA0 and PORTA1
  bsf PORTA,0
  bsf PORTA,1
  bcf PORTA,2
  ;Increment Digit
  incf  Digit,f
  ;Move PORTB to Save
  movfw PORTB
  movwf Save
  ;XOR wreg with b'11110000'
  xorwf b'11110000'
  btfss STATUS,Z ;Skip next line if Zero bit (Z) is 1
  goto	KeypadRow
  goto	KeypadColumn
  
  KeypadRow
  swapf Save,w
  xorwf b'00001110'
  btfsc STATUS,Z ;Skip next line if Zero bit (Z) is 0
  return
  
  movlw d'3'
  addwf Digit,f
  btfss WREG,1
  addwf Digit,f
  
  addwf Digit,f
  btfss WREG,2
  addwf Digit,f
  
  addwf Digit,f
  btfss WREG,3
  addwf Digit,f
  
  addwf Digit,f
  return
  
  GetCode
  addwf PCL,f
  ;      '-afedbgc'
  retlw b'01111010' ; 1
  retlw b'00100001' ; 2
  retlw b'00110000' ; 3
  retlw b'01011000' ; 4
  retlw b'00010100' ; 5
  retlw b'00000100' ; 6
  retlw b'00111010' ; 7
  retlw b'00000000' ; 8
  retlw b'00011000' ; 9
  retlw b'01100000' ; d
  retlw b'00000010' ; 0
  retlw b'00001001' ; P
  
  Initialization
  BANK2
  clrf     ANSEL
  clrf     ANSELH
  ;Turn on weak pull up for PORTB,4-7
  movlw	   b'11110000'
  movwf	   WPUB
  BANK1
  movlw    b'01110000' ; Setting Oscillator to do 8MHz
  movwf    OSCCON
  ;Set PORTA,0-2 as outputs
  bcf	   TRISA,0
  bcf	   TRISA,1
  bcf	   TRISA,2
  ;Set PORTB,4-7 as inputs
  bsf	   TRISB,4
  bsf	   TRISA,5
  bsf	   TRISA,6
  bsf	   TRISA,7
  ;Set PORTC as output
  clrf	   TRISC
  ;Turn on weak pull up main switch
  bcf	   OPTION_REG,7
  BANK0
  ;Initialize PORTA,0-2 (?)
  bsf	   PORTA,0
  bsf	   PORTA,1
  bsf	   PORTA,2
  movfw b'11111111'
  movwf PORTC ;turn off all LEDs
  
  return
  
  end ; Finish Programing