
#define BAUD 115200

void setup() {
  Serial.begin(BAUD);
}

void loop() {
  if (Serial.available() > 0) {
    Serial.read();
    /*
    Serial.print("<writing at ");
    Serial.print(BAUD, DEC);
    Serial.println(" baud rate>");
    */
  for (int i=0; i<100; i++){
    int sensorValue = analogRead(0);
    //sensorValue = analogRead(1);
    Serial.print(millis());
    //Serial.print(",");
    //Serial.print(sensorValue, DEC);
    Serial.print("\n");
    }
  }
}
