/*
Tugas EL3014 Sistem Mikroprosesor 
*Modul            : 1 - ATMega328
*Percobaan        : 1.5.3 Timer dengan CodeVision AVR
*Hari dan Tanggal : Jumat, 10 Februari 2023
*Nama (NIM) 1     : Muhammad Daffa Daniswara (13220043)
*Nama (NIM) 2     : Bostang Palaguna (13220055)
*Nama File        : jam.c
*Deskripsi        : sourcecode program jam digital tugas  EL3014  Sistem Mikroprosesor
*/

// Program JamDigital
  // mengimplementasikan rangkaian jam digital pada Arduino nano dengan pemrogramam menggunakan CodeVision.
  // Jam digital menggunaknan interrupt tomobol serta interrupt timer
// KAMUS
  // Konstanta
    //
  // Variabel
    // mode : integer
    // {
    //   0 : menampilkan jam seperti biasa
    //   1 : mode stopwatch
    //   2 : mode timer
    //   3 : mode atur jam
    // }
    // atur : integer { 1 : menggilir seven segment, 0 : pindah digit saat tombol ditekan }
    // geser : integer { }
    // digits : array [0..3] of integer { digit yang ditampilkan pada seven segment }
    // digit_index : integer { menentukan digit ke-berapa yang menyala }
    // start : integer { 0 : menyatakan waktu tidak berubah, 1 : menyatakan waktu berubah }
    //
    // seconds_jam : integer { informasi detik pada mode tampilan waktu }
    // minutes_jam : integer { informasi menit pada mode tampilan waktu }
    // seconds_timer : integer { informasi detik pada mode timer }
    // minutes_timer : integer { informasi menit pada mode timer }
    // seconds_stopwatch : integer { informasi detik  pada mode stopwatch }
    // minutes_stopwatch : integer { informasi menit pada mode stopwatch }

// ALGORITMA UTAMA

// Include library yang dibutuhkan
#include <mega328p.h>
#include <avr/interrupt.h>
#include <delay.h>

// INISIASI FUNGSI/PROSEDUR

void init_int1(void);
void init_int2(void);
void init_buttonA(void);
void SevenSegment(int num);
void aturJam(void);
void stopWatch(void);
void alarmTimer(void);
void tampilanJam(void);

// DEKLARASI VARIABEL

// Mendefinisikan pin seven segment, button, dan buzzer
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

// Mendefinisikan variabel waktu yang akan ditampilkan pada seven segment
int seconds_jam = 0;
int minutes_jam = 0;
int seconds_timer = 0;
int minutes_timer = 0;
int seconds_stopwatch = 0;
int minutes_stopwatch = 0;

// Mendefinisikan variabel digit
int digits[4] = {0, 0, 0, 0};
int digit_index = 0;
int atur = 1;
int geser = 1;
int mode = 0;
int start = 0;

// IMPLEMENTASI INTERRUPT

// External Interrupt
// Mengatur mode jam 
interrupt[EXT_INT1] void ext_int1_isr(void)
{
  PIN_BUZZ = 0;
  delay_ms(300);
  
  // mode tampilan
  if (mode == 0)
  {
    atur = 1;
    mode = 1;
    start = 1;
    TIMSK1 |= (1 << OCIE1A);
    tampilanJam();
  }

  // mode stopwatch
  else if (mode == 1)
  {
    atur = 1;
    mode = 2;
    start = 0;
    stopWatch();
  }

  // mode timer
  else if (mode == 2)
  {
    atur = 1;
    mode = 3;
    start = 0; 
    alarmTimer();
  }
  
  else if (mode == 3)
  {
    atur = 0;
    mode = 0;
    start = 0; 
    aturJam();
  }
}

