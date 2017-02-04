
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
              maxSteeringAngularVelocity = radians(10),  // radians par dt
              maxVelocity =  100;  //cm par second
              
  float heading = 0,
        velocity = 0,
        pos[] = {0,0},
        steeringAngle = 0,
        steeringAngularVelocity = 0;

  final color carColor = Defaults.red;
  
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
    velocity = max(-maxVelocity,min(a,maxVelocity));
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
  }
  
  void displayParams(){
    int x = 10,
        y = 20,
        dy = 15;
    pushMatrix();
    pushStyle();
    fill(Defaults.blue);
    translate(x,y);
    text("Velocity:\t" + round(velocity),0,0);
    translate(0,dy);
    text("Heading:\t" + round(formatHeading(degrees(heading))),0,0);
    translate(0,dy);
    text("Position:\t" + round(pos[0]) + ", " + round(pos[1]),0,0);
    translate(0,dy);
    text("Steering Angle:\t" + round(degrees(steeringAngle)%360),0,0);
    translate(0,dy);
    pushStyle();
    if (!g_steerAngle){
      fill(Defaults.green);
    }
    text("Steering Angular Velocity:\t" + nf(degrees(steeringAngularVelocity),0,2),0,0);
    popStyle();
    translate(0,dy);
    text("Steering power:\t" + round(degrees(g_sInc)),0,0);
    translate(0,dy);
    text("Click the window, then use the Arrow keys and",0,0);
    translate(0,dy);
    text("'s' : Steer Straight",0,0);
    translate(0,dy);
    text("'p' : Pause",0,0);
    translate(0,dy);
    text("'r' : Reset",0,0);
    translate(0,dy);
    text("'x/c' : dec/inc Steering Power",0,0);
    translate(0,dy);
    text("'a' : toggle angular velocity steering",0,0);
    popStyle();
    popMatrix();
  }
}

float formatHeading(float h){
  float res = h %360;
  return res<0 ? 360 + res : res;
}