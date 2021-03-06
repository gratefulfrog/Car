class Car{
  DriveAxel fa, ra;
  PShape s;
  
  boolean inMiddle = false;
  
  final float len = Defaults.carHieght,
              wid = Defaults.carWidth,
              dyFrontAxel = -0.255 * len,
              dyRearAxel = (13.25/15.0)* len + dyFrontAxel,
              dxCenterLine = -0.5 * wid,
              B = dyRearAxel,
              maxSteeringAngle = radians(30),  
              maxVelocity =  1000;  //mm par second
              
  float     maxSteeringAngularVelocity = radians(150);  // radians par dt
  
  float heading = 0,
        velocity = 0,
        pos[] = {0,0},
        steeringAngle = 0,
        steeringAngularVelocity = 0;

  final color carColor = Defaults.red;
  
  float steeringError = 0,   // in pixels!
        maxSteeringError = 0,
        minSteeringError = 0;
  float maxSetSteeringAngularVelocity = 0,  // in percent of max per app.DeltaT
        minSetSteeringAngularVelocity = 0;
  
  float maxSetSteeringAngle = 0,  // in  percent of max per app.DeltaT
        minSetSteeringAngle = 0;
        
  final int nbSensors = 2;
  int li[] = new int[nbSensors],
      ri[] = new int[nbSensors];
      
  PidSteeringMode currentMode;
  int currentModeID = 0;
  
  float lastKp[], 
        lastKi[], 
        lastKd[]; 
        
  int jumpStatus = -1;
  
  float intoJumpVelocity,
        jumpInitX,
        jumpInitY;
  boolean jumping = false;
  
  Car(float x, float y, float theta, PidDefaults pd){
    pos[0] = x;
    pos[1] = y;
    heading = theta;
    fa = new DriveAxel(0,0);
    ra = new DriveAxel(0,B);
    if (ISJS){
      s = loadShape("CarSimA/data/CarBodyLongerFilled.svg");
    }
    else{
      s = loadShape("CarBodyLongerFilled.svg");
    }
    lastKp = new float[PidDefaults.nbPIDs];
    lastKi = new float[PidDefaults.nbPIDs];
    lastKd = new float[PidDefaults.nbPIDs];
    
    for (int i=0;i<PidDefaults.nbPIDs;i++){
      lastKp[i] = pd.Kp[i];
      lastKi[i] = pd.Ki[i];
      lastKd[i] = pd.Kd[i];
    }
    currentModeID=0;
    currentMode = //mode[currentModeID];
                  new PidSteeringMode(0,  // setpoint
                               pd.Kp[0],
                               pd.Ki[0],  
                               pd.Kd[0],
                               0);
  }
  
  void steeringAngleSet(float a){
    steeringAngle = max(-maxSteeringAngle,min(a,maxSteeringAngle));
    float pct = 100.0*(steeringAngle/maxSteeringAngle);
    minSetSteeringAngle = min(minSetSteeringAngle,pct);
    maxSetSteeringAngle = max(maxSetSteeringAngle,pct);
  }
  void steeringAngleInc(float inc){
    steeringAngleSet(inc+steeringAngle);
  }
  void steeringAngularVelocitySet(float a){
    steeringAngularVelocity = max(-maxSteeringAngularVelocity,min(a,maxSteeringAngularVelocity));
    float pct = 100.0*(steeringAngularVelocity/maxSteeringAngularVelocity);
    minSetSteeringAngularVelocity = min(minSetSteeringAngularVelocity,pct);
    maxSetSteeringAngularVelocity = max(maxSetSteeringAngularVelocity,pct);
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
  void updateSteeringMode(unsigned long dt){  // time in ms
    // only executed in automatic steering mode!
    // note that the delta needs to be recomputed before calling the PID!
    if(jumpStatus ==0){  // accelleration!!
      intoJumpVelocity = jumping ? intoJumpVelocity : velocity;
      velocitySet(Defaults.JumpSpeed);
      jumping = true;
    }
    if (jumpStatus == 2){  // the eagle has landed, go back to normal speed!
      velocitySet(intoJumpVelocity);
      jumping = false;
    }
    if(jumpStatus == 1){  // POP! we are airborne!
      steeringAngularVelocitySet(0);
      steeringAngleSet(0);
      // no steering during the air time!
      return;
    }
    
    if (inMiddle) {
      if (currentMode.modeID != 1){
        lastKp[0] = currentMode.controller.Kp.get();
        lastKi[0] = currentMode.controller.Ki.get();
        lastKd[0] = currentMode.controller.Kd.get();
        currentMode.controller.Kp.set(lastKp[1]); 
        currentMode.controller.Ki.set(lastKi[1]); 
        currentMode.controller.Kd.set(lastKd[1]);  
        currentMode.modeID = 1;
      }
    }
    else{
      if (currentMode.modeID != 0){
        lastKp[1] = currentMode.controller.Kp.get();
        lastKi[1] = currentMode.controller.Ki.get();
        lastKd[1] = currentMode.controller.Kd.get();
        currentMode.controller.Kp.set(lastKp[0]); 
        currentMode.controller.Ki.set(lastKi[0]); 
        currentMode.controller.Kd.set(lastKd[0]);
        currentMode.modeID = 0;
      }
    }
    if (!app.steerAngle){
      steeringAngularVelocitySet(currentMode.controller.update(-steeringError,dt));
    }
    else{
      steeringAngleSet(currentMode.controller.update(-steeringError,dt));
    }
  }
  
  void display(){
    detectJump();
    
    pushStyle();
    pushMatrix();
    translate(pos[0],pos[1]);
    rotate(heading);
    shapeMode(CENTER);
    if (jumpStatus != 1){
      displaySensor(0);
      displaySensor(1);
    }
    shape(s, 0,-dyFrontAxel,wid,len);
    pushMatrix();
    rotate(steeringAngle);
    fa.display();
    popMatrix();
    ra.display();
    popMatrix();
    popStyle();
  }
  
  void displaySensor(int  id){
    float y = id *B;
    pushStyle();
    strokeWeight(2);
    stroke(Defaults.targetColor);
    displaySensorIntercepts(id);
    line(-Defaults.sensorHalfWidth,y,Defaults.sensorHalfWidth,y);
    popStyle();
  }
  
  void displaySensorIntercepts(int id){
    float ang = heading-HALF_PI;
    float yOffset = id * B;
    float pX = pos[0] - yOffset*cos(ang),
          pY = pos[1] - yOffset*sin(ang);
    li[id] = -Defaults.sensorInterceptLimit;
    ri[id] = Defaults.sensorInterceptLimit;
    
    for (int i = 0;i<Defaults.sensorInterceptLimit; i++){
      int x = round(pX - i*sin(ang)),
          y = round(pY + i*cos(ang));
      color c = get(x,y);      
      //if(c != color(0)){
      if(c == color(255)){
          ri[id] = i;
        break;
      }
    }
    for (int i = 0;i>-Defaults.sensorInterceptLimit; i--){
      int x = round(pX - i*sin(ang)),
          y = round(pY + i*cos(ang));
      color c = get(x,y);      
      //if(c != color(0)){
      if(c == color(255)){
        li[id] = i;
        break;
      } 
    }
    pushStyle();
    stroke(Defaults.green);
    strokeWeight(4);
    line(li[id],yOffset-Defaults.sensorInterceptHalfLength,li[id],yOffset+Defaults.sensorInterceptHalfLength);
    line(ri[id],yOffset-Defaults.sensorInterceptHalfLength,ri[id],yOffset+Defaults.sensorInterceptHalfLength);
    popStyle();
    if (id ==0){
      steeringError = li[id]+ri[id];
      inMiddle = abs(steeringError) <= Defaults.trackerMiddleEpsilon;
      maxSteeringError = max(maxSteeringError,steeringError*100.0/Defaults.trackAvailableDrivingWidth);
      minSteeringError = min(minSteeringError,steeringError*100.0/Defaults.trackAvailableDrivingWidth);
    }
    else if (id==1){ // second sensor
      steeringError = inMiddle ? atan2(B,ri[1]-ri[0]) : steeringError;
    }
  }
  
  void displayParams(boolean steerAngle){
    int x = 10,
        nbLines = 15,
        y = height - nbLines *20,
        dy = 15;
        
    pushMatrix();
    pushStyle();
    fill(Defaults.blue);
    translate(x,y);
    showJumpStatus();
    translate(0,dy);
    text("FrameRate : \t" +round(frameRate),0,0);
    translate(0,dy);
    text("In Middle : \t" + inMiddle,0,0);
    translate(0,dy);
    text("Velocity : \t" + round(velocity),0,0);
    translate(0,dy);
    text("Heading : \t" + round(formatHeading(degrees(heading))),0,0);
    translate(0,dy);
    text("Position : \t" + round(pos[0]) + ", " + round(pos[1]),0,0);
    translate(0,dy);
    text("Steering Angle Range : \t" +  "[" +  nf(minSetSteeringAngle,1,1) + "," + nf(maxSetSteeringAngle,1,1) + "]" ,0,0);
    translate(0,dy);
    pushStyle();
    if (!steerAngle){
      fill(Defaults.green);
    }
    text("Steering Angular Velocity range (%) : \t" + "[" +  nf(minSetSteeringAngularVelocity,1,1) + "," + nf(maxSetSteeringAngularVelocity,1,1) + "]" ,0,0);
    popStyle();
    translate(0,dy);
    text("Steering power : \t" + round(degrees(app.sInc)),0,0);
    translate(0,dy);
    text("Steering error Range (%) : \t" + "[" + nf(minSteeringError,1,1) + ", " + nf(maxSteeringError,1,1) + "]",0,0);
    translate(0,dy);
    text("Click the window, then use the Arrow keys and",0,0);
    translate(0,dy);
    text("'A' : toggle angular velocity steering",0,0);
    translate(0,dy);
    text("'D' : save current PID parameters as defaults",0,0);
    translate(0,dy);
    pushStyle();
    if (app.manualSteering){
      fill(Defaults.green);
    }
    text("'M' : toggle manual steering",0,0);
    popStyle();
    translate(0,dy);
    text("'P' : Pause",0,0);
    translate(0,dy);
    text("'R' : Reset",0,0);
    translate(0,dy);
    text("'S' : Steer Straight",0,0);
    translate(0,dy);
    text("'V' : reset Steering Angle Range",0,0);
    translate(0,dy);
    text("'X/C' : dec/inc Steering Power",0,0);
    translate(0,dy);    
    text("Mouse Click to change tracks",0,0);
    popStyle();
    popMatrix();
  }

  void detectJump(){
    color c = get(round(pos[0]),round(pos[1]));
    switch(jumpStatus){
      case -1:
        if (green(c) !=0){ //== Defaults.green){
          jumpStatus++;
          jumpInitX = pos[0];
          jumpInitY = pos[1];
        }
        break;
      case 0:
        float d = dist(pos[0],pos[1],jumpInitX,jumpInitY);
        if (d>Defaults.Jumplength){
          jumpStatus++;
        }
        break;
      case 1:
        d = dist(pos[0],pos[1],jumpInitX,jumpInitY);
        if (d>2.0*Defaults.Jumplength){
          jumpStatus++;
        }
        break;
      case 2:
        jumpStatus=-1;
        break;
    }
  }
    
  
  void showJumpStatus(){
    switch(jumpStatus){
      case 0:
        text("Jump: Acceleration!",0,0);
        break;
      case 1:
        text("Jump: Pop!",0,0);
        break;
      case 2:
        text("Jump: Land!",0,0);
        break;
      default:
        text("No Jump",0,0);
        break;
    }
  }
      
}

float formatHeading(float h){
  float res = h %360;
  return res<0 ? 360 + res : res;
}
