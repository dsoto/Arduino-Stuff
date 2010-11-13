#include <SPI.h>

const int slaveSelectPin = 10;
uint8_t readValue;
char response;
uint32_t timeSample;

void setup() {
    pinMode (slaveSelectPin, OUTPUT);
    SPI.begin(); 
    SPI.setBitOrder(MSBFIRST);
    SPI.setDataMode(SPI_MODE3);
    Serial.begin(9600);
    bufferErase();    
}

void loop() {
    Serial.println("top of loop()");
    for (uint16_t i=0; i<128; i+=4) { 
        timeSample = millis();
    
        Serial.print("write val: ");
        Serial.println(timeSample, HEX);
        
        writeBuffer(i,   lowByte(timeSample >> 24));
        writeBuffer(i+1, lowByte(timeSample >> 16));
        writeBuffer(i+2, lowByte(timeSample >>  8));
        writeBuffer(i+3, lowByte(timeSample >>  0));
                
        if (Serial.available()) {
            response = Serial.read();
        }
        if (response == 'r') {
            printBufferToSerial();
            delay(10000);
        }        
        delay(1000);
    }      
}

void printBufferToSerial() {
    response = 'a';
    // read out 8 bytes of flash
    for (uint16_t j=0; j<128; j+=4) {
        // fixme: do this with a loop
        readValue = readBuffer(j);
        printByteToSerial(readValue);
        readValue = readBuffer(j+1);
        printByteToSerial(readValue);
        readValue = readBuffer(j+2);
        printByteToSerial(readValue);
        readValue = readBuffer(j+3);
        printByteToSerial(readValue);
        Serial.println();
    }
}

void printByteToSerial(uint8_t val) {
    uint8_t lowNibble = 0x0F & val;
    uint8_t highNibble = (0xF0 & val) >> 4;
    Serial.print(highNibble, HEX);
    Serial.print(lowNibble, HEX);
}

void bufferErase() {
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

byte readBuffer(uint8_t address) {
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

// ISR routine
// store millis()
// write 16 bytes to buffer
// increment address pointer
