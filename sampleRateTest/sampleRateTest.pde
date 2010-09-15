#define BAUD 115200
#define ECHO_TO_SERIAL 0

#include <Wire.h>
#include <Fat16.h>
#include <Fat16util.h> 

SdCard card;
Fat16 file;

void setup() {
  Serial.begin(BAUD);
  Wire.begin();
  
  card.init();
  Fat16::init(&card);
  
  // create a new file
  char name[] = "LOGGER00.CSV";
  for (uint8_t i = 0; i < 100; i++) {
    name[6] = i/10 + '0';
    name[7] = i%10 + '0';
    // O_CREAT - create the file if it does not exist
    // O_EXCL - fail if the file exists
    // O_WRITE - open for write only
    if (file.open(name, O_CREAT | O_EXCL | O_WRITE))break;
  }
  file.writeError = false;
}

void loop() {

  if (Serial.available() > 0) {
    Serial.read();

  for (int i=0; i<100; i++){
    int sensorValue = digitalRead(0);
    #if ECHO_TO_SERIAL
    Serial.print(micros());
    Serial.print(",");
    Serial.print(sensorValue, DEC);
    Serial.print("\n");
    #endif 
    file.print(micros());
    file.print(",");
    file.print(sensorValue);
    file.println();
    }
  file.sync();
  }
}
