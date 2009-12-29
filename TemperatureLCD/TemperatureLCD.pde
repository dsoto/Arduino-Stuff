// used to interrogate temperature circuit
// using LM35 part with 10x AD823AN amplifier circuit
// voltage at temperatureInputPin is 
// V = 0.1*T
// where T is measured in celsius

#include <LiquidCrystal.h>

// define pins here with names
LiquidCrystal lcd(3, 4, 5, 6, 7, 8, 9);

// using timer 1 to control interval of temperature samples
// delay() must use timer 1 and messes up my settings
// so after calling lcd. functions i reset the timer 1 settings

const int temperatureInputPin = 0;
const int ledPin = 13;
//const boolean debug    = true;
const boolean debug    =true;
const boolean LCD = true;
const int nBoxcar = 10;
float boxcarCelsius[nBoxcar];
int i = 0;


void setup() {
  if (debug) {
    Serial.begin(9600);
  }
  if (LCD) lcd.begin(16,1);  

  // setup timer 1
  TCCR1A = 0;  
  TCCR1B = 1 << CS12 | 1 << CS10;  //1024
  TIMSK1 = 1 << TOIE1;
  TCNT1L = 0;
  TCNT1H = 0;
  
  // setup timer 2
  TCCR2A = 0;
  TCCR2B = 1 << CS22 | 1 << CS21 | 1 << CS20;
  TIMSK2 = 1 << TOIE2;
  TCNT2 = 0;
}

ISR(TIMER2_OVF_vect) {
  digitalWrite(ledPin, !digitalRead(ledPin));
  int   temperatureInputValue = 0;  
  float temperatureCelsius    = 0;
  float temperatureFahrenheit = 32;

  temperatureInputValue = analogRead(temperatureInputPin);            
  temperatureCelsius = 50.0 * temperatureInputValue / 1024;  
  boxcarCelsius[i] = temperatureCelsius;
  temperatureCelsius = 0;
  for (int j = 0; j < nBoxcar; j++) {
    temperatureCelsius += boxcarCelsius[j] / nBoxcar;
  }
  if (i == nBoxcar) {
    i = 0;
  } 
  else {
    i++;
  }
  temperatureFahrenheit = 9 * temperatureCelsius / 5 + 32;

  if (debug) {
    Serial.print("temperature in celsius    = ");
    Serial.println(temperatureCelsius);
    Serial.print("temperature in fahrenheit = ");
    Serial.println(temperatureFahrenheit);
  }

  if (LCD) {
  lcd.setCursor(2,0);
  //lcd.print("                ");  
  lcd.print(temperatureCelsius);
  lcd.print("C  ");
  lcd.print(temperatureFahrenheit);
  lcd.print("F");
  }
  // setup timer 1
   TCCR1A = 0;  
  TCCR1B = 1 << CS12 | 1 << CS10;  //1024
  TIMSK1 = 1 << TOIE1;
  TCNT1L = 0;
  TCNT1H = 0;

  TCCR2A = 0;
  TCCR2B = 1 << CS22 | 1 << CS21 | 1 << CS20;
  TIMSK2 = 1 << TOIE2;
  TCNT2 = 0;
 
}

void loop() {
/*  int   temperatureInputValue = 0;  
  float temperatureCelsius    = 0;
  float temperatureFahrenheit = 32;

  temperatureInputValue = analogRead(temperatureInputPin);            
  temperatureCelsius = 50.0 * temperatureInputValue / 1024;  
  boxcarCelsius[i] = temperatureCelsius;
  temperatureCelsius = 0;
  for (int j = 0; j < nBoxcar; j++) {
    temperatureCelsius += boxcarCelsius[j] / nBoxcar;
  }
  if (i == nBoxcar) {
    i = 0;
  } 
  else {
    i++;
  }
  temperatureFahrenheit = 9 * temperatureCelsius / 5 + 32;

  if (debug) {
    Serial.print("temperature in celsius    = ");
    Serial.println(temperatureCelsius);
    Serial.print("temperature in fahrenheit = ");
    Serial.println(temperatureFahrenheit);
  }

  lcd.setCursor(2,0);
  lcd.print(temperatureCelsius);
  lcd.print("C  ");
  lcd.print(temperatureFahrenheit);
  lcd.print("F");
  delay(500);
  lcd.print("                ");  
*/
}


