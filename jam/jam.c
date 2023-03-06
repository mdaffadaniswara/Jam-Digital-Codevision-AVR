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
#define SEG_E PORTC.1
#define SEG_F PORTD.4
#define SEG_G PORTC.0
#define SEG_DP PORTD.5
#define BUTTON_A PIND.3
#define BUTTON_B PINC.5
#define BUTTON_C PINC.4
#define BUTTON_D PINC.3
#define PIN_BUZZ PORTD.2

void init_int1(void)
{                                                    // 1s
  TCCR1A = (1 << WGM12); // ctc 
  TCCR1B = (1 << CS12);      //256
  TCNT1H = 0;
  TCNT1L = 0;
  OCR1AH = 0xF4;
  OCR1AL = 0x24;
  TIMSK1 = 0b00000010;
}

void init_int2(void)
{                                                    // 1ms
  TIMSK0 = 0b00000001;
  TCCR0B = (1 << CS02);    //256
  TCNT0 = 0x83;  
}


void init_buttonA(void)
{
  // SET FALLING EDGE PADA INT1
   EICRA = (1<<ISC11)|(0<<ISC10) |(0<<ISC01)|(0<<ISC00);
  // ENABLE INT1
  EIMSK = (1 << INT1) | (0<<INT0);
}

// Define Seven Segment Segments
void SevenSegment(int num)
{
  // Elif for number modifier Seven Segments
  if (num == 0)
  {
    SEG_A = 0;
    SEG_B = 0;
    SEG_C = 0;
    SEG_D = 0;
    SEG_E = 0;
    SEG_F = 0;
    SEG_G = 1;
  }
  else if (num == 1)
  {
    SEG_A = 1;
    SEG_B = 0;
    SEG_C = 0;
    SEG_D = 1;
    SEG_E = 1;
    SEG_F = 1;
    SEG_G = 1;
  }
  else if (num == 2)
  {
    SEG_A = 0;
    SEG_B = 0;
    SEG_C = 1;
    SEG_D = 0;
    SEG_E = 0;
    SEG_F = 1;
    SEG_G = 0;
  }
  else if (num == 3)
  {
    SEG_A = 0;
    SEG_B = 0;
    SEG_C = 0;
    SEG_D = 0;
    SEG_E = 1;
    SEG_F = 1;
    SEG_G = 0;
  }
  else if (num == 4)
  {
    SEG_A = 1;
    SEG_B = 0;
    SEG_C = 0;
    SEG_D = 1;
    SEG_E = 1;
    SEG_F = 0;
    SEG_G = 0;
  }
  else if (num == 5)
  {
    SEG_A = 0;
    SEG_B = 1;
    SEG_C = 0;
    SEG_D = 0;
    SEG_E = 1;
    SEG_F = 0;
    SEG_G = 0;
  }
  else if (num == 6)
  {
    SEG_A = 0;
    SEG_B = 1;
    SEG_C = 0;
    SEG_D = 0;
    SEG_E = 0;
    SEG_F = 0;
    SEG_G = 0;
  }
  else if (num == 7)
  {
    SEG_A = 0;
    SEG_B = 0;
    SEG_C = 0;
    SEG_D = 1;
    SEG_E = 1;
    SEG_F = 1;
    SEG_G = 1;
  }
  else if (num == 8)
  {
    SEG_A = 0;
    SEG_B = 0;
    SEG_C = 0;
    SEG_D = 0;
    SEG_E = 0;
    SEG_F = 0;
    SEG_G = 0;
  }
  else if (num == 9)
  {
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
int seconds = 0;
int minutes = 0;
int seconds_1000 = 0;
int minutes_1000 = 0;

// Define Digit Variables
int digits[4] = {0, 0, 0, 0};
int digit_index = 0;

int atur = 1;
int geser = 1;
void aturJam(void)
{
   
   #asm("sei")
   atur = 0;
   TIMSK1 &= ~(1 << OCIE1A);
  while(!(EIFR & (1 << INTF1))) {   //menunggu sampai interrupt ditekan
  if (BUTTON_D == 1)
  {
    delay_ms(300);
    if (geser == 0){
      seconds++;
      seconds_1000 = seconds*1000;
      if (seconds >= 60){
        seconds = 0;
        seconds_1000 = seconds*1000;
      }
    }
    else{
      minutes++;
      minutes_1000 = minutes;
      if (minutes >= 60){
        minutes = 0;
        minutes_1000 = minutes;
      }      
    }
  }
  else if (BUTTON_C  == 1)
  {       
    delay_ms(300);
    if (geser == 0){
      seconds--;
      seconds_1000 = seconds*1000;      
      if (seconds <= -1){
        seconds = 59;
        seconds_1000 = seconds*1000;
      }
    }
    else{
      minutes--;
      minutes_1000 = minutes;      
      if (minutes <= -1){
        minutes = 59;
        minutes_1000 = minutes;
      }
    }                                                         
  }
  else if (BUTTON_B  == 1){
   delay_ms(300);
    if (geser == 0){
        geser = 1;
    }            
    else{
        geser = 0;
    }
  }
    // Update Digit Values
    digits[0] = minutes / 10;
    digits[1] = minutes % 10;
    digits[2] = seconds / 10;
    digits[3] = seconds % 10;
    }
  atur = 1;    
  // Clear the external interrupt flag
  EIFR &= (0 << INTF1);

  // Return from function
  return;
    
}

void stopWatch(void)
{
   #asm("sei")
  seconds = 0;
  minutes = 0;
  TIMSK1 &= ~(1 << OCIE1A);
  
  while(!(EIFR & (1 << INTF1))) {   //menunggu sampai interrupt ditekan
  if (BUTTON_D == 1)                      //start
  {
    delay_ms(300);
    TIMSK1 |= (1 << OCIE1A);
  }
  else if (BUTTON_C  == 1)         //pause
  {       
    delay_ms(300);
    TIMSK1 &= ~(1 << OCIE1A);                                                        
  }                                              
  else if (BUTTON_B  == 1){                      //pause and reset
   delay_ms(300);
   TIMSK1 &= ~(1 << OCIE1A);                                                        
   seconds = 0;
   minutes = 0;
  }
    // Update Digit Values
    digits[0] = minutes / 10;
    digits[1] = minutes % 10;
    digits[2] = seconds / 10;
    digits[3] = seconds % 10;
    }
    
  // Clear the external interrupt flag
  EIFR &= (0 << INTF1);

  // Return from function
  return;                                                            
}


int timer = 0;
void alarmTimer (void)
{
   #asm("sei")
  timer = 1;
  TIMSK1 &= ~(1 << OCIE1A);
  seconds = 0;
  minutes = 0;
  while(!(EIFR & (1 << INTF1))) {   //menunggu sampai interrupt ditekan
  if (BUTTON_D == 1)
  {
    delay_ms(300);
    seconds++;
    if (seconds >= 60){
      seconds = 0;
    }
  }
  else if (BUTTON_C  == 1)
  {       
    delay_ms(300);
    minutes++;
    if (minutes >= 60){
      minutes = 0;
    }                                                         
  }
  else if (BUTTON_B  == 1){
    delay_ms(300);
    TIMSK1 |= (1 << OCIE1A);
  }
    // Update Digit Values
    digits[0] = minutes / 10;
    digits[1] = minutes % 10;
    digits[2] = seconds / 10;
    digits[3] = seconds % 10;
    if(minutes == 0 && seconds == 0){
        PIN_BUZZ = 1;
    }
    }
    
    timer = 0;
    
  // Clear the external interrupt flag
  EIFR &= (0 << INTF1);

  // Return from function
  return;                                                            
}

void tampilanJam(void)
{
    #asm("sei")
    TIMSK1 |= (1 << OCIE1A);      //256  
  while(!(EIFR & (1 << INTF1))) {   //menunggu sampai interrupt ditekan
  }
    
  // Clear the external interrupt flag
  EIFR &= (0 << INTF1);

  // Return from function
  return;                                                            
}

int mode = 0;
// External Interrupt
interrupt[EXT_INT1] void ext_int1_isr(void)                                                                             
{              
  delay_ms (300); 
  if (mode == 1){ //mode stopwatch
    atur = 1;
    mode = 2;
    TIMSK1 &= ~(1 << OCIE1A);
    stopWatch(); 
  }
  delay_ms (300); 
  if (mode == 0)
  {              //mode tampilan
    seconds = (seconds_1000)/1000;
    minutes = minutes_1000;
    timer = 0;
    atur = 1;
    mode = 1;
    TIMSK1 |= (1 << OCIE1A);      //256
    tampilanJam();
  }                 
  delay_ms (300);
  if(mode == 2){
    atur = 1;
    timer = 1;
    mode = 0;
    TIMSK1 &= ~(1 << OCIE1A);
    alarmTimer();  
  }
  /*else if (mode == 0)
  {           //mode mengatur
    mode = 1;
    TIMSK1 &= ~(1 << OCIE1A);
    aturJam();
  }  */    

}

// Timer1 Compare Match A Interrupt
interrupt[TIM1_COMPA] void timera_compa_isr(void)
{
  if (timer == 0){
      // Check if 1 Second has Passed
      seconds++;

      // Check if 1 Minute has Passed
      if (seconds >= 60)
      {
        seconds = 0;
        minutes++;
      }
      if (minutes >= 60)
      {
        minutes = 00;
      }
  }
  else{
      // Check if 1 Second has Passed
      seconds--;

      // Check if 1 Minute has Passed
      if(seconds == 0 && minutes == 0){ //timer sudah mencapai 0
        TIMSK1 &= ~(1 << OCIE1A);    
      }
      if (seconds <= -1)
      {
        seconds = 59;
        minutes--;
      }
      if (minutes <= -1)
      {
        minutes = 0;
      }  
  }

  // Update Digit Values
  digits[0] = minutes / 10;
  digits[1] = minutes % 10;
  digits[2] = seconds / 10;
  digits[3] = seconds % 10;
}

// Timer0 Overflow Interrupt
interrupt[TIM0_OVF] void timer0_ovf_isr(void)
{
  // Check if 1 Second has Passed
  seconds_1000++;

  // Check if 1 Minute has Passed
  if (seconds_1000 >= 60000)
  {
    seconds_1000 -= 60000;
    minutes_1000++;
  }
  if (minutes_1000 >= 60)
  {
    minutes_1000 -= 60;
  }

  // Update Segment Values for Current Digit
  SevenSegment(digits[digit_index]);

  // Enable Multiplexing for Current Digit
  // Elif for choose seven SevenSegmen
  if (atur == 1)  {
  if (digit_index == 0)
  {
    DIGIT_1 = 1;
    DIGIT_2 = 0;
    DIGIT_3 = 0;
    DIGIT_4 = 0;
  }
  else if (digit_index == 1)
  {
    DIGIT_1 = 0;
    DIGIT_2 = 1;
    DIGIT_3 = 0;
    DIGIT_4 = 0;
  }
  else if (digit_index == 2)
  {
    DIGIT_1 = 0;
    DIGIT_2 = 0;
    DIGIT_3 = 1;
    DIGIT_4 = 0;
  }
  else if (digit_index == 3)
  {
    DIGIT_1 = 0;
    DIGIT_2 = 0;
    DIGIT_3 = 0;
    DIGIT_4 = 1;
  } }
  else {
  if (digit_index == 0 && geser == 1)
  {
    DIGIT_1 = 1;
    DIGIT_2 = 0;
    DIGIT_3 = 0;
    DIGIT_4 = 0;
  }
  else if (digit_index == 1 && geser == 1)
  {
    DIGIT_1 = 0;
    DIGIT_2 = 1;
    DIGIT_3 = 0;
    DIGIT_4 = 0;
  }
    else if (digit_index == 2 && geser == 1)
  {
    DIGIT_1 = 0;
    DIGIT_2 = 0;
    DIGIT_3 = 0;
    DIGIT_4 = 0;
  }
      else if (digit_index == 3 && geser == 1)
  {
    DIGIT_1 = 0;
    DIGIT_2 = 0;
    DIGIT_3 = 0;
    DIGIT_4 = 0;
  }
  else  if (digit_index == 0 && geser == 0)
  {
    DIGIT_1 = 0;
    DIGIT_2 = 0;
    DIGIT_3 = 0;
    DIGIT_4 = 0;
  }
  else if (digit_index == 1 && geser == 0)
  {
    DIGIT_1 = 0;
    DIGIT_2 = 0;
    DIGIT_3 = 0;
    DIGIT_4 = 0;
  }
  else if (digit_index == 2 && geser == 0)
  {
    DIGIT_1 = 0;
    DIGIT_2 = 0;
    DIGIT_3 = 1;
    DIGIT_4 = 0;
  }
  else if (digit_index == 3 && geser == 0)
  {
    DIGIT_1 = 0;
    DIGIT_2 = 0;
    DIGIT_3 = 0;
    DIGIT_4 = 1;
  }
  }

  // Increment Digit Index
  digit_index++;

  // Wrap Around Digit Index
  if (digit_index >= 4)
  {
    digit_index = 0;
  }
}



void main(void)
{
  // Initialize Timer1
  // set prescaler 1024
  init_int1();
  init_int2();
  init_buttonA();

  // Enable Interrupts
  #asm("sei")

  // Set Seven Segment Pins as Output
  DDRB = 0b111111;
  DDRD &= ~(1 << DDD3);
  DDRD |= (1 << DDD2) | (1 << DDD4) | (1 << DDD5) | (1 << DDD6) | (1 << DDD7);
  DDRC |= (1 << DDC0) | (1 << DDC1);
  DDRC &= ~(1 << DDD5) & ~(1 << DDD4) & ~(1 << DDD3);
  PORTD |= (1 << BUTTON_A) | (1 << BUTTON_B) | (1 << BUTTON_C) |(1 << BUTTON_D);
  
  TIMSK1 &= ~(1 << OCIE1A);
  aturJam();
  while (1)
  {
  }
}
