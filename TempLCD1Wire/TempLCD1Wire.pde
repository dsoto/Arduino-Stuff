#include <LiquidCrystal.h>
#include <OneWire.h>
#include <DallasTemperature.h>
#include <Wire.h>
#include "RTClib.h"

#define ONE_WIRE_BUS 9
#define nBoxcar 10
OneWire oneWire(ONE_WIRE_BUS);
DallasTemperature sensors(&oneWire);
LiquidCrystal lcd(8, 7, 6, 5, 4, 3);
RTC_DS1307 RTC;

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
float boxcarCelsius[nBoxcar];
int i = 0;

// array/object to hold device address
DeviceAddress insideThermometer;

void setup(void) {
    Serial.begin(115200);
    lcd.createChar(0, degreeGlyph);
    lcd.begin(16,2);
    Wire.begin();
    RTC.begin();
    RTC.adjust(DateTime(__DATE__, __TIME__));
    
    sensors.begin();
    sensors.getAddress(insideThermometer, 0);
    sensors.setResolution(insideThermometer, 9);
}

void printTemperature(DeviceAddress deviceAddress) {
    float tempC = sensors.getTempC(deviceAddress);
    i++;
    if (i == nBoxcar) i = 0; 
    boxcarCelsius[i] = tempC;
    tempC = 0;
    for (int j = 0; j < nBoxcar; j++) {
        tempC += boxcarCelsius[j] / nBoxcar;
    }
    lcd.setCursor(1, 0);
    lcdPrintDouble(tempC, 1);
    lcd.write(0);
    lcd.print("C  ");
    lcdPrintDouble(DallasTemperature::toFahrenheit(tempC), 1);
    lcd.write(0);
    lcd.print("F");
}

void printDate() {
    lcd.setCursor(2,1);
    DateTime now = RTC.now();
    lcdPrintPadded(now.month(), 2);
    lcd.print("/");
    lcdPrintPadded(now.day(), 2);
    lcd.print("  ");
    lcdPrintPadded(now.hour(), 2);
    lcd.print(":");
    lcdPrintPadded(now.minute(), 2);
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

void lcdPrintPadded(int val, int digits) {
    if (val <= 9) lcd.print("0");
    lcd.print(val,DEC);
}

void loop(void) {
  sensors.requestTemperatures();
  printTemperature(insideThermometer);
  printDate();
  delay(1000);
}
