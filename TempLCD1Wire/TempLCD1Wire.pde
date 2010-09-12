#include <LiquidCrystal.h>
#include <OneWire.h>
#include <DallasTemperature.h>

#define ONE_WIRE_BUS 9
OneWire oneWire(ONE_WIRE_BUS);
DallasTemperature sensors(&oneWire);
LiquidCrystal lcd(8, 7, 6, 5, 4, 3);

byte degreeGlyph[8] = {
  B01100,
  B10010,  
  B10010,
  B01100,
  B00000,
  B00000,
  B00000,
  B00000
};

// arrays to hold device address
DeviceAddress insideThermometer;

void setup(void) {
  lcd.createChar(0, degreeGlyph);
  lcd.begin(16,2);
  sensors.begin();
  sensors.getAddress(insideThermometer, 0);
  sensors.setResolution(insideThermometer, 9);
}

// function to print the temperature for a device
void printTemperature(DeviceAddress deviceAddress) {
  float tempC = sensors.getTempC(deviceAddress);
  lcd.setCursor(1, 0);
  lcdPrintDouble(tempC, 1);
  lcd.write(0);
  lcd.print("C  ");
  lcdPrintDouble(DallasTemperature::toFahrenheit(tempC), 1);
  lcd.write(0);
  lcd.print("F");
}

void lcdPrintDouble( double val, byte precision) {
  if(val < 0.0) {
    lcd.print('-');
    val = -val;
  }

  lcd.print (int(val));  //prints the int part
  if( precision > 0) {
    lcd.print("."); // print the decimal point
    unsigned long frac;
    unsigned long mult = 1;
    byte padding = precision - 1;
    while (precision--) mult *= 10;

    if(val >= 0)
       frac = (val - int(val)) * mult;
    else
       frac = (int(val) - val) * mult;
    unsigned long frac1 = frac;
    while (frac1 /= 10) padding--;
    while (padding--) lcd.print("0");
    lcd.print(frac, DEC) ;
  }
}

void loop(void) { 
  sensors.requestTemperatures(); // Send the command to get temperatures
  printTemperature(insideThermometer); // Use a simple function to print out the data
}

