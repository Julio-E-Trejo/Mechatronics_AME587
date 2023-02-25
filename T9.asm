;*******************************************************************************
;    Task Number: Task 09
;    Group Number: Group 03
;    Semester:
;    Instructor:
;*******************************************************************************
  #include <p16f690.inc> ; PIC Number
  
  cblock   0x20 ; Define Memory Bytes
  Apple
  Number
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
  
  org      04h ; Start Interrupt Service Routine - ISR
  
  ISR
  btfss PORTA,2 ;Wait til not pressed, 1 = not pressed
  goto $-1
  decf Number,f ;Decrement & save number
  btfss Number,7 ;Check if number is negative using 8th bit
  goto $+3
  movlw d'9' ;Reset Number to 9 if negative
  movwf Number
  movfw Number ;Move Number into the work register
  call GetCode ;
  movwf PORTC
  bcf INTCON,1
  retfie
  
  Main
  nop
  goto Main
  
  GetCode
  addwf PCL,f ;'-afedbgc'
  retlw b'00000010' ; 0
  retlw b'01111010' ; 1
  retlw b'00100001' ; 2
  retlw b'00110000' ; 3
  retlw b'01011000' ; 4
  retlw b'00010100' ; 5
  retlw b'00000100' ; 6
  retlw b'00111010' ; 7
  retlw b'00000000' ; 8
  retlw b'00011000' ; 9
  
  
  Initialization
  BANK2
  clrf     ANSEL
  clrf     ANSELH
  
  BANK1
  movlw    b'01110000' ; Setting Oscillator to do 8MHz
  movwf    OSCCON
  bsf TRISA,2
  clrf TRISC
  ;Pre-scaler rate
  bsf OPTION_REG,0
  bsf OPTION_REG,1
  bsf OPTION_REG,2
  ;TMR0 pre-scaler
  bcf OPTION_REG,3
  ;Internal oscillator
  bcf OPTION_REG,5
  ;External interrupt on falling edge of input
  bcf OPTION_REG,6
  BANK0
  bsf INTCON,7 ;turn on master interrupt switch0
  bsf INTCON,4 ;enable external interrupt
  bcf INTCON,1 ;clear external interrupt flag
  clrf PORTC
  movlw d'10'
  movwf Number
  return
  
  end ; Finish Programing