
class Wheel{
  final float w = Defaults.wheelWidth,
              h = Defaults.wheelHeight,
              pos[] = {0,0};
              
  Wheel(float x, float y){
    pos[0] = x;
    pos[1] = y;
  }
  
  void display(){
    pushStyle();
    stroke(Defaults.wheelColor);
    fill(Defaults.wheelColor);
    rectMode(CENTER);
    rect(pos[0],pos[1],w,h);
    popStyle();
  }
}

class Axel{
  final float w = Defaults.axelWidth,
              wt = 4,
              pos[] = {0,0};
              
  Axel(float x, float y){
    pos[0] = x-w/2.0;
    pos[1] = y;
  }
  
  void display(){
    pushStyle();
    stroke(Defaults.wheelColor);
    strokeWeight(wt);
    fill(Defaults.wheelColor);
    line(pos[0],pos[1],pos[0]+w,pos[1]);
    popStyle();
  }
}

class DriveAxel{
  Wheel wl, wr;
  Axel a;
  
  DriveAxel(float x, float y){
    // x,y are center of horizontal axel
    a = new Axel(x,y);
    wl = new Wheel(a.pos[0],y);
    wr = new Wheel(a.pos[0] + a.w,y);
  }
  
  void display(){
    wl.display();
    a.display();
    wr.display();
  }   
}   
  
     
class Car{
  DriveAxel fa, ra;
  PShape s;
  
  final float len = Defaults.carHieght,
              wid = Defaults.carWidth,
              dyFrontAxel = -0.255 * len,
              dyRearAxel = (13.25/15.0)* len + dyFrontAxel,
              dxCenterLine = -0.5 * wid,
              B = dyRearAxel,
              maxSteeringAngle = radians(25),  
              maxVelocity =  1000;  //mm par second
              
  float     maxSteeringAngularVelocity = radians(0.01);  // radians par dt
  
  float heading = 0,
        velocity = 0,
        pos[] = {0,0},
        steeringAngle = 0,
        steeringAngularVelocity = 0;

  final color carColor = Defaults.red;
  
  float steeringError = 0,   // in pixels!
        maxSteeringError = 0,
        minSteeringError = 0;
  
  Car(float x, float y, float theta){
    pos[0] = x;
    pos[1] = y;
    heading = theta;
    fa = new DriveAxel(0,0);
    ra = new DriveAxel(0,B);
    if (ISJS){
      s = loadShape("CarSim/data/CarBodyLongerFilled.svg");
    }
    else{
      s = loadShape("CarBodyLongerFilled.svg");
    }
  }
  
  void steeringAngleSet(float a){
    steeringAngle = max(-maxSteeringAngle,min(a,maxSteeringAngle));
  }
  void steeringAngleInc(float inc){
    steeringAngleSet(inc+steeringAngle);
  }
  void steeringAngularVelocitySet(float a){
    steeringAngularVelocity = max(-maxSteeringAngularVelocity,min(a,maxSteeringAngularVelocity));
  }
  void steeringAngularVelocityInc(float inc){
    steeringAngularVelocitySet(inc+steeringAngularVelocity);
  }
  void velocitySet(float a){
    velocity = a; //max(-maxVelocity,min(a,maxVelocity));
  }
  void velocityInc(float inc){
    velocitySet(inc+velocity);
  }
  
  void update(float dt){
    // update steering angle
    steeringAngleInc(steeringAngularVelocity*dt);
    final float R = B/abs(sin(steeringAngle)),
                dc = velocity * dt,
                dx = dc * sin(steeringAngle+heading),
                dy = -dc * cos(steeringAngle+heading),
                dTheta = dc/R;
    heading += dTheta*(steeringAngle == 0 ? 1 :steeringAngle/abs(steeringAngle));
    pos[0] += dx;
    pos[1] += dy; 
  }
  
  void display(){
    pushMatrix();
    translate(pos[0],pos[1]);
    rotate(heading);
    shapeMode(CENTER);
    displaySensor();
    shape(s, 0,-dyFrontAxel,wid,len);
    pushMatrix();
    rotate(steeringAngle);
    fa.display();
    popMatrix();
    ra.display();
    popMatrix();
  }
  
