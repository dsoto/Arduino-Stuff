/*
 MIDI note player
 
 This sketch shows how to use the serial transmit pin (pin 1) to send MIDI note data.
 If this circuit is connected to a MIDI synth, it will play 
 the notes F#-0 (0x1E) to F#-5 (0x5A) in sequence.
 
 
 The circuit:
 * digital in 1 connected to MIDI jack pin 5
 * MIDI jack pin 2 connected to ground
 * MIDI jack pin 4 connected to +5V through 220-ohm resistor
 Attach a MIDI cable to the jack, then to a MIDI synth, and play music.
 
 created 13 Jun 2006
 modified 2 Jul 2009
 by Tom Igoe 
 
 http://www.arduino.cc/en/Tutorial/MIDI
 
 */
const int kickPin = 11;  // The switch is on Arduino pin 10
const int snarePin = 10;
const int LEDpin = 13;     //  Indicator LED
const int debounceTime = 50;
// Variables: 
byte kickNote = 0x35;              // The MIDI note value to be played F2
byte snareNote = 0x2F;
int lastKickState = 0;    // state of the switch during previous time through the main loop
int currentKickState = 0;

int lastSnareState = 0;    // state of the switch during previous time through the main loop
int currentSnareState = 0;

void setup() {
  //  set the states of the I/O pins:
  pinMode(kickPin, INPUT);
  pinMode(snarePin, INPUT);
  pinMode(LEDpin, OUTPUT);
  //  Set MIDI baud rate:
  Serial.begin(31250);
}

void loop() {
  currentSnareState = digitalRead(snarePin);
  // Check to see that the snare is pressed:
  if (currentSnareState != lastSnareState) {
    // chill for debounce time
    delay(debounceTime);
    currentSnareState = digitalRead(snarePin);

    if (currentSnareState == 0 && lastSnareState == 1) {
      noteOn(0x90, snareNote, 0x40);
      digitalWrite(LEDpin, HIGH);
    }
    if (currentSnareState == 1 && lastSnareState ==0) {   // if the snare is not pressed:
      noteOn(0x90, snareNote, 0x00);
      digitalWrite(LEDpin, LOW);
    }
    lastSnareState = currentSnareState;
  }

  currentKickState = digitalRead(kickPin);
  if (currentKickState != lastKickState) {
    // chill for debounce time
    delay(debounceTime);
    currentKickState = digitalRead(kickPin);

    currentKickState = digitalRead(kickPin);
    // Check to see that the kick is pressed:
    if (currentKickState == 0 && lastKickState == 1) {
      noteOn(0x90, kickNote, 0x40);
      digitalWrite(LEDpin, HIGH);
    }
    if (currentKickState == 1 && lastKickState ==0) {   // if the kick is not pressed:
      noteOn(0x90, kickNote, 0x00);
      digitalWrite(LEDpin, LOW);
    }
    lastKickState = currentKickState;

  }
}

//  plays a MIDI note.  Doesn't check to see that
//  cmd is greater than 127, or that data values are  less than 127:
void noteOn(int cmd, int pitch, int velocity) {
  Serial.print(cmd, BYTE);
  Serial.print(pitch, BYTE);
  Serial.print(velocity, BYTE);
}


