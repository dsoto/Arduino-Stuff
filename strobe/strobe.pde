// Connect your LED to Ground and digital pin 13
// Connect the outer leads of your potentiometer to 5v and ground 
// Connect the middle lead of your potentiometer to analog in 2

int pot_pin = 2;
int led_pin = 13;

float pulse_time_usec = 100; 
float d_min = pulse_time_usec + 1000;
float d_max = 20000;
float strobe_period = 0;  
float frequency = 0;
int pin_val = 0;

void setup() {
    Serial.begin(115200);
    pinMode(led_pin, OUTPUT);
    pinMode(pot_pin, INPUT);
}

void loop() {
    pin_val = analogRead(pot_pin);
    //Serial.print(pin_val, DEC);
    //Serial.print(" ");
    
    strobe_period = (d_max - d_min)/1024 * pin_val + d_min;

    frequency = 1 / strobe_period * 1000000;
    
    digitalWrite(led_pin, HIGH);
    delayMicroseconds(pulse_time_usec);
    digitalWrite(led_pin, LOW);
    delayMicroseconds(strobe_period - pulse_time_usec);

    Serial.print(strobe_period,DEC);
    Serial.print(" ");
    Serial.print(frequency,DEC);
    Serial.print(" ");
    Serial.print(frequency*60,DEC);
    Serial.print(" ");
    //Serial.print(pin_val,DEC);
    Serial.print("\n");
}
