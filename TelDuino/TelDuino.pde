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
    
    debugPort.println();
    debugPort.println("starting telduino service");
    debugPort.println();
}

void meter(String commandString) {
    String job = getValueForKey("job", commandString);
    String cid = getValueForKey("cid", commandString);

    if (verbose > 0) {
        debugPort.println();
        debugPort.println("entered void meter()");
        debugPort.print("executing job type - ");
        debugPort.println(job);
        debugPort.print("on circuit id - ");
        debugPort.println(cid);
        debugPort.println();
    }
    
    sheevaPort.println("fake meter response");
    
    //delay(1000);
}

void modem(String commandString) {
    String smsText = getSMSText(commandString);
    String phone = getValueForKey("phone", commandString);

    if (verbose > 0) {
        debugPort.println();
        debugPort.println("entered void modem()");
        debugPort.print("phone number - ");
        debugPort.println(phone);
        debugPort.print("sms text - ");
        debugPort.println(smsText);
        debugPort.println();
    }

    // handle modem string here
    telitPort.print("AT+CMGS=");
    telitPort.print(phone);
    telitPort.print("\r\n");
    telitPort.print(smsText);
    telitPort.print("\r\n");
    
    sheevaPort.println("fake modem response");
    
    //delay(1000);

}

String getSMSText(String commandString) {
    int firstQuoteIndex = commandString.indexOf('"');
    int secondQuoteIndex = commandString.indexOf('"', firstQuoteIndex + 1);
    String smsText = commandString.substring(firstQuoteIndex + 1, secondQuoteIndex);
    return smsText;
}

String getValueForKey(String key, String commandString) {
    // this doesn't handle the case of the end of the string where
    // there is no trailing &
    // also doesn't handle the case of a modem string which has & in the string
    int keyIndex = commandString.indexOf(key);
    int valIndex = keyIndex + key.length() + 1;
    int ampersandIndex = commandString.indexOf("&",valIndex);
    // if ampersand not found, go until end of string
    if (ampersandIndex == -1) {
        ampersandIndex = commandString.length();
    }
    String val = commandString.substring(valIndex, ampersandIndex);
    return val;
}

String readSheevaPort() {
    char incomingByte = ';';    
    String commandString = "";
    while ((sheevaPort.available() > 0) || ((incomingByte != ';') && (incomingByte != '\n'))) {
        incomingByte = sheevaPort.read();
        if (incomingByte != -1) {      
            if (verbose > 1) {
                debugPort.print(incomingByte);
            }
            commandString += incomingByte;
        }
        if (incomingByte == ';') {
            commandString = commandString.substring(0, commandString.length() - 1);
            break;
        }
    }   
    commandString = commandString.trim();
    return commandString;
}

String readTelitPort() {
    char incomingByte = '\n';
    String commandString = "";
    while ((telitPort.available() > 0) || (incomingByte != '\n')) {
        incomingByte = telitPort.read();
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

    if (verbose > 1) {
        debugPort.println("top of loop()");
        debugPort.println(millis());
    }
    
    String commandString;
    String destination;

    commandString = readSheevaPort();
    destination = getValueForKey("cmp", commandString);
    chooseDestination(destination, commandString);    

    String modemString = "";
    modemString = readTelitPort();
    modemString = modemString.trim();
    if (modemString.length() != 0) {
        String responseString = "";
        responseString += "cmp=mdm&text=";
        responseString += '"';
        responseString += modemString;
        responseString += '"';
        sheevaPort.println(responseString);
        
        debugPort.println("string received from telit");
        debugPort.println(modemString);
    }
    
    
}
