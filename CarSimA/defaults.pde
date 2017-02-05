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
 
        trackStraightLengthMM,
        trackStraightLength,
        trackOuterDiameterMM,
        trackOuterDiameter,
        totalWidth;
                      
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

    totalWidth = trackWhiteWidth * 2 + trackBlackWidth;

    sensorInterceptLimit = round(sensorHalfWidth);
  
    trackStraightLengthMM = 1500;
    trackStraightLength   = trackStraightLengthMM * mm2pix;
    trackOuterDiameterMM  = 1400;
    trackOuterDiameter    = trackOuterDiameterMM * mm2pix;
  }         
    
}

class PidDefaults{
  // PID parameter values empirically determined by the Ziegler-Nichols method
  // it is hard to do better!
  //final float _Ku = 2.01, // empirically determined following the Ziegler-Nichols method to find the value for oscillation
  //            _Tu = 1.1,  // oscillation dt
               
  final float defaultKpFactory = 0.72,// _Ku*0.6,
              defaultKiFactory = 0.01, //_Tu/2.0,
              defaultKdFactory = 2.3; //_Tu/8.0;
        
 float Kp = defaultKpFactory,
       Ki = defaultKiFactory,
       Kd = defaultKdFactory;
            
  PidDefaults(){};
  
  void  resetFactoryDefaults(){
    Kp = defaultKpFactory;
    Ki = defaultKiFactory;
    Kd = defaultKdFactory;
  }
}