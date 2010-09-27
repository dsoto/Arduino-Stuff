#include "WProgram.h"
void main(){
  // this init() is part of the arduino setup
  init();
  pinMode(8, OUTPUT);

while(1){
  digitalWrite(8, HIGH);   // set the LED on
  delay(1000);              // wait for a second
  digitalWrite(8, LOW);    // set the LED off
  delay(1000);              // wait for a second
 }
}
