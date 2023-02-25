;*******************************************************************************
;    Task Number: Task 10
;    Group Number: Group 03
;    Semester:
;    Instructor:
;*******************************************************************************
  #include <p16f690.inc> ; PIC Number
  
  cblock   0x20 ; Define Memory Bytes
  Apple
  ByteA
  Quotient
  Divisor
  Remainder
  
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
  bsf ADCON0,1 ;Start ADC conversion
  btfsc ADCON0,1 ;Wait until conversion finishes
  goto $-1
  movfw ADRESH ;Move the conversion result to the work register to be read into the LEDs
  movwf Remainder
  movlw d'100'
  movwf Divisor
  clrf Quotient
  call Division
  movfw Quotient
  call GetCode
  movwf PORTC
  bsf PORTB,4
  bcf PORTB,5
  bcf PORTB,6
  call Delay
  
  movlw d'10'
  clrf Quotient
  movwf Divisor
  call Division
  movfw Quotient
  call GetCode
  movwf PORTC
  bcf PORTB,4
  bsf PORTB,5
  bcf PORTB,6
  call Delay
  
  movfw Remainder
  call GetCode
  movwf PORTC
  bcf PORTB,4
  bcf PORTB,5
  bsf PORTB,6
  call Delay
  goto     Main
  
  Delay
  ;751 us ==> A = 249
  movlw d'249'
  movwf ByteA
  
  decfsz ByteA
  goto $-1
  
  return
  
  GetCode
  addwf PCL,f
  ;      '-afedbgc'
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
  
  Division
  movfw Divisor
  subwf Remainder,w
  btfss STATUS,C
  return
  movwf Remainder
  incf Quotient,f
  goto Division
  
  Initialization
  BANK2
  clrf     ANSEL
  clrf     ANSELH
  ;Define PORTA,0 as analog
  bsf ANSEL,0
;  bsf ANSELH,0
  BANK1
  movlw    b'01110000' ; Setting Oscillator to do 8MHz
  movwf    OSCCON
  ;Set ADCON1 for FOSC/16
  bsf ADCON1,6
  bcf ADCON1,5
  bsf ADCON1,4
  bsf TRISA,0 ;Set PORTA,0 as input
  ;Set PORTB,4-6 as outputs
  bcf TRISB,4
  bcf TRISB,5
  bcf TRISB,6
  clrf TRISC ;Set all PORTC pins as outputs
  BANK0
  bsf ADCON0,0 ;Enable ADC
  bcf ADCON0,1 ;Ensure no ongoing conversion
  ;Set PORTA,0 as input of convertor
  bcf ADCON0,2
  bcf ADCON0,3
  bcf ADCON0,4
  bcf ADCON0,5
  bcf ADCON0,7 ;Set left justified for ADC conversion
  movfw b'11111111'
  movwf PORTC ;turn off all LEDs
  return
  
  end ; Finish Programing