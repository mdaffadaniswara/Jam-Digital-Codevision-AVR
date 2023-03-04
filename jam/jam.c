#include <mega328p.h>
#include <avr/interrupt.h>
#include <delay.h>

// Define Seven Segment Pins
#define DIGIT_1 PORTB.5
#define DIGIT_2 PORTB.3
#define DIGIT_3 PORTB.4
#define DIGIT_4 PORTB.2
#define SEG_A PORTB.0
#define SEG_B PORTD.6
#define SEG_C PORTD.7
#define SEG_D PORTB.1
#define SEG_E PORTD.3
#define SEG_F PORTD.4
#define SEG_G PORTD.2
#define SEG_DP PORTD.5

void init_int1(void){              //1s
  TCCR1A = (1 << WGM12) | (1 << CS12) | (1 << CS10);  //1024 --> cs12 cs10
  OCR1AH = 0x3D;
  OCR1AL = 0x09;
}

void init_int2(void){         //1ms
  TCCR1B = (1 << WGM22) | (1 << CS22) | (1 << CS20); // prescaler 1024
  OCR1BL = 1;     
  TIMSK1 = 0b00000110;
}

// Define Seven Segment Segments
void SevenSegment(int num) {
  // Elif for number modifier Seven Segments
  if (num == 0) {
    SEG_A = 0;
    SEG_B = 0;
    SEG_C = 0;
    SEG_D = 0;
    SEG_E = 0;
    SEG_F = 0;
    SEG_G = 1;
  } else if (num == 1) {
    SEG_A = 1;
    SEG_B = 0;
    SEG_C = 0;
    SEG_D = 1;
    SEG_E = 1;
    SEG_F = 1;
    SEG_G = 1;
  } else if (num == 2) {
    SEG_A = 0;
    SEG_B = 0;
    SEG_C = 1;
    SEG_D = 0;
    SEG_E = 0;
    SEG_F = 1;
    SEG_G = 0;
  } else if (num == 3) {
    SEG_A = 0;
    SEG_B = 0;
    SEG_C = 0;
    SEG_D = 0;
    SEG_E = 1;
    SEG_F = 1;
    SEG_G = 0;
  } else if (num == 4) {
    SEG_A = 1;
    SEG_B = 0;
    SEG_C = 0;
    SEG_D = 1;
    SEG_E = 1;
    SEG_F = 0;
    SEG_G = 0;
  } else if (num == 5) {
    SEG_A = 0;
    SEG_B = 1;
    SEG_C = 0;
    SEG_D = 0;
    SEG_E = 1;
    SEG_F = 0;
    SEG_G = 0;
  } else if (num == 6) {
    SEG_A = 0;
    SEG_B = 1;
    SEG_C = 0;
    SEG_D = 0;
    SEG_E = 0;
    SEG_F = 0;
    SEG_G = 0;
  } else if (num == 7) {
    SEG_A = 0;
    SEG_B = 0;
    SEG_C = 0;
    SEG_D = 1;
    SEG_E = 1;
    SEG_F = 1;
    SEG_G = 1;
  } else if (num == 8) {
    SEG_A = 0;
    SEG_B = 0;
    SEG_C = 0;
    SEG_D = 0;
    SEG_E = 0;
    SEG_F = 0;
    SEG_G = 0;
  } else if (num == 9) {
    SEG_A = 0;
    SEG_B = 0;
    SEG_C = 0;
    SEG_D = 0;
    SEG_E = 1;
    SEG_F = 0;
    SEG_G = 0;
  }
}

// Define Time Variables
int seconds_60 = 0;
int seconds = 0;
int minutes = 0;

// Define Digit Variables
int digits[4] = {0, 0, 0, 0};
int digit_index = 0;

// Timer1 Compare Match A Interrupt
interrupt [TIM1_COMPA] void timera_compa_isr(void) {
  // Check if 1 Second has Passed
    seconds_60++;

    // Check if 1 Minute has Passed
    if (seconds_60 >= 60) {   
      seconds_60 = 0;
      seconds++;
    }
    if (seconds >= 60) {
      seconds = 0;
      minutes++;
    }
    if (minutes >= 60){
      minutes = 0;
    }

    // Update Digit Values
    digits[0] = minutes / 10;
    digits[1] = minutes % 10;
    digits[2] = seconds / 10;
    digits[3] = seconds % 10;
}

// Timer1 Compare Match B Interrupt
interrupt [TIM1_COMPB] void timerb_compb_isr(void) {

  // Update Segment Values for Current Digit
  SevenSegment(digits[digit_index]);

    // Enable Multiplexing for Current Digit
  // Elif for choose seven SevenSegmen
  if (digit_index == 0) {
    DIGIT_1 = 1;  
    DIGIT_2 = 0;
    DIGIT_3 = 0;
    DIGIT_4 = 0;
  } else if (digit_index == 1) {
    DIGIT_1 = 0;  
    DIGIT_2 = 1;  
    DIGIT_3 = 0;
    DIGIT_4 = 0;
  } else if (digit_index == 2) {
    DIGIT_1 = 0;  
    DIGIT_2 = 0;  
    DIGIT_3 = 1;
    DIGIT_4 = 0;
  } else if (digit_index == 3) {
    DIGIT_1 = 0;  
    DIGIT_2 = 0;  
    DIGIT_3 = 0;
    DIGIT_4 = 1;
  }

    // Increment Digit Index
    digit_index++;

    // Wrap Around Digit Index
    if (digit_index >= 4) {
    digit_index = 0;
    }
}

void main(void) {
// Initialize Timer1
//set prescaler 1024
init_int1();
init_int2();

// Enable Interrupts
#asm("sei")

// Set Seven Segment Pins as Output
DDRB = 0b111111;
DDRD &= ~(1 << DDD0) & ~(1 << DDD1);
DDRD |= (1 << DDD2) | (1 << DDD3) | (1 << DDD4) | (1 << DDD5) | (1 << DDD6) | (1 << DDD7);

while (1) {

}
}
