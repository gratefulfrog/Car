class defaults{
  final int maxSteeringSensitivity = 8,
            stdSteeringSensitivity = 5;                    
  
  
  final color red   = #FF0000,
              green = #00FF00,
              blue  = #0000FF,
              grey  = #A7A7A7,
              black = #000000,
              white = #FFFFFF,
              targetColor = red,
              wheelColor = blue;

  float mm2pix,
        trackWhiteWidth,
        trackBlackWidth,
       
        wheelWidth,
        wheelHeight,
        carWidth,
        carHieght,
        axelWidth,
        sensorHalfWidth,
        sensorInterceptHalfLength,
        
        trackerMiddleEpsilon,
 
        trackAvailableDrivingWidth,
        
        trackStraightLengthMM,
        trackStraightLength,
        trackOuterDiameterMM,
        trackOuterDiameter,
        totalWidth,
        
        buttonsXLimit,
        buttonsYLimit;
                      
  int sensorInterceptLimit;
                       
  defaults(){
    mm2pix = CURVY_TRACK ? 0.35 :0.50;  // depends on the size of the track!
  
    trackWhiteWidth =  20 * mm2pix;
    trackBlackWidth =  240 * mm2pix;
                      
    wheelWidth = 10 * mm2pix;
    wheelHeight = 20  * mm2pix;
    carWidth  = 100  * mm2pix;
    carHieght =  160  * mm2pix;
    axelWidth = carWidth -  wheelWidth;
    sensorHalfWidth = 1.5 * (trackBlackWidth + 2*trackWhiteWidth);
    sensorInterceptHalfLength = carWidth/4.0;
    
    trackerMiddleEpsilon = 35 * mm2pix;

    totalWidth = trackWhiteWidth * 2 + trackBlackWidth;
    trackAvailableDrivingWidth = trackBlackWidth - carWidth;

    sensorInterceptLimit = round(sensorHalfWidth);
  
    trackStraightLengthMM = 1500;
    trackStraightLength   = trackStraightLengthMM * mm2pix;
    trackOuterDiameterMM  = 1400;
    trackOuterDiameter    = trackOuterDiameterMM * mm2pix;
    
    buttonsXLimit = 430;
    buttonsYLimit = 210;
  }         
    
}

class PidDefaults{
  // PID parameter values empirically determined by the Ziegler-Nichols method
  // it is hard to do better!
  //final float _Ku = 2.01, // empirically determined following the Ziegler-Nichols method to find the value for oscillation
  //            _Tu = 1.1,  // oscillation dt
  /*             
  final float defaultKpFactory = _Ku*0.6,
              defaultKiFactory = _Tu/2.0,
              defaultKdFactory = _Tu/8.0;
  */      
  static final int nbPIDs = 2;
  
  float defaultKpFactory[] = {2.04, 0.5}, //4.97, //1.0, //36, //0.72,// _Ku*0.6,
        defaultKiFactory[] = {0.71,0.02}, //0.76, //0.97, //0.38, //0.01, //_Tu/2.0,
        defaultKdFactory[] = {2.54,1.0}; //2.46; //1.39; //2.44; //_Tu/8.0;

  float Kp[],
        Ki[], 
        Kd[]; 
            
  PidDefaults(){
    Kp =  new float[nbPIDs];
    Ki =  new float[nbPIDs];
    Kd =  new float[nbPIDs];
         
    resetFactoryDefaults();
  }
  
  void  resetFactoryDefaults(){
   for (int i=0;i<nbPIDs;i++){
      Kp[i] = defaultKpFactory[i];
      Ki[i] = defaultKiFactory[i];
      Kd[i] = defaultKdFactory[i];
   }
  }
}