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


void loop() {
  bufferErase();
  Serial.println("top of loop()");
  for (int i=0; i<256; i++) {  

      Serial.print("write val: ");
      Serial.println(i);
  
      writeBuffer(i, i);
      
      // read out 8 bytes of flash
      for (int j=0; j<16; j++) {
               readValue = readBuffer(j);
          Serial.println(readValue);       
      }
      
      delay(2000);
      
  }      
}

void bufferErase(){
  for (int i=0; i<256; i++) {
    writeBuffer(i,0x00);
  }
}

void writeBuffer(byte address, byte value) {
      // set chip select low
      digitalWrite(slaveSelectPin, LOW);
      
      // write out buffer 1 write opcode 0x84
      SPI.transfer(0x84);
      
      // write out address
      SPI.transfer(0x00);
      SPI.transfer(0x00);
      SPI.transfer(address);
      
      // write out data
      SPI.transfer(value);
      
      // unselect chip
      digitalWrite(slaveSelectPin, HIGH);  
}

byte readBuffer(byte address){
      // set chip select low
      digitalWrite(slaveSelectPin, LOW);

      // write out buffer 1 read opcode 0xD4
      SPI.transfer(0xD4);
      
      // write out address
      SPI.transfer(0x00);
      SPI.transfer(0x00);
      //SPI.transfer(0x00);
      SPI.transfer(address);
      
      // don't care byte to initiate read
      SPI.transfer(0x00);
      
      readValue = SPI.transfer(0x00);

      // unselect chip
      digitalWrite(slaveSelectPin, HIGH);
      
      return readValue;
  
}

