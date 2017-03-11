  /**
 * Simple Write. 
 * 
 * Check if the mouse is over a rectangle and writes the status to the serial port.
 * using an OSC message and SLIP.
 * This example works with Arduino program ReceivOSCSerial below in comments.
 */

import java.nio.ByteBuffer;
import processing.serial.*;
import oscP5.*;

// Serial & OSC Stuff
final int END = 0300;
final int ESC = 0333;
final int ESC_END = 0334;
final int ESC_ESC = 0335;  


Serial device;


void setup() {
  size(200, 200);
  String portName = Serial.list()[0];
  println("connecting Serial to port: ", portName);
  device = new Serial(this, portName, 115200);
}

boolean sent1 =false,
        sent0 = false;

void draw() {
  background(255);
  // If mouse is over square, and last sent was not 1
  if (mouseOverRect() == true && !sent1){
    fill(204);
    println("sending: 1");
    OscMessage myMessage = new OscMessage("/led");
    myMessage.add(1);
    myMessage.print();
    sendSLIP(myMessage.getBytes());
    sent1 = true;
    sent0 = false;
  } 
  // else If mouse is NOT over square, and last sent was not 0
  else if (mouseOverRect() == false && !sent0) {    
    fill(0);
    println("sending: 0");
    OscMessage myMessage = new OscMessage("/led");
    myMessage.add(0);
    myMessage.print();
    sendSLIP(myMessage.getBytes());
    sent0=true;
    sent1=false;
  }
  rect(50, 50, 100, 100);         // Draw a square
}

boolean mouseOverRect() { // Test if mouse is over square
  return ((mouseX >= 50) && (mouseX <= 150) && (mouseY >= 50) && (mouseY <= 150));
}
// magical SLIP to Serial converter!
void sendSLIP(byte[] packet) { 
  device.write(END);
  for (int i=0; i<packet.length; i++) {
    switch (packet[i]) {
      case (byte)END:
        device.write(ESC);
        device.write(ESC_END);
        break;
      case (byte)ESC:
        device.write(ESC);
        device.write(ESC_ESC);
        break;
      default:
        device.write(packet[i]);
        //println(packet[i]);        
    }
  }
  device.write(END);
}

/*  Arduino Code to receive these messages!
// ReceiveOSCSerial
// Set the LED according to incoming OSC control
// tested with Processing program SimpleOSCWriteToSerial
//
#include <Arduino.h>

#include <OSCMessage.h>
#include <SLIPEncodedSerial.h>

SLIPEncodedSerial SLIPSerial(Serial);

void LEDcontrol(OSCMessage &msg){
  digitalWrite(13, msg.getInt(0));
}

void flashLed(int n){
  for (int i=0;i<n;i++){
      digitalWrite(13,HIGH);
      delay(50);
      digitalWrite(13,LOW);
      delay(50);
    }  
    digitalWrite(13,HIGH);
    delay(1000);
    digitalWrite(13,LOW);
}

void setup() {
  pinMode(13, OUTPUT);
  SLIPSerial.begin(115200);
  while(!Serial);
  flashLed(3);  // to indicate ready!
}

//reads and dispatches the incoming message
void loop(){ 
  OSCMessage msgIN;
  int size;
  while(!SLIPSerial.endofPacket()){
    if( (size =SLIPSerial.available()) > 0){
        while(size--)
          msgIN.fill(SLIPSerial.read());
    }
  }
  
  if(!msgIN.hasError()){
    msgIN.dispatch("/led", LEDcontrol);
  }
}
*/