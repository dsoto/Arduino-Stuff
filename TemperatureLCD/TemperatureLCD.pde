// used to interrogate temperature circuit
// using LM35 part with 10x AD823AN amplifier circuit
// voltage at temperatureInputPin is 
// V = 0.1*T
// where T is measured in celsius

/* December 23, 2009 11:44:49 PM -0800
 starting to add code to interface with maxim 7219 led driver chip
 */

// need to declare clock and data pins according to SPI
#include <LiquidCrystal.h>

LiquidCrystal lcd(3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13);


const int temperatureInputPin = 0;
//const boolean debug    = true;
const boolean debug    = false;

void setup() {
  if (debug) {
    Serial.begin(9600);
  }
  lcd.begin(16,1);  
}

int nBoxcar = 10;
float boxcarCelsius[10];
int i=0;

void loop() {
  int   temperatureInputValue = 0;  
  float temperatureCelsius    = 0;
  float temperatureFahrenheit = 32;

  
  temperatureInputValue = analogRead(temperatureInputPin);            
  temperatureCelsius = 500.0 * temperatureInputValue / 1024;  
  boxcarCelsius[i] = temperatureCelsius;
  temperatureCelsius = 0;
  for (int j=0;j<nBoxcar;j++) {
    temperatureCelsius += boxcarCelsius[j]/nBoxcar;
  }
  if (i==nBoxcar) {
    i=0;
  } else {
    i++;
  }
  //temperatureCelsius = 500.0 * temperatureInputValue / 1024;  

  temperatureFahrenheit = 9 * temperatureCelsius / 5 + 32;

  

  if (debug) {
    Serial.print("temperature in celsius    = ");
    Serial.println(temperatureCelsius);
    Serial.print("temperature in fahrenheit = ");
    Serial.println(temperatureFahrenheit);
  }
  
  lcd.setCursor(0,0);
  lcd.print(temperatureCelsius);
  lcd.print("C ");
  lcd.print(temperatureFahrenheit);
  lcd.print("F");
  delay(500);
  lcd.print("                ");  
  
}

