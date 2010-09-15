#define BAUD 115200
#define NUM_SAMPLES 100

int samples[NUM_SAMPLES];
long int time[NUM_SAMPLES];

void setup() {
  Serial.begin(BAUD);
}

void sample() {
  Serial.println("Sampling");
  for (int i=0; i<NUM_SAMPLES; i++){
    time[i] = micros();
    samples[i] = digitalRead(0);
  }   
}

void writeSerial() {
  Serial.println("Writing");
  for (int i=0; i<NUM_SAMPLES; i++) {
    Serial.print(time[i]);
    Serial.print(",");
    Serial.print(samples[i]);
    Serial.print("\n");
  }
}

void loop() {
  if (Serial.available() > 0) {
    int inByte = Serial.read();
    switch (inByte) {
      case 's':
        sample();
        break;
      case 'w':
        writeSerial();
        break;
      default:
        Serial.println("Press s for sample");
        Serial.println("Press w for write");
    }
  }
}
