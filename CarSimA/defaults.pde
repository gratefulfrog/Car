static class Defaults{
  // main windows defaults:
  static final int windowWidth  = 1500,
                   windowHeight = 800;
  
  static final float mm2pix = 0.50;
  
  static final float  trackWhiteWidth =  20 * mm2pix,
                      trackBlackWidth =  240 * mm2pix;
                      
  static final float  wheelWidth = 10 * mm2pix,
                      wheelHeight = 20  * mm2pix,
                      carWidth  = 100  * mm2pix,
                      carHieght =  160  * mm2pix,
                      axelWidth = carWidth -  wheelWidth,
                      sensorHalfWidth = 1.5 * (trackBlackWidth + 2*trackWhiteWidth),
                      sensorInterceptHalfLength = carWidth/4.0;
  static final int    sensorInterceptLimit = round(sensorHalfWidth);
  
  static final float  trackStraightLengthMM = 1500,
                      trackStraightLength   = trackStraightLengthMM * mm2pix,
                      trackOuterDiameterMM  = 1400,
                      trackOuterDiameter    = trackOuterDiameterMM * mm2pix;
                      
  static final int maxSteeringSensitivity = 8,
                   stdSteeringSensitivity = 5;                    
  
  
  static final color  red   = #FF0000,
                      green = #00FF00,
                      blue  = #0000FF,
                      grey  = #A7A7A7,
                      black = #000000,
                      white = #FFFFFF,
                      targetColor = red,
                      wheelColor = blue;
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