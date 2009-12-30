// LED play
// Daniel Soto


void setup()   {
  DDRB = 1 << DDB5;
}

void loop() {
  PORTB = 1 << PORTB5;
  delay(1000);
  PORTB = 0;
  delay(1000);
}


