#include <SPI.h>

const int slaveSelectPin = 10;
int readValue;

void setup() {
  pinMode (slaveSelectPin, OUTPUT);
  SPI.begin(); 
  SPI.setBitOrder(MSBFIRST);
  SPI.setDataMode(SPI_MODE3);
  Serial.begin(9600);
}

/* 
   first test is to write a series of values
   to the zero address in the first buffer
   and them read them out to verify.
*/
   
void loop() {
  Serial.println("top of loop()");
  for (int i=0; i<256; i++) {  

      Serial.print("write val: ");
      Serial.println(i);
  
      // set chip select low
      digitalWrite(slaveSelectPin, LOW);
      
      // write out buffer 1 write opcode 0x84
      SPI.transfer(0x84);
      
      // write out address
      SPI.transfer(0x00);
      SPI.transfer(0x00);
      SPI.transfer(0x00);
      
      // write out data
      SPI.transfer(i);
      
      // unselect chip
      digitalWrite(slaveSelectPin, HIGH);
            
      // set chip select low
      digitalWrite(slaveSelectPin, LOW);

      // write out buffer 1 read opcode 0xD4
      SPI.transfer(0xD4);
      
      // write out address
      SPI.transfer(0x00);
      SPI.transfer(0x00);
      SPI.transfer(0x00);
      
      // don't care byte to initiate read
      SPI.transfer(0x00);
      
      readValue = SPI.transfer(0x00);

      // unselect chip
      digitalWrite(slaveSelectPin, HIGH);
      
      Serial.print("read val: ");
      Serial.println(readValue);
      delay(1000);
      
  }      
}

