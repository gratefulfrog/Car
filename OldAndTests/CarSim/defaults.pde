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