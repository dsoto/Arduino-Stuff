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
    // serial stuff
    Serial.begin(115200);
    // lcd stuff
    lcd.createChar(0, degreeGlyph);
    lcd.begin(16,2);
    // I2C stuff
    Wire.begin();
    // real time clock stuff
    RTC.begin();
    RTC.adjust(DateTime(__DATE__, __TIME__));
    // temp sensor stuff
    sensors.begin();
    sensors.getAddress(insideThermometer, 0);
    sensors.setResolution(insideThermometer, 9);
}

void printTemperature(DeviceAddress deviceAddress) {
    float tempC = sensors.getTempC(deviceAddress);
    // increment index on boxcar
    i++;
    if (i == nBoxcar) i = 0;
    boxcarCelsius[i] = tempC;
    // average over boxcar array
    tempC = 0;
    for (int j = 0; j < nBoxcar; j++) {
        tempC += boxcarCelsius[j] / nBoxcar;
    }
    // print to lcd
    lcd.setCursor(1, 0);
    lcdPrintTemp(tempC);
    lcd.write(0);
    lcd.print("C  ");
    lcdPrintTemp(DallasTemperature::toFahrenheit(tempC));
    lcd.write(0);
    lcd.print("F");
}

void lcdPrintDate() {
    lcd.setCursor(2,1);
    DateTime now = RTC.now();
    lcdPrintPadded(now.month());
    lcd.print("/");
    lcdPrintPadded(now.day());
    lcd.print("  ");
    lcdPrintPadded(now.hour());
    lcd.print(":");
    lcdPrintPadded(now.minute());
}

// prints double with 1 decimal place
void lcdPrintTemp(double val) {
    // print integer part
    lcd.print(int(val));
    lcd.print(".");
    // subtract off integer
    val = val - int(val);
    // multiply by ten, truncate, and print
    val = val * 10;
    lcd.print(int(val));
}

// prints integer with leading zero if necessary
void lcdPrintPadded(int val) {
    if (val <= 9) lcd.print("0");
    lcd.print(val,DEC);
}

void loop(void) {
  sensors.requestTemperatures();
  printTemperature(insideThermometer);
  lcdPrintDate();
  delay(1000);
}
