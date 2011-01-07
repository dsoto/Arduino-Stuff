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
    debugPort.println("entered void modem()");
    String text = getValueForKey("text", commandString);
    String phone = getValueForKey("phone", commandString);
    
    debugPort.print("phone number - ");
    debugPort.println(phone);
    debugPort.print("sms text - ");
    debugPort.println(text);

    // handle modem string here
    telitPort.print("AT+CMGS=");
    telitPort.print(phone);
    telitPort.print("\r\n");
    
    sheevaPort.println("fake modem response");

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

String readSheevaPort() {
    char incomingByte = ';';    
    String commandString = "";
    while ((sheevaPort.available() > 0) || ((incomingByte != ';') && (incomingByte != '\n'))) {
        incomingByte = sheevaPort.read();
        if (incomingByte != -1) {      
            if (verbose > 0) {
                debugPort.print(incomingByte);
            }
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
