#include <LiquidCrystal.h>

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

void setup() {
  Serial.begin(9600);
  pinMode(2, INPUT);
  attachInterrupt(0, changeCount, FALLING);
}

void changeCount() {
  //delay(10);
  buttonVal = digitalRead(2);
  if  (buttonVal == HIGH) Serial.print("high\n");
  if (buttonVal == LOW) {
    Serial.print("low\n");
    count = !count;  
  }
  //delay(10);
}
void loop() {
  // on button press JC1 goes low
  // JC1 is connected to pin 12

  // toggle count boolean
  
  // print out value of i
  lcd.setCursor(0, 0);
  lcd.print(i);
  delay(100);
  if (count) {
    i += 1;
    Serial.print(i,DEC);
    Serial.print("\n");
  }
  
}
