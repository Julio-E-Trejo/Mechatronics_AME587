//    Filename: TASK11
//    Instructor:
//    Group: 3
//    Date: 2/24/2023

#include <xc.h>     // header file
#include <math.h>   // header file
#include <stdio.h>
#include <pic16f690.h>

#pragma config FOSC = INTRCIO, WDTE = OFF, PWRTE = OFF, MCLRE = ON, CP = OFF, CPD = OFF, BOREN = OFF, IESO = OFF, FCMEN = OFF

unsigned int Digit;
//unsigned int Save;
unsigned int SaveDigit;

//Function Declarations
void Initialization();
char Keypad();
char KeypadRow();
char GetCode();

int main()  // Start of the main function
{
    Initialization();            // Call Initialization
    
    while(1){
        while(!Keypad());
        PORTC = GetCode();
    }
}

//Used to cycle through rows in the keypad
//Used to generate the actual number input
char Keypad()  //Determines keypad input
{
//    RA0 = 0; RA1 = 1; RA2 = 1;
    PORTA = 0b00000110;
    Digit = 1;
//    Save = PORTB;
    if(0b11110000 ^ PORTB){
        KeypadRow();
        return 1;
    }

//    RA0 = 1; RA1 = 0; RA2 = 1;
    PORTA = 0b00000101;
    Digit += 1;
//    Save = PORTB;
    if(0b11110000 ^ PORTB){
        KeypadRow();
        return 1;
    }

//    RA0 = 1; RA1 = 1; RA2 = 0;
    PORTA = 0b00000011;
    Digit += 1;
//    Save = PORTB;
    if(0b11110000 ^ PORTB){
        KeypadRow();
        return 1;
    }
    Digit = 0;
    return 0;
} 

char KeypadRow(){
    unsigned int WREG = PORTB;
    if(!(0b11100000 ^ WREG)){return 1;}
    Digit += 3;
    if(!(0b11010000 ^ WREG)){return 2;}
    Digit += 3;
    if(!(0b10110000 ^ WREG)){return 3;}
    Digit += 3;
    if(!(0b01110000 & WREG)){return 4;}
    
    return 0;
}

char   GetCode(){
    switch(Digit){
        case 1:
            return 0b01111010; // 1
        case 2:
            return 0b00100001; // 2
        case 3:
            return 0b00110000; // 3
        case 4:
            return 0b01011000; // 4
        case 5:
            return 0b00010100; // 5
        case 6:
            return 0b00000100; // 6
        case 7:
            return 0b00111010; // 7
        case 8:  
            return 0b00000000; // 8
        case 9:
            return 0b00011000; // 9
        case 10:
            return 0b00001001; // P
        case 11:
            return 0b00000010; // 0
        case 12:
            return 0b01100000; // d
        default:
            return 0b11111111;
    }
    //      -afedbgc    
}

void Initialization()
{
    ANSEL  = 0;            // All pins digital
    ANSELH = 0;            // All pins digital
    WPUB = 0b11110000;     //Weak pull-up for PORTB4-7
    OSCCON = 0b01110000;   // Setting Oscillator to do 8MHz
    TRISA = 0b00000000;   // PORTA0-2 as output
    TRISB = 0b11110000;   // PORTB4-7 as input
    TRISC  = 0b00000000;   // PORTC3-7 as output
    nRABPU = 0;               // Enable internal pull-up
//    RA0 = 1;
//    RA1 = 1;
//    RA2 = 1;
    PORTA = 0b00000000;
    PORTC = 0b00000000;
}

