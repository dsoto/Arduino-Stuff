// used to interrogate temperature circuit
// using LM35 part with 10x AD823AN amplifier circuit
// voltage at temperatureInputPin is 
// V = 0.1*T
// where T is measured in celsius

const int temperatureInputPin = 0;
int dataPin      = 2;
int clockPin     = 3;
int highDataPin  = 4;
int highClockPin = 5;
const int delayMS = 500;

int temperatureInputValue = 0;  
float temperatureCelsius = 0;
float temperatureFahrenheit = 32;


int bits[] = {B1000000, B1111001, B0100100, B0110000, B0011001,
              B0010010, B0000010, B1111000, B0000000, B0011000};

void setup() {
  Serial.begin(9600);
  pinMode(clockPin, OUTPUT);
  pinMode(dataPin,  OUTPUT);
  pinMode(highDataPin, OUTPUT);
  pinMode(highClockPin, OUTPUT);
}


void writeSeg(int i) {
  shiftOut(dataPin, clockPin, MSBFIRST, bits[i]);  
}

void writeHighSeg(int i) {
  shiftOut(highDataPin, highClockPin, MSBFIRST, bits[i]);  
}

void writeDigit(int digit, int value) {
  if (digit == 0) {
    shiftOut(dataPin, clockPin, MSBFIRST, bits[value]);
  }
  if (digit == 1) {
    shiftOut(highDataPin, highClockPin, MSBFIRST, bits[value]);
  }
}

void loop() {
  int lowDigit;
  int highDigit;
  
  temperatureInputValue = analogRead(temperatureInputPin);            
  temperatureCelsius = 50.0 * temperatureInputValue / 1024;  
  temperatureFahrenheit = 9 * temperatureCelsius / 5 + 32;
  
  //Serial.print("raw temperature reading (0-1023) = " );                       
  //Serial.println(temperatureInputValue);      

  Serial.print("temperature in celsius    = ");
  Serial.println(temperatureCelsius);
  //delay(1000);                     
  Serial.print("temperature in fahrenheit = ");
  Serial.println(temperatureFahrenheit);
  delay(5000);
  
  lowDigit = int(temperatureFahrenheit) % 10;
  highDigit = int(temperatureFahrenheit) / 10;
  writeSeg(lowDigit);
  Serial.println(lowDigit);
  writeHighSeg(highDigit);  
  Serial.println(highDigit);
  
  delay(5000);
  
  lowDigit = int(temperatureCelsius) % 10;
  highDigit = int(temperatureCelsius) / 10;
  writeSeg(lowDigit);
  Serial.println(lowDigit);
  writeHighSeg(highDigit);  
  Serial.println(highDigit);
    
}