  void displaySensor(){
    pushStyle();
    strokeWeight(2);
    stroke(Defaults.targetColor);
    
    displaySensorIntercepts();
    line(-Defaults.sensorHalfWidth,0,Defaults.sensorHalfWidth,0);
    popStyle();
  }
  
  void displaySensorIntercepts(){
    int li = -Defaults.sensorInterceptLimit,
        ri =  Defaults.sensorInterceptLimit;
    for (int i = 0;i<Defaults.sensorInterceptLimit; i++){
      float ang = heading-HALF_PI;
      int x = round(pos[0] - i*sin(ang)),
          y = round(pos[1] + i*cos(ang));
      color c = get(x,y);      
      if(c != color(0)){
        ri = i;
        break;
      }
    }
    for (int i = 0;i>-Defaults.sensorInterceptLimit; i--){
      float ang = heading-HALF_PI;
      int x = round(pos[0] - i*sin(ang)),
          y = round(pos[1] + i*cos(ang));
      color c = get(x,y);      
      if(c != color(0)){
        li = i;
        break;
      } 
    }
    pushStyle();
    stroke(Defaults.green);
    strokeWeight(4);
    line(li,-Defaults.sensorInterceptHalfLength,li,Defaults.sensorInterceptHalfLength);
    line(ri,-Defaults.sensorInterceptHalfLength,ri,Defaults.sensorInterceptHalfLength);
    popStyle();
    steeringError =li+ri;
    maxSteeringError = max(maxSteeringError,(9.0*maxSteeringError+(steeringError*100.0/Defaults.trackAvailableDrivingWidth))/10.0);
    minSteeringError = min(minSteeringError,(9.0*minSteeringError+(steeringError*100.0/Defaults.trackAvailableDrivingWidth))/10.0);
    
    }
  
  void displayParams(boolean steerAngle){
    int x = 10,
        nbLines = 13,
        y = height - nbLines *20,
        dy = 15;
        
    pushMatrix();
    pushStyle();
    fill(Defaults.blue);
    translate(x,y);
    text("FrameRate : \t" +round(frameRate),0,0);
    translate(0,dy);
    text("Velocity : \t" + round(velocity),0,0);
    translate(0,dy);
    text("Heading : \t" + round(formatHeading(degrees(heading))),0,0);
    translate(0,dy);
    text("Position : \t" + round(pos[0]) + ", " + round(pos[1]),0,0);
    translate(0,dy);
    text("Steering Angle : \t" + round(degrees(steeringAngle)%360),0,0);
    translate(0,dy);
    pushStyle();
    if (!steerAngle){
      fill(Defaults.green);
    }
    text("Steering Angular Velocity : \t" + nf(degrees(steeringAngularVelocity),0,2),0,0);
    popStyle();
    translate(0,dy);
    text("Steering power : \t" + round(degrees(app.sInc)),0,0);
    translate(0,dy);
    text("Steering error Range (%) : \t" + "[" + nf(minSteeringError,1,1) + ", " + nf(maxSteeringError,1,1) + "]",0,0);
    translate(0,dy);
    text("Click the window, then use the Arrow keys and",0,0);
    translate(0,dy);
    text("'S' : Steer Straight",0,0);
    translate(0,dy);
    text("'P' : Pause",0,0);
    translate(0,dy);
    text("'R' : Reset",0,0);
    translate(0,dy);
    text("'X/C' : dec/inc Steering Power",0,0);
    translate(0,dy);
    text("'A' : toggle angular velocity steering",0,0);
    translate(0,dy);
    text("'D' : save current PID parameters as defaults",0,0);
    translate(0,dy);
    pushStyle();
    if (app.manualSteering){
      fill(Defaults.green);
    }text("'M' : toggle manual steering",0,0);
    translate(0,dy);
    text("Mouse Click to change tracks",0,0);
    popStyle();
    popStyle();
    popMatrix();
  }
}

float formatHeading(float h){
  float res = h %360;
  return res<0 ? 360 + res : res;
}