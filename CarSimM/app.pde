class App {
  float deltaT = 1/frameRate; //0.02;

  Car car;
  boolean steerAngle = false,
          manualSteering = false;

  float   x,
          y,
          w;
  float maxS = Defaults.maxSteeringSensitivity,
        sInc = radians(Defaults.stdSteeringSensitivity),
        saInc = radians(maxS*0.01);
 
  final float vInc = 10;
  
  final float trackXOffsetCurvy = 100,
              trackXOffsetOval   = 160,
              trackYOffsetCurvy = 30,
              trackYOffsetOval  = 300;
  
  //PGraphics g_track;

  PidDefaults pidDefaults;
  PushButtonAdderRow pbRVec[];
  
  App(PidDefaults pd){
    float xOffset,
          yOffset;
    
    if(CURVY_TRACK){
      xOffset = trackXOffsetCurvy;
      yOffset = trackYOffsetCurvy;
    }
    else{
      //Defaults.mm2pix = MM2PX_OVAL;
      xOffset = trackXOffsetOval;
      yOffset = trackYOffsetOval;
    }
    x = width/2.0 + Defaults.trackStraightLength/2.0 + xOffset;
    y = height/4.0 + yOffset;
    w = Defaults.trackOuterDiameter;
    if (pd == null){
      pidDefaults = new PidDefaults();
    }  
    else{
     pidDefaults = pd;
    }
    //g_track = createGraphics(1800,900);
    //doImageCurvyTrack(g_track,x,y,w);
    doCurvyTrack(x,y,w);
    reset();
  }
  void display(){
    // first display the bg & track
    background(Defaults.grey);
    displayTrack();
    displayControler();
    
    car.displayParams(steerAngle);   
    // now display the animate objects
    car.display();
    
    updateDeltaT();
    
    // now update the animate objects
    car.update(deltaT);
    if (manualSteering || (car.velocity == 0)){
      return;
    }
    car.updateSteeringMode(deltaT);
  }
  

  void displayTrack(){
    if(CURVY_TRACK){
      //doImageCurvyTrack(g_track,x,y,w);
      doCurvyTrack(x,y,w);
    }
    else{
       doOvalTrack(x,y,w);
    }  
     // too slow in firefox!
    //image(g_track,0,0);
  }
  void displayControler(){
    // then display the values and buttons & parameters
    pushStyle();
    car.currentMode.controller.display();
    
    text("PID Control: \t" + car.currentMode.modeID,210,15);
    for(int i=0;i< pbRVec.length;i++){ 
      pbRVec[i].display();
    }
    popStyle();
  }
  
  void updateDeltaT(){
    deltaT = 1/frameRate; 
  }
  
  void reset(){
    car = new Car(x-Defaults.trackStraightLength,y-w/2.0+(Defaults.trackBlackWidth + Defaults.trackWhiteWidth)/2.0,radians(90),pidDefaults);
                          
    pbRVec = new PushButtonAdderRow[3];
    float valVec[] = {1,-1,0.1,-0.1,0.01,-0.01};
    pbRVec[0] =  new PushButtonAdderRow(100,60,car.currentMode.controller.Kp, "Kp",valVec);
    pbRVec[1] =  new PushButtonAdderRow(100,120,car.currentMode.controller.Ki, "Ki",valVec);
    pbRVec[2] =  new PushButtonAdderRow(100,180,car.currentMode.controller.Kd, "Kd",valVec);

  }
  void setPidDefaults(){
    pidDefaults.Kp[car.currentModeID] = pidDefaults.defaultKpFactory[car.currentModeID] = car.currentMode.controller.Kp.get();
    pidDefaults.Ki[car.currentModeID] = pidDefaults.defaultKiFactory[car.currentModeID] = car.currentMode.controller.Ki.get();
    pidDefaults.Kd[car.currentModeID] = pidDefaults.defaultKdFactory[car.currentModeID] = car.currentMode.controller.Kd.get();
  }
}