import android.view.MotionEvent;
import android.os.Bundle;
import android.content.Intent;

import oscP5.*;

import ketai.net.bluetooth.*;
import ketai.ui.*;
import ketai.net.*;


////////////////// Comms stuff ///////////////////////
KetaiGesture gesture;

// needed here because it is initiliazed in android activity onCreate()...
KetaiBluetooth bt;

App app;

final String theDeviceName = "Linvor2";

////////////////// end of comms stuff ///////////////////////

final float displayFactor = 0.5,
            nexusWidth = 768,
            nexusHeight = 1280;
            
final int screenW = round(nexusWidth*displayFactor),
          screenH = round(nexusHeight*displayFactor);

final color black = #000000,
            white = #FFFFFF,
            red   = #FF0000,
            green = #00FF00,
            blue  = #0000FF;
            
final int screenTextSize = 36,
          androidTextSize = 72;

void settings(){
  fullScreen();
  orientation(PORTRAIT);
}

AngleControl ac;
SpeedControl sc ;

void setup(){
  gesture = new KetaiGesture(this);
  app = new App(theDeviceName,bt,this);

  ac = new AngleControl(30,width/2.0,height/2.0);
  ac.currentAngle = radians(0);
  sc =  new SpeedControl(1000,width,height/2.0);
  
  textSize(androidTextSize);
}

void draw(){
  app.draw();
  background(black);
  ac.display();
  sc.display();
}
  
void   doOsc(){
  sendSpeedAndAngleViaOsc(sc.currentSpeed,ac.currentAngle);
}

void mousePressed(){
  if (mouseY > ac.y){
    scMouse();
  }
  else{
    ac.update(mouseX,mouseY);
  }
  doOsc();
}

void mouseDragged(){
  if (mouseY > ac.y){
    scMouse();
  }
  else{
    ac.update(mouseX,mouseY);
  }
  doOsc();
}
void scMouse(){
  sc.update(mouseX<= width/2.0 ? 1 :  -1);
}