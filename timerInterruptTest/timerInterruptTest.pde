#include <avr/interrupt.h>  
#include <avr/io.h>

const int ledPin = 13;

//Timer2 overflow interrupt vector handler, called (16,000,000/256)/256 times per second
ISR(TIMER1_OVF_vect) {
  digitalWrite(ledPin,!digitalRead(ledPin));
};  

void setup() {

  //Timer2 Settings: Timer Prescaler /1024, WGM mode 0
  TCCR1A = 0;
  
  TCCR1B = 1 << CS12 | 1 << CS10;  //1024
  //TCCR1B = 1 << CS12;              /1
  //TCCR1B = 1 << CS11 | 1 << CS10;    /64
  //Timer2 Overflow Interrupt Enable  
  TIMSK1 = 1 << TOIE1;

  //reset timer
  TCNT1L = 0;
  TCNT1H = 0;
}

void loop() {
}
 
