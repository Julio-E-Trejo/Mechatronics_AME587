//    Filename: TASK14
//    Instructor:
//    Group: 3
//    Date: 3/6/2023

#include <xc.h>     // header file
#include <math.h>   // header file
#include <stdlib.h>
#include <pic16f690.h>
#define _XTAL_FREQ 8000000
#pragma config FOSC = INTRCIO, WDTE = OFF, PWRTE = OFF, MCLRE = ON, CP = OFF, CPD = OFF, BOREN = OFF, IESO = OFF, FCMEN = OFF

unsigned int Digit;
unsigned int Save;
unsigned int SaveDigit;
signed int ByteA;
signed int ByteB;
signed int Speed;

//Function Declarations
int Delay();
int GetSpeed();
int Initialization();
char Keypad();
char KeypadRow();
int ReleaseKeypad();
int ResetClock();
int RunMotor();

int main()  // Start of the main function
{
    Initialization();            // Call Initialization
    
    while(1){
        if(!Keypad()){continue;}     // Call Keypad
        ReleaseKeypad();             // Call ReleaseKeypad
        GetSpeed();

        if(SaveDigit > Digit){Save = (10-SaveDigit)+Digit;}
        else{Save = abs(SaveDigit - Digit);}
        for(int Run = Save * 20; Run > 0; Run --){
            RunMotor();
        }
        SaveDigit = Digit;
    }
}

//Used to cycle through rows in the keypad
char KeypadRow(){
    unsigned int WREG = PORTB;
    if(!(0b11100000 ^ WREG)){return 1;}
    Digit += 3;
    if(!(0b11010000 ^ WREG)){return 2;}
    Digit += 3;
    if(!(0b10110000 ^ WREG)){return 3;}
    Digit += 3;
    return 0;
}

//Used to cycle through rows in the keypad
//Used to generate the actual number input
char Keypad()  //Determines keypad input
{
//    RA0 = 0; RA1 = 1; RA2 = 1;
    PORTA = 0b00000110;
    Digit = 1;
    if(0b11110000 ^ PORTB){
        KeypadRow();
        return 1;
    }

//    RA0 = 1; RA1 = 0; RA2 = 1;
    PORTA = 0b00000101;
    Digit += 1;
    if(0b11110000 ^ PORTB){
        KeypadRow();
        return 1;
    }

//    RA0 = 1; RA1 = 1; RA2 = 0;
    PORTA = 0b00000011;
    Digit += 1;
    if(0b11110000 ^ PORTB){
        KeypadRow();
        return 1;
    }
    Digit = 0;
    return 0;
} 


//Determines whether the keypad is still pressed
int ReleaseKeypad()        
{   
    RA0 = 0;
    RA1 = 0;
    RA2 = 0;
    //Continues until nothing is pressed (i.e. PORTB == 0b11110000)
    while((0b11110000 ^ PORTB) != 0b00000000){;}
    return 0;
} 


//Runs the motor
int RunMotor()
{
    RC6 = 1;
    __delay_ms(1);
    RC6 = 0;
    __delay_ms(1);
    return 0;
}


int GetSpeed()
{
    GO = 1;
    while(GO == 1){;} //Wait until ADC conversion is done
    Speed  = ADRESH/10;
    Speed += 2;
    return 0;
}


int ResetClock()
{
    if (RA5 == 0){return 1;} //Return to main if RA5 is clear
    RC7 = 1;
    SaveDigit = 10;
    while(RA5 != 0) //Run next 2 lines if PortA5 != 0
    {
        RunMotor();
        SaveDigit = 10;
    }
    RunMotor();
    RunMotor();
    RC7 = 0;
    return 0;
}


int Initialization()
{
    ANSEL  = 0;            // All pins digital
    ANSELH = 0;            // All pins digital
    WPUB = 0b11110000;     //Weak pull-up for PORTB4-7
    OSCCON = 0b01110000;   // Setting Oscillator to do 8MHz
    ADCON1 = 0b01010000;   // Select ADC Clock to FOSC/16
    TRISA = 0b00110000;   // PORTA0-2 as output & 4-5 as input
    TRISB = 0b11110000;   // PORTB4-7 as input
    TRISC  = 0b00000000;   // PORTC3-7 as output
    nRABPU = 0;               // Enable internal pull-up
    WPUA5 = 1;             // Enable PORTA5 weak pull-up
    ADON = 1;             // Enable ADC
    CHS0 = 1;              // Selecting pin RA4/AN3
    CHS1 = 1;
    CHS2 = 0;
    CHS3 = 0;
    RA0 = 1;
    RA1 = 1;
    RA2 = 1;
    RC3 = 1;              //Turns on motor driver
    //Full steps: M0 = 0, M1 = 0
    RC4 = 0;            //M0
    RC5 = 0;            //M1
    RC7 = 0;            //CW Rotation
    Digit = 0;
    SaveDigit = 0;
    return 0;
}