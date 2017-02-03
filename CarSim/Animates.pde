
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
              maxVelocity =  100;  //cm par second
              
  float heading = 0,
        velocity = 0,
        pos[] = {0,0},
        steeringAngle = 0;

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
  
  void velocitySet(float a){
    velocity = max(-maxVelocity,min(a,maxVelocity));
  }
  void velocityInc(float inc){
    velocitySet(inc+velocity);
  }
  
  void update(float dt){
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
    shape(s, 0,-dyFrontAxel,wid,len);
    pushMatrix();
    rotate(steeringAngle);
    fa.display();
    popMatrix();
    ra.display();
    popMatrix();
  }
  void displayParams(){
    int x = 10,
        y = 20,
        dy = 15;
    pushMatrix();
    pushStyle();
    fill(Defaults.green);
    translate(x,y);
    text("Velocity:\t" + round(velocity),0,0);
    translate(0,dy);
    text("Heading:\t" + round(formatHeading(degrees(heading))),0,0);
    translate(0,dy);
    text("Position:\t" + round(pos[0]) + ", " + round(pos[1]),0,0);
    translate(0,dy);
    text("Steering Angle:\t" + round(degrees(steeringAngle)%360),0,0);
    translate(0,dy);
    text("Click the window, then use the Arrow keys, 's', 'p' and 'r' to control the car!",0,0);
    
    popStyle();
    popMatrix();
  }
}

float formatHeading(float h){
  float res = h %360;
  return res<0 ? 360 + res : res;
}

class LongTail{
  final float targetWidth = 10;
  float coords[][] =  new float[Defaults.tailLength][2];
  int nbCoords = 0;
  
  LongTail(){}
  
  void update(float xVal, float yVal){
    for (int i=Defaults.tailLength-1;i>0;i--){
      coords[i][0]=coords[i-1][0];
      coords[i][1]=coords[i-1][1];
    }
    coords[0][0]=xVal;
    coords[0][1]=yVal;
    nbCoords=min(Defaults.tailLength,++nbCoords);
  }
  void display (){
    pushStyle();
    fill(Defaults.targetColor);
    stroke(Defaults.targetColor);
    ellipseMode(CENTER);
    for (int i=1;i<nbCoords;i++){
      ellipse(coords[i][0],coords[i][1],targetWidth/(0.9*(i+1)),targetWidth/(0.9*(i+1)));
    }
    popStyle();
  }
}