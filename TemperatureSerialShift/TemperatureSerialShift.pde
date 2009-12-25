// used to interrogate temperature circuit
// using LM35 part with 10x AD823AN amplifier circuit
// voltage at temperatureInputPin is 
// V = 0.1*T
// where T is measured in celsius

/* December 23, 2009 11:44:49 PM -0800
   starting to add code to interface with maxim 7219 led driver chip
*/

// need to declare clock and data pins according to SPI

const int temperatureInputPin = 0;
const int ledPin = 13;
const int dataPin      = 2;
const int clockPin     = 3;
const int loadPin      = 4;
const int delayMS      = 500;
//const boolean debug    = true;
const boolean debug    = false;

void setup() {
    byte data;
  if (debug) {
    Serial.begin(9600);
    }
  // set pin modes for serial communication
  pinMode(ledPin, OUTPUT);
  pinMode(dataPin, OUTPUT);
  pinMode(clockPin, OUTPUT);
  pinMode(loadPin, OUTPUT);
  writeBytes(0x09, 0xFF);
  writeBytes(0x0B, 0x02);
  writeBytes(0x0C, 0x01);
  writeBytes(0x0F, 0x00);
}


// i want to take a float and display it in three digits
// if it is a two digit number, this means with a decimal point
// but with a maximum of two decimal points
// i will send a float to a function and it will return
// 6 bytes to be written to the 7219 
void displayTemperature(float temperature) {
    int digitArray[3];
    int decimalPlace;
    parseTemperature(temperature, digitArray, &decimalPlace);
    if (debug) {
        Serial.print(digitArray[2]);
        Serial.print(digitArray[1]);
        Serial.print(digitArray[0]);
        Serial.println();
    }
    refreshDisplay(digitArray, &decimalPlace);
}

    
void parseTemperature(float temperature, int *digitArray, int *decimalPlace) {
//    int decimalPlace;
    
    if (debug) {
        Serial.println("parseTemperature entered");
        Serial.print("temperature passed = ");
        Serial.println(temperature);
    }
    if (temperature < 100) {
        temperature *= 10;
        *decimalPlace = 1;
        if (debug) {
            Serial.print("temperature * 10 = ");
            Serial.println(temperature);
        }
    } else {
        *decimalPlace = 0;
    }
    int displayNumber = int(temperature);
    if (debug) {
        Serial.print("displayNumber = ");
        Serial.println(displayNumber);
    }
    for (int i=0;i<3;i++) {
        digitArray[i] = displayNumber % 10;
        displayNumber /= 10;
    }

    if (debug) {
        Serial.print("display number = ");
        Serial.print(digitArray[2]);
        Serial.print(digitArray[1]);
        if (*decimalPlace == 1) Serial.print(".");
        Serial.print(digitArray[0]);
        Serial.println();
        Serial.println("exiting parseTemperature");
    }
}

void writeBytes(byte OPCODE, byte DATA) {
    digitalWrite(ledPin, HIGH);
    digitalWrite(loadPin, LOW);
    
    shiftOut(dataPin, clockPin, MSBFIRST, OPCODE);
    shiftOut(dataPin, clockPin, MSBFIRST, DATA);
    
    // rising edge on load latches data
    digitalWrite(loadPin, HIGH);
    digitalWrite(ledPin, LOW);

}
void refreshDisplay(int *digitArray, int *decimalPlace){

    if (debug) {
        Serial.println("entering refreshDisplay");        
        Serial.print(digitArray[2]);
        Serial.print(digitArray[1]);
        Serial.print(digitArray[0]);
        Serial.println();
    }
    //shiftOut(dataPin, clockPin, MSBFIRST, bits[i]);
    byte OP_1 = 1;
    byte OP_2 = 2;
    byte OP_3 = 3;

    
    byte DECIMAL_MASK = B10000000;
    
    if (*decimalPlace == 1) {
        digitArray[1] = digitArray[1] | DECIMAL_MASK;
    }
    
    writeBytes(OP_1, digitArray[0]);
    writeBytes(OP_2, digitArray[1]);
    writeBytes(OP_3, digitArray[2]);
}

void loop() {
    int   temperatureInputValue = 0;  
    float temperatureCelsius    = 0;
    float temperatureFahrenheit = 32;

    temperatureInputValue = analogRead(temperatureInputPin);            
    temperatureCelsius = 50.0 * temperatureInputValue / 1024;  
    temperatureFahrenheit = 9 * temperatureCelsius / 5 + 32;
    
    if (debug) {
        Serial.print("temperature in celsius    = ");
        Serial.println(temperatureCelsius);
        Serial.print("temperature in fahrenheit = ");
        Serial.println(temperatureFahrenheit);
    }
    displayTemperature(temperatureFahrenheit);
//    digitalWrite(ledPin, HIGH);
    delay(2000);
  //  digitalWrite(ledPin, LOW);
    displayTemperature(temperatureCelsius);
    delay(2000); 
  writeBytes(0x09, 0xFF);
  writeBytes(0x0B, 0x02);
  writeBytes(0x0C, 0x01);
  writeBytes(0x0F, 0x00);
    
 
    /*
    for (int i=0; i<1000; i++) {
        if (debug) {
            Serial.print(i);
            Serial.print(temperatureCelsius);
            Serial.println();
        }
        temperatureCelsius += 1.9;
        displayTemperature(temperatureCelsius);
        delay(500);
    }
    */
}
