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
const int dataPin      = 2;
const int clockPin     = 3;
const int loadPin      = 4;
const int delayMS      = 500;
const byte OP_DECODE   = 0x09;
const byte OP_SCAN     = 0x0B;
const boolean debug    = false;

void setup() {
    byte data;
  Serial.begin(9600);
  // set pin modes for serial communication
  // send initialization data to max7219 
  writeBytes(OP_DECODE, data);
  writeBytes(OP_SCAN, data);
}


// i want to take a float and display it in three digits
// if it is a two digit number, this means with a decimal point
// but with a maximum of two decimal points
// i will send a float to a function and it will return
// 6 bytes to be written to the 7219 
void displayTemperature(float temperature) {
    int digitArray[4];
    int decimalPlace;
    parseTemperature(temperature, digitArray, decimalPlace);
    if (debug) {
        Serial.print(digitArray[2]);
        Serial.print(digitArray[1]);
        Serial.print(digitArray[0]);
        Serial.println();
    }
    refreshDisplay(digitArray, decimalPlace);
}

    
void parseTemperature(float temperature, int *digitArray, int decimalPlace) {
//    int decimalPlace;
    
    if (debug) {
        Serial.println("parseTemperature entered");
        Serial.print("temperature passed = ");
        Serial.println(temperature);
    }
    if (temperature < 100) {
        temperature *= 10;
        decimalPlace = 1;
        if (debug) {
            Serial.print("temperature * 10 = ");
            Serial.println(temperature);
        }
    } else {
        decimalPlace = 0;
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

    if (1) {
        Serial.print("display number = ");
        Serial.print(digitArray[2]);
        Serial.print(digitArray[1]);
        if (decimalPlace == 1) Serial.print(".");
        Serial.print(digitArray[0]);
        Serial.println();
        Serial.println("exiting parseTemperature");
    }
}

void writeBytes(int OPCODE, int DATA) {
    // pull LOAD high?
    // shift out both bytes
    // pull LOAD low?
}
void refreshDisplay(int *digitArray, int decimalPlace){

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
    
    if (decimalPlace == 1) {
        // bitwise and with ones place
        }
    
    //write OP_1, digitArray[0]
    // write OP_2, digitArray[1]
    //write OP_3, digitArray[2]
}

void loop() {
    int   temperatureInputValue = 0;  
    float temperatureCelsius    = 0;
    float temperatureFahrenheit = 32;
    /*
    temperatureInputValue = analogRead(temperatureInputPin);            
    temperatureCelsius = 50.0 * temperatureInputValue / 1024;  
    temperatureFahrenheit = 9 * temperatureCelsius / 5 + 32;
    
    Serial.print("temperature in celsius    = ");
    Serial.println(temperatureCelsius);
    Serial.print("temperature in fahrenheit = ");
    Serial.println(temperatureFahrenheit);
    
    displayTemperature(temperatureFahrenheit);
    delay(5000);
    displayTemperature(temperatureCelsius);
    delay(5000); 
    */
    
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
}
