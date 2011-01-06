#define BAUD_RATE 115200

void setup(){
    Serial.begin(BAUD_RATE);
    Serial1.begin(BAUD_RATE);
    Serial2.begin(BAUD_RATE);
    Serial3.begin(BAUD_RATE);
}

void meter(String commandString) {
    Serial2.println("destination = meter");
    Serial2.println(commandString);
    Serial2.println();
}

void modem(String commandString) {
    Serial2.println("destination = modem");
    Serial2.println(commandString);
    Serial2.println();
}

String getValueForKey(String key, String commandString) {
    int keyIndex = commandString.indexOf(key);
    int valIndex = keyIndex + key.length() + 1;
    int ampersandIndex = commandString.indexOf("&",valIndex);
    String val = commandString.substring(valIndex, ampersandIndex);
    return val;
}

String getDestination(String commandString) {
    int equalsIndex = commandString.indexOf("cmp=");
    int ampersandIndex = commandString.indexOf("&");
    String destination = commandString.substring(equalsIndex + 4, ampersandIndex);
    return destination;
}

String readSerial2() {
    char incomingByte;    
    String commandString = "";
    while (Serial2.available() > 0) {
        incomingByte = Serial2.read();
        commandString += incomingByte;
    }    
    return commandString;
}

void chooseDestination(String destination, String commandString) {
    if (destination == "mtr") {
        meter(commandString);
    }
    else if (destination == "mdm") {
        modem(commandString);
    }
}

void loop() {

    String commandString;
    String destination;
    
    Serial1.print("cmp=mdm&str=command_string");
    commandString = readSerial2();    
    destination = getValueForKey("cmp", commandString);
    chooseDestination(destination, commandString);    

    delay(1000);
    Serial1.print(millis());
    
    Serial1.print("cmp=mtr&str=command_string");
    commandString = readSerial2();    
    destination = getValueForKey("cmp", commandString);
    chooseDestination(destination, commandString);    

    delay(1000);
    Serial1.print(millis());
    
}
