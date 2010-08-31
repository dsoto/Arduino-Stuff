#include <LiquidCrystal.h>
#include <String.h>
// using sparkfun protoshield as LCD shield

// lcd functions (rs, enable, d4, d5, d6, d7)
// lcd pins      ( 4,      6, 11, 12, 13, 14)
// lcd pin 1       -> ground
// lcd pin 2       -> +5V
// lcd pin 3 (Vo)  -> ground
// lcd pin 5 (R/W) -> ground

//LiquidCrystal lcd(7, 6, 5, 4, 3, 2);
LiquidCrystal lcd(8, 7, 6, 5, 4, 3);

long int i = 0;
volatile int count = HIGH;
int buttonVal = 0;
int numDigits = 0;


void setup() {
  Serial.begin(9600);

  // on button press JC1 goes low
  // JC1 is connected to pin 2
  pinMode(2, INPUT);

  // interrupt attached to pin 2 (interrupt 0)
  attachInterrupt(0, changeCount, CHANGE);

  // Setup 1 Hz timer to refresh display using 16 Timer 1
  // CTC mode (interrupt after timer reaches OCR1A)
  TCCR1A = 0;
  // CTC & clock div 1024
  TCCR1B = _BV(WGM12) | _BV(CS10) | _BV(CS12);
  //OCR1A = 15609;                                 // 16mhz / 1024 / 15609 = 1 Hz
  OCR1A = 1561;
  TIMSK1 = _BV(OCIE1A);                          // turn on interrupt
}

void changeCount() {
  static unsigned long lastInterruptTime = 0;
  unsigned long interruptTime = millis();

  if (interruptTime - lastInterruptTime > 50) {
    if (digitalRead(2) == LOW) {
    count = !count;
    }
  }
  lastInterruptTime = interruptTime;
}

ISR(TIMER1_COMPA_vect) {
  if (count) i += 1; else i-=1;
  lcd.clear();
  lcd.print(i);
}

void loop() {
  //if (count) i += 1; else i-=1;
}
