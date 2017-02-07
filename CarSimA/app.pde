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
  PID controller;
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
  void display(long count){
    // first display the bg & track
    background(Defaults.grey);
    if(CURVY_TRACK){
      //doImageCurvyTrack(g_track,x,y,w);
      doCurvyTrack(x,y,w);
    }
    else{
       doOvalTrack(x,y,w);
    }  
     // too slow in firefox!
    //image(g_track,0,0);
  
    // then display the values and buttons & parameters
    pushStyle();
    controller.display();
    
    text("PID Control",230,15);
    for(int i=0;i< pbRVec.length;i++){ 
      pbRVec[i].display();
    }
    popStyle();
    
    car.displayParams(steerAngle);
    
    // now display the animate objects
    car.display();
    
    updateDeltaT();
    
    // now update the animate objects
    car.update(deltaT);
    if (manualSteering){
      return;
    }
    if (car.velocity == 0){
      return;
    }
    // only executed in automatic steering mode!
    // note that the delta needs to be recomputed before calling the PID!
    if (!steerAngle){
      car.steeringAngularVelocitySet(controller.update(-car.steeringError,deltaT));
    }
    else{
      car.steeringAngleSet(controller.update(-car.steeringError,deltaT));
    }  
  }
  
  void updateDeltaT(){
    deltaT = 1/frameRate; 
  }
  
  void reset(){
    car = new Car(x-Defaults.trackStraightLength,y-w/2.0+(Defaults.trackBlackWidth + Defaults.trackWhiteWidth)/2.0,radians(90));
    controller =  new PID(0,  // setpoint
                          pidDefaults.Kp,  //Ku*0.6,
                          pidDefaults.Ki,  //Tu/2.0,
                          pidDefaults.Kd); //Tu/8.0)
    
    pbRVec = new PushButtonAdderRow[3];
    float valVec[] = {1,-1,0.1,-0.1,0.01,-0.01};
    pbRVec[0] =  new PushButtonAdderRow(100,60,controller.Kp, "Kp",valVec);
    pbRVec[1] =  new PushButtonAdderRow(100,120,controller.Ki, "Ki",valVec);
    pbRVec[2] =  new PushButtonAdderRow(100,180,controller.Kd, "Kd",valVec);

  }
  void setPidDefaults(){
    pidDefaults.Kp = pidDefaults.defaultKpFactory = controller.Kp.get();
    pidDefaults.Ki = pidDefaults.defaultKiFactory = controller.Ki.get();
    pidDefaults.Kd = pidDefaults.defaultKdFactory = controller.Kd.get();
  }
}