#define BAUD_RATE 115200
#define telitPort Serial3
#define sheevaPort Serial2
#define debugPort Serial1
#define verbose 1

void setup(){
    Serial.begin(BAUD_RATE);
    Serial1.begin(BAUD_RATE);
    Serial2.begin(BAUD_RATE);
    Serial3.begin(BAUD_RATE);
}

void meter(String commandString) {
    debugPort.println("destination = meter");
    debugPort.println(commandString);
    debugPort.println();
}

void modem(String commandString) {
    debugPort.println("destination = modem");
    debugPort.println(commandString);
    debugPort.println();
    String modemString = getValueForKey("str", commandString);
    debugPort.println(modemString);
    telitPort.println(modemString);

}

String getValueForKey(String key, String commandString) {
    // this doesn't handle the case of the end of the string where
    // there is no trailing &
    // also doesn't handle the case of a modem string which has & in the string
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

String readSheevaPort() {
    char incomingByte = ';';    
    String commandString = "";
    while ((sheevaPort.available() > 0) || (incomingByte != ';')) {
        incomingByte = sheevaPort.read();
        if (incomingByte != -1) {        
            commandString += incomingByte;
        }
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

    if (verbose > 0) {
        debugPort.println("top of loop()");
        debugPort.println(millis());
    }
    
    String commandString;
    String destination;

    commandString = readSheevaPort();
    destination = getValueForKey("cmp", commandString);
    chooseDestination(destination, commandString);    

    delay(1000);
    
    
}
