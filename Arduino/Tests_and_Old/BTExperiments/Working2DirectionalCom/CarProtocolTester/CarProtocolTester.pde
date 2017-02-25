/* A proper Car Protocol Tester!
 * 2107 02 25 17:35 works with arduino: 
*/

import android.os.Bundle;
import android.content.Intent;

import ketai.net.bluetooth.*;
import ketai.ui.*;
import ketai.net.*;

// needed here because it is initiliazed in android activity onCreate()...
KetaiBluetooth bt;

App app;

final String theDeviceName = "Linvor2";

final int textS= 36,
          bg = 130;

public void settings(){
  fullScreen();
  orientation(LANDSCAPE);
}

void setup(){     
  background(bg);
  textSize(textS);
  textAlign(CENTER);
  app = new App(theDeviceName,bt,this);
}

void draw(){
 app.draw();
}

public void keyPressed() {
  app.keyPressed();
}