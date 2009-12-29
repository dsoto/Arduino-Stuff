// LED play
// Daniel Soto

int ledPin =  9;
int brightness;
int command;

void setup() {                
  Serial.begin(9600);
  pinMode(ledPin, OUTPUT);    
}

void loop() {
  
  if (Serial.available()) {
    command = Serial.read();
    Serial.print(command, DEC);
    Serial.print("  ");
    brightness = map(command,0,127,0,255);
    analogWrite(ledPin, brightness);
    Serial.println(brightness,DEC);
  }
}

