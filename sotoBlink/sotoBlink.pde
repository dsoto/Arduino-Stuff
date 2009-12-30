// LED blinking
// Daniel Soto


void setup() {
  DDRB = 1 << DDB5;
  PORTB = 1 << PORTB5;

  TCCR2A = 0;
  TCCR2B = (1 << CS22) | (1 << CS21) | (1 << CS20);
  TIMSK2 = 1 << TOIE2;
  TCNT2 = 0;
}

ISR(TIMER2_OVF_vect) {
  PORTB = (1 << PORTB5) ^ PINB;
}  

void loop() {
}


