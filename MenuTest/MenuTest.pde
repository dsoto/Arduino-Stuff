byte inByte;

void setup()
{
  // start serial port at 9600 bps:
  Serial.begin(115200);
      mainMenu();

}

void mainMenu()
{
  Serial.println("one");
   Serial.println("two");
  Serial.println("three");
 Serial.println("four"); 
}

void oneMenu()
{
  Serial.println("one.one");
   Serial.println("one.two");
  Serial.println("one.three");
 Serial.println("one.four"); 
}  

void loop()
{
    while (!Serial.available() > 0) {
      //mainMenu();
    }
    inByte = Serial.read();
    switch (inByte){  
    case '1':
oneMenu;
break;
default:
  mainMenu();
 break; 
}
}
