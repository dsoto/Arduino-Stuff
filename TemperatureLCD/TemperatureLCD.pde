// used to interrogate temperature circuit
// using LM35 part with 10x AD823AN amplifier circuit
// voltage at temperatureInputPin is 
// V = 0.1*T
// where T is measured in celsius

#include <LiquidCrystal.h>
#include <avr/sleep.h>
#include <avr/wdt.h>

// define pins here with names
LiquidCrystal lcd(3, 4, 5, 6, 7, 8, 9);

// using timer 1 to control interval of temperature samples
// delay() must use timer 1 and messes up my settings
// so after calling lcd. functions i reset the timer 1 settings

const int temperatureInputPin = 0;
const int pinLed = 13;
//const boolean debug    = true;
const boolean debug    =true;
const boolean LCD = true;
const int nBoxcar = 10;
float boxcarCelsius[nBoxcar];
int i = 0;
volatile boolean f_wdt = 1;


void setup() {
  if (debug) {
    Serial.begin(9600);
  }
  if (LCD) lcd.begin(16,1);  

  pinMode(pinLed,OUTPUT);

  // SMCR - Sleep Mode Control Register
  SMCR = (1 << SM1) | (1 << SE);
  MCUSR &= ~(1 << WDRF);

  // start timed sequence
  // you must make the other bit changes within 4 clock cycles
  WDTCSR |= (1 << WDCE) | (1 << WDE);

  // set new watchdog timeout value
  WDTCSR = (1 << WDIE) | (1 << WDCE) | (1 << WDP2) | (1 << WDP1) | (1 << WDP0);

}

ISR(WDT_vect) {
  f_wdt = 1;
}

void system_sleep() {
  // ADCSRA - ADC control and status register A
  ADCSRA &= ~(1 << ADEN);

  set_sleep_mode(SLEEP_MODE_PWR_DOWN); // sleep mode is set here
  sleep_enable();

  sleep_mode();                        // System sleeps here

  sleep_disable();                     // System continues execution here when watchdog timed out 
  ADCSRA |= (1 << ADEN);
}

void loop() {
  if (f_wdt == 1) {  // wait for timed out watchdog / flag is set when a watchdog timeout occurs
    f_wdt = 0;       // reset flag
    digitalWrite(pinLed,!digitalRead(pinLed));  // let led blink
//    delay(10);
//    digitalWrite(pinLed,0);
    system_sleep();

  digitalWrite(pinLed, !digitalRead(pinLed));
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
  }
    
}


