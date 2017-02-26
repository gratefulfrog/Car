#include <SoftwareSerial.h>  

const int bluetoothTx = 2;  // TX-O pin of bluetooth mate, Arduino D2
const int bluetoothRx = 3;  // RX-I pin of bluetooth mate, Arduino D3

SoftwareSerial bluetooth(bluetoothTx, bluetoothRx);

const int LED= 13;

void setup(){
  Serial.begin(9600);
  bluetooth.begin(9600);  
  pinMode(LED,OUTPUT);
}

void doChar(char c){
  switch(c){
    case '1':
      digitalWrite(LED, HIGH);
      Serial.println("LED: ON");
      break;
    case '0':
      digitalWrite(LED, LOW);
      Serial.println("LED: OFF");
      break;
    default:
      Serial.print("Unexeptect character received: ");
      Serial.println(c);
      break;
  }
} 
    
void loop(){
   if(bluetooth.available()>0)  {
    char cb = bluetooth.read();
    doChar(cb);
  }
}

