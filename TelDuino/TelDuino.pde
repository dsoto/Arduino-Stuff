void setup(){
    Serial.begin(115200);
    Serial1.begin(115200);
    Serial2.begin(115200);
    Serial3.begin(115200);
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
    Serial1.print("cmp=mdm&str=command_string");

    String commandString = readSerial2();    
    // send data only when you receive data:
    
    int equalsIndex = commandString.indexOf("cmp=");
    int ampersandIndex = commandString.indexOf("&");
    
    String destination = commandString.substring(equalsIndex + 4, ampersandIndex);

    chooseDestination(destination, commandString);    


    
    delay(1000);
}