// menggunakan interrupt waktu setiap satu detik untuk mengubah waktu
interrupt[TIM1_COMPA] void timera_compa_isr(void)
{ 
  // saatnya waktu berubah
  if (start == 1)
  {
    // mengatur digit seven segment saat mode : penampilan jam
    if (mode == 1)
    {
      // satu detik berlalu
      seconds_jam++;

      // satu menit berlalu
      if (seconds_jam >= 60)
      {
        seconds_jam = 0;
        minutes_jam++;
      }
      // satu jam telah berlalu
      if (minutes_jam >= 60)
      {
        minutes_jam = 0;
      }

      // mengubah nilai digit seven segment
      digits[0] = minutes_jam / 10;
      digits[1] = minutes_jam % 10;
      digits[2] = seconds_jam / 10;
      digits[3] = seconds_jam % 10;
    }

    // mengatur digit seven segment saat mode : timer
    else if(mode == 3)
    {
      // satu detik berlalu
      seconds_timer--;
      seconds_jam++;

      // satu menit berlalu
      if (seconds_jam >= 60)
      {
        seconds_jam = 0;
        minutes_jam++;
      }

      // satu jam telah berlalu
      if (minutes_jam >= 60)
      {
        minutes_jam = 0;
      }

      // saat timer telah selesai, buzzer berbunyi dan reset timer
      if (seconds_timer == 0 && minutes_timer == 0)
      { // timer sudah mencapai 0
        PIN_BUZZ = 1;
        start = 0;
      }
        // transisi detik ke xy:00 menjadi x(y-1) : 59
      if (seconds_timer <= -1)
      {
        seconds_timer = 59;
        minutes_timer--;
      }
        
      if (minutes_timer <= -1)
      {
        minutes_timer = 0;
      }

      // mengubah nilai digit seven segment
      digits[0] = minutes_timer / 10;
      digits[1] = minutes_timer % 10;
      digits[2] = seconds_timer / 10;
      digits[3] = seconds_timer % 10;
    }
    
    // mengatur digit seven segment saat mode : stopwatch
    else if (mode == 2)
    {
      // satu detik berlalu
      seconds_stopwatch++;
      seconds_jam++; // waktu jam juga ditambah supaya waktu jam juga ikut berubah

      if (seconds_jam >= 60)
      {
        seconds_jam = 0;
        minutes_jam++;
      }
      if (minutes_jam >= 60)
      {
        minutes_jam = 0;
      }

      // satu menit berlalu
      if (seconds_stopwatch >= 60)
      {
        seconds_stopwatch = 0;
        minutes_stopwatch++;
      }

      // satu jam berlalu
      if (minutes_stopwatch >= 60)
      {
        minutes_stopwatch = 00;
      }

      // mengubah nilai digit seven segment
      digits[0] = minutes_stopwatch / 10;
      digits[1] = minutes_stopwatch % 10;
      digits[2] = seconds_stopwatch / 10;
      digits[3] = seconds_stopwatch % 10;
    }
  }

  // agar saat mode lain waktu tetap berjalan
  else
  {
    seconds_jam++;

    // Check if 1 Minute has Passed
    if (seconds_jam >= 60)
    {
      seconds_jam = 0;
      minutes_jam++;
    }
    if (minutes_jam >= 60)
    {
      minutes_jam = 0;
    }
    if (mode == 2)
    {
      digits[0] = minutes_stopwatch / 10;
      digits[1] = minutes_stopwatch % 10;
      digits[2] = seconds_stopwatch / 10;
      digits[3] = seconds_stopwatch % 10;    
    }
    else if(mode == 1)
    {
      digits[0] = minutes_timer / 10;
      digits[1] = minutes_timer % 10;
      digits[2] = seconds_timer / 10;
      digits[3] = seconds_timer % 10;
    } 
  }
}

// menggunakan interrupt waktu setiap 1ms untuk menggilir seven segment
interrupt[TIM0_OVF] void timer0_ovf_isr(void)
{
  // mengubah digit seven segment
  SevenSegment(digits[digit_index]);

  // multiplexing / menggilir digit seven segment
  if (atur == 1)
  {
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
    }
  }
  else
  {
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
    else if (digit_index == 0 && geser == 0)
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
  PORTD |= (1 << BUTTON_A) | (1 << BUTTON_B) | (1 << BUTTON_C) | (1 << BUTTON_D);

  TIMSK1 &= ~(1 << OCIE1A);
  mode = 0;
  aturJam();
  while (1)
  {
  }
}

// DEKLARASI FUNGSI/PROSEDUR
void init_int1(void)
{                        // 1s
  TCCR1A = (1 << WGM12); // ctc
  TCCR1B = (1 << CS12);  // 256
  TCNT1H = 0;
  TCNT1L = 0;
  OCR1AH = 0xF4;
  OCR1AL = 0x24;
  TIMSK1 = 0b00000010;
}

