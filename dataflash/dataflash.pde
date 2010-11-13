#include <SPI.h>

const int slaveSelectPin = 10;
uint8_t readValue;
char response;
uint16_t timeSample;

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
    for (uint16_t i=0; i<256; i+=2) { 
        timeSample = millis();
    
        Serial.print("write val: ");
        Serial.println(timeSample, HEX);
        
        writeBuffer(i, highByte(timeSample));
        writeBuffer(i+1, lowByte(timeSample));
        
        if (Serial.available()) {
            response = Serial.read();
        }
        if (response == 'r') {
            response = 'a';
            // read out 8 bytes of flash
            for (uint16_t j=0; j<16; j+=2) {
                readValue = readBuffer(j);
                Serial.print(readValue, HEX);       
                readValue = readBuffer(j+1);
                Serial.println(readValue, HEX);       
            }
        }        
        delay(2000);
    }      
    delay(10000);
}

void bufferErase(){
    for (uint16_t i=0; i<512; i++) {
        writeBuffer(i, 0x00);
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

