#include <LiquidCrystal.h>

// using sparkfun protoshield as LCD shield

// lcd functions (rs, enable, d4, d5, d6, d7)
// lcd pins      ( 4,      6, 11, 12, 13, 14)
// lcd pin 1       -> ground
// lcd pin 2       -> +5V
// lcd pin 3 (Vo)  -> ground
// lcd pin 5 (R/W) -> ground
LiquidCrystal lcd(7, 6, 5, 4, 3, 2);

long int i = 0;
int  count = 1;

void setup() {
  pinMode(12, INPUT);
}

void loop() {
  // on button press JC1 goes low
  // JC1 is connected to pin 12

  // toggle count boolean
  if (digitalRead(12) == LOW) {
    count = 0;
  } else {
    count = 1;
  }
  
  // print out value of i
  lcd.setCursor(0, 0);
  lcd.print(i);
  if (count) {
    i += 1;
  }
  
}
