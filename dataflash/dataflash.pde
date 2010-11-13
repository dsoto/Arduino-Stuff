#include <SPI.h>

const int slaveSelectPin = 10;
uint8_t readValue;


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
    for (uint8_t i=0; i<256; i++) {  
    
        Serial.print("write val: ");
        Serial.println(i);
        
        writeBuffer(i, i);
        
        // read out 8 bytes of flash
        for (uint16_t j=0; j<16; j++) {
               readValue = readBuffer(lowByte(j));
          Serial.println(readValue, DEC);       
        }
        
        delay(2000);
    }      
            delay(10000);

}

void bufferErase(){
    for (uint16_t i=0; i<512; i++) {
        writeBuffer(i,0x00);
    }
}

void writeBuffer(uint8_t address, uint8_t value) {
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

byte readBuffer(uint8_t address){
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

