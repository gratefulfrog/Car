class App {
  final float deltaT = 1.0;
  Car car;
  boolean steerAngle = false,
          manualSteering = false;

  float   x,
          y,
          w;
  float maxS = Defaults.maxSteeringSensitivity,
        sInc = radians(Defaults.stdSteeringSensitivity),
        saInc = radians(maxS*0.01);
  final float vInc = 1;
  
  final float trackXOffset = 150;
        
  //PGraphics g_track;

  PidDefaults pidDefaults;
  PID controller;
  PushButtonAdderRow pbRVec[];
  //PushButton lb,
  //           ab;
  
  App(){
    x = width/2.0 + Defaults.trackStraightLength/2.0 + trackXOffset;
    y = height/2.0;
    w = Defaults.trackOuterDiameter;
    pidDefaults = new PidDefaults();
    //g_track = createGraphics(1800,900);
    //do_ImageTrack(g_track,x,y,w);
    reset();
  }
  void display(long count){
    // first display the bg & track
    background(Defaults.grey);
    doTrack(x,y,w);
    // too slow in firfox!
    //image(g_track,0,0);
  
    // then display the values and buttons & parameters
    pushStyle();
    controller.display();
    
    //pushMatrix();
    for(int i=0;i< pbRVec.length;i++){ 
      pbRVec[i].display();
    }
    popStyle();
    //popMatrix();
    
    car.displayParams(steerAngle);
    
    // now display the animate objects
    car.display();
    
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
    if (steerAngle){
      car.steeringAngularVelocitySet(controller.update(-car.steeringError,deltaT));
    }
    else{
      car.steeringAngleSet(controller.update(-car.steeringError,deltaT));
    }  
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
  void setDefaults(){
        pidDefaults.Kp = controller.Kp.get();
        pidDefaults.Ki = controller.Ki.get();
        pidDefaults.Kd = controller.Kd.get();
  }
}