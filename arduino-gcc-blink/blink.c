#include "Wiring.h"
void main(){
  pinMode(13, OUTPUT);
while(1){
  digitalWrite(13, HIGH);   // set the LED on
  delay(1000);              // wait for a second
  digitalWrite(13, LOW);    // set the LED off
  delay(1000);              // wait for a second
 }
}
