/* Android Comms Tester
 * at last something that works!!!
 */

import android.os.Bundle;
import android.content.Intent;
//import android.view.KeyEvent;

import ketai.net.bluetooth.*;
import ketai.ui.*;
import ketai.net.*;

KetaiBluetooth bt;

String incoming = "",
       outgoing = "";
       
boolean isConfiguring = true;
int textS= 48;
String btName = "linvor2",
       adr = "00:13:03:27:05:41";
int bogus = -60,
    maxIn = 19;

//********************************************************************
// The following code is required to enable bluetooth at startup.
//********************************************************************
void onCreate(Bundle savedInstanceState) {
  super.onCreate(savedInstanceState);
  bt = new KetaiBluetooth(this);
}

void onActivityResult(int requestCode, int resultCode, Intent data) {
  bt.onActivityResult(requestCode, resultCode, data);
}
//********************************************************************

public void settings(){
  fullScreen();
  orientation(LANDSCAPE);
}

void setup(){     
  background(130);
  textSize(textS);
  textAlign(CENTER);

  bt.start();
  // for debugging
  println(bt.getPairedDeviceNames());
}

void draw(){
    if (bogus<0){
      text("Connecting to " + btName +"...",width/2,textS);  // will be overwritten by background()...
      bogus++;
    }
    else {
      if (isConfiguring){
      //isConfiguring = !bt.connectToDeviceByName(btName);    
      isConfiguring =  bt.connectDevice(adr);  // stupid code !!
      if (!isConfiguring){
        println("connected!"); 
        delay(1000);
      }
    }
    background(130);
    if (!isConfiguring){  // we're connected!
      
      KetaiKeyboard.show(this);
      //KetaiKeyboard.toggle(this);
      text("Sent: " + outgoing,width/2,textS);
      text("Received: " + incoming,width/2,2*textS);
      text("type 5 digits or 'ENTER' to send; or 'x' to exit",width/2,4*textS);
      if (bogus > 0){
        text("I said, '5 digits, 'x' or ENTER'! Pay Attention!",width/2,5*textS);
        bogus--;
      }
    }   
  }
}

//Call back method to manage data received
void onBluetoothDataEvent(String who, byte[] data)
{
  if (isConfiguring)
    return;
  if(incoming.length()> maxIn){
     incoming = "";
  }
  for (int i=0;i<data.length;i++){
    incoming += char(data[i]);
  }
}

public void keyPressed() {
  if (isConfiguring){
    return;
  }
  if (key >='0' && key <= '9') {
    //out += key;
    outgoing += key;  
    bogus=0;
  }
  else if (keyCode == android.view.KeyEvent.KEYCODE_ENTER){
    if (outgoing.length() % 5 == 0) {
      //bt.broadcast(str2bytes(outgoing));
      //bt.writeToDeviceName(btName, str2bytes(outgoing));
      bt.write(adr, str2bytes(outgoing));
      outgoing = "";
      bogus=0;
    }
    else{
      bogus = 1000;
      return;
    }  
  }
  else if (key == 'x'){
    bogus=0;
    bt.stop();
    System.exit(0);
  }
  else  {
    bogus = 1000;
    return;
  }
}

byte[] str2bytes(String s){
  byte b[] = new byte[s.length()];
  for (int i=0;i<s.length();i++){
    b[i] = byte(s.charAt(i));
  }
  return b;
}