// inisiasi timer interrupt2 untuk setiap 1 ms
void init_int2(void)
{ 
  TIMSK0 = 0b00000001;
  TCCR0B = (1 << CS02); // mengatur pre-scaler 256
  TCNT0 = 0x83;
}

void init_buttonA(void)
{
  // SET FALLING EDGE PADA INT1
  EICRA = (1 << ISC11) | (0 << ISC10) | (0 << ISC01) | (0 << ISC00);
  // ENABLE INT1
  EIMSK = (1 << INT1) | (0 << INT0);
}

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

void aturJam(void)
{
#asm("sei")
  atur = 0;
  start = 0;
  while (!(EIFR & (1 << INTF1)))
  { // menunggu sampai interrupt ditekan
    if (BUTTON_D == 1)
    {
      delay_ms(300);
      if (geser == 0)
      {
        seconds_jam++;
        if (seconds_jam >= 60)
        {
          seconds_jam = 0;
        }
      }
      else
      {
        minutes_jam++;
        if (minutes_jam >= 60)
        {
          minutes_jam = 0;
        }
      }
    }
    else if (BUTTON_C == 1)
    {
      delay_ms(300);
      if (geser == 0)
      {
        seconds_jam--;
        if (seconds_jam <= -1)
        {
          seconds_jam = 59;
        }
      }
      else
      {
        minutes_jam--;
        if (minutes_jam <= -1)
        {
          minutes_jam = 59;
        }
      }
    }
    else if (BUTTON_B == 1)
    {
      delay_ms(300);
      if (geser == 0)
      {
        geser = 1;
      }
      else
      {
        geser = 0;
      }
    }
    // Update Digit Values
    digits[0] = minutes_jam / 10;
    digits[1] = minutes_jam % 10;
    digits[2] = seconds_jam / 10;
    digits[3] = seconds_jam % 10;
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
  seconds_stopwatch = 0;
  minutes_stopwatch = 0;
  start = 0;

  while (!(EIFR & (1 << INTF1)))
  {                    // menunggu sampai interrupt ditekan
    if (BUTTON_D == 1) // start
    {
      delay_ms(300);
      start = 1;
    }
    else if (BUTTON_C == 1) // pause
    {
      delay_ms(300);
      start = 0;
    }
    else if (BUTTON_B == 1)
    { // pause and reset
      delay_ms(300);
      start = 0;
      seconds_stopwatch = 0;
      minutes_stopwatch = 0;
    }
    // Update Digit Values
    digits[0] = minutes_stopwatch / 10;
    digits[1] = minutes_stopwatch % 10;
    digits[2] = seconds_stopwatch / 10;
    digits[3] = seconds_stopwatch % 10;
  }

  // Clear the external interrupt flag
  EIFR &= (0 << INTF1);

  // Return from function
  return;
}

void alarmTimer(void)
{
#asm("sei")
  start = 0;
  seconds_timer = 0;
  minutes_timer = 0;
  while (!(EIFR & (1 << INTF1)))
  { // menunggu sampai interrupt ditekan
    if (BUTTON_D == 1)
    {
      delay_ms(300);
      PIN_BUZZ = 0;
      seconds_timer++;
      if (seconds_timer >= 60)
      {
        seconds_timer = 0;
      }
    }
    else if (BUTTON_C == 1)
    {
      delay_ms(300);
      PIN_BUZZ = 0;
      minutes_timer++;
      if (minutes_timer >= 60)
      {
        minutes_timer = 0;
      }
    }
    else if (BUTTON_B == 1)
    {
      delay_ms(300);
      start = 1;
    }
    // Update Digit Values
    digits[0] = minutes_timer / 10;
    digits[1] = minutes_timer % 10;
    digits[2] = seconds_timer / 10;
    digits[3] = seconds_timer % 10;
  }
  // Clear the external interrupt flag
  EIFR &= (0 << INTF1);

  // Return from function
  return;
}

void tampilanJam(void)
{
#asm("sei")

  while (!(EIFR & (1 << INTF1)))
  { // menunggu sampai interrupt ditekan
  }

  // Clear the external interrupt flag
  EIFR &= (0 << INTF1);

  // Return from function
  return;
}
