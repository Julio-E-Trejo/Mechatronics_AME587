//    Filename: TASK15
//    Instructor:
//    Group: 3
//    Date:3/6/2023

#include <xc.h>
#include <math.h>
#include <pic16f690.h>

#define _XTAL_FREQ 8000000

#pragma config FOSC = INTRCIO, WDTE = OFF, PWRTE = OFF, MCLRE = ON, CP = OFF, CPD = OFF, BOREN = OFF, IESO = OFF, FCMEN = OFF

// forward declarations of functions
void Send(unsigned char x);
unsigned char Receive(void);
int Initialization(void);

void main(void)  // Start of the main function
{
    Initialization();
    PORTC = 0;
    while (1) {
        __delay_us(20);
        GO = 1;                     // Begin AD Conversion
        while(GO);          // Wait for ADC to complete
        Send(ADRESL);                  // Send ADRESL to MATLAB via RS232
        Send(ADRESH);                  // Send ADRESH to MATLAB via RS232
        PORTC = Receive();  // Display result on LEDs
    }
    
}  // End of the main function

void Send(unsigned char x)            // Send 1 Byte to MATLAB via RS232
{
    TXREG = x;                      // Move Byte to Transmit Data Register
    SPEN = 1;                       // Enable Continuous Send (RCSTA reg)
    while (!TRMT);           // Wait until TXREG is empty (TXSTA reg)
} 

unsigned char Receive(void)                   // Receive 1 Byte from MATLAB via RS232
{
    CREN = 1;                       // Enable Asynchronous Receiver (RCSTA reg)
    while (!RCIF);           // Wait for RCREG to fill (PIR1 reg)
    return RCREG;
} 


int Initialization()
{
    // BANK2
    ANSEL  = 0b00000001;            // All pins digital except pin AN0
    ANSELH = 0b00000000;            // All pins digital
    
    // BANK1
    OSCCON = 0b01110000;            // Setting Oscillator to do 8MHz
    ADCON1 = 0b01010000;            // Select ADC Clock to FOSC/16
    TRISA  = 0b00000001;            // Input: pin AN0
    TRISB  = 0b00100000;            // B5: input; B7: output
    TRISC  = 0b00000000;            // Output: all pins
    //TXSTA bits
    TRMT = 1;                       // Empty Transmit Shift register
    BRGH = 1;                       // set Baud Rate high
    SYNC = 0;                       // Asynchronous mode
    TXEN = 1;                       // Enable transmission
    BRG16 = 0;                      // Set Baud Rate Generator to 8bit. 1 for 16
    SPBRG = 25;                     // Set baud rate timer period
    
    // BANK0
    
    //ADCON0
    ADON = 1;                       // Enable ADC conversion
    
    //ADC to AN0
    CHS0 = 0;
    CHS1 = 0;
    CHS2 = 0;
    CHS3 = 0;
    ADFM = 1;                       // Right Justify ADRESH ADRESL
    
    return 0;
}