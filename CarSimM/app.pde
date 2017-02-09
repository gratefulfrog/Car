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
  //PID controller;
  PidSteeringMode mode[] = new PidSteeringMode[2], 
                  currentMode;
  int currentModeID = 0;
  
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
    updateSteeringMode();
    float error = currentMode.getError(car);
    // only executed in automatic steering mode!
    // note that the delta needs to be recomputed before calling the PID!
    if (!steerAngle){
      car.steeringAngularVelocitySet(currentMode.controller.update(error,deltaT));
    }
    else{
      car.steeringAngleSet(currentMode.controller.update(error,deltaT));
    }  
  }
  
  void updateSteeringMode(){
   if (car.inMiddle) {
      currentMode.controller.Kp.set(pidDefaults.Kp[1]); 
      currentMode.controller.Ki.set(pidDefaults.Ki[1]); 
      currentMode.controller.Kd.set(pidDefaults.Kd[1]);
   }
   else{
      currentMode.controller.Kp.set(pidDefaults.Kp[0]); 
      currentMode.controller.Ki.set(pidDefaults.Ki[0]); 
      currentMode.controller.Kd.set(pidDefaults.Kd[0]);
   }
  }
  
  PidSteeringMode newMode(int i){
    return new PidSteeringMode(0,  // setpoint
                               pidDefaults.Kp[i],
                               pidDefaults.Ki[i],  
                               pidDefaults.Kd[i]); 
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
    currentMode.controller.display();
    
    text("PID Control",230,15);
    for(int i=0;i< pbRVec.length;i++){ 
      pbRVec[i].display();
    }
    popStyle();
  }
  
  void updateDeltaT(){
    deltaT = 1/frameRate; 
  }
  
  void reset(){
    car = new Car(x-Defaults.trackStraightLength,y-w/2.0+(Defaults.trackBlackWidth + Defaults.trackWhiteWidth)/2.0,radians(90));
    /*
    controller =  new PID(0,  // setpoint
                          pidDefaults.Kp,  //Ku*0.6,
                          pidDefaults.Ki,  //Tu/2.0,
                          pidDefaults.Kd); //Tu/8.0)
    */
    for (int i=0;i<PidDefaults.nbPIDs;i++){
      mode[i] = new PidSteeringMode(0,  // setpoint
                               pidDefaults.Kp[i],
                               pidDefaults.Ki[i],  
                               pidDefaults.Kd[i]); 
    }
    currentModeID=0;
    currentMode = mode[currentModeID];
                          
    pbRVec = new PushButtonAdderRow[3];
    float valVec[] = {1,-1,0.1,-0.1,0.01,-0.01};
    pbRVec[0] =  new PushButtonAdderRow(100,60,currentMode.controller.Kp, "Kp",valVec);
    pbRVec[1] =  new PushButtonAdderRow(100,120,currentMode.controller.Ki, "Ki",valVec);
    pbRVec[2] =  new PushButtonAdderRow(100,180,currentMode.controller.Kd, "Kd",valVec);

  }
  void setPidDefaults(){
    pidDefaults.Kp[currentModeID] = pidDefaults.defaultKpFactory[currentModeID] = currentMode.controller.Kp.get();
    pidDefaults.Ki[currentModeID] = pidDefaults.defaultKiFactory[currentModeID] = currentMode.controller.Ki.get();
    pidDefaults.Kd[currentModeID] = pidDefaults.defaultKdFactory[currentModeID] = currentMode.controller.Kd.get();
  }
}