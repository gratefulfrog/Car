#include "ServoSpec.h"

ServoSpec::ServoSpec( int deadBand,          // us
                      int minBurnout,        // us not including dead band
                      int maxBurnout,        // us not including dead band
                      int center,            // us
                      int angularRange,      // degrees from burnout to burnout
                      int angularVelocity,   // degrees/sec
                      int refreshRate):      // Hz
                        servoDeadBand(deadBand),
                        servoMinBurnout(minBurnout+deadBand),
                        servoMaxBurnout(maxBurnout-deadBand),
                        servoCenter(center),        
                        servoAngularRange(angularRange),  
                        maxAngularVelocity(angularVelocity),
                        servoRefreshRate(refreshRate),
                        servoCStopDegrees(servoAngularRange/2.0),
                        servoCCStopDegrees(-servoCStopDegrees),
                        servoCenterDegrees(0),
                        servoCMaxV(maxAngularVelocity),
                        servoCCMinV(-servoCMaxV){
                      } 
#ifdef DEBUG
void ServoSpec::display(){
  Serial.print("servoDeadBand\t");
  Serial.println(servoDeadBand);
  Serial.print("servoMinBurnout:\t");
  Serial.println(servoMinBurnout);
  Serial.print("servoMaxBurnout:\t");
  Serial.println(servoMaxBurnout);
  Serial.print("servoCenter:\t");
  Serial.println(servoCenter);
  Serial.print("servoAngularRange:\t");
  Serial.println(servoAngularRange);
  Serial.print("maxAngularVelocity:\t");
  Serial.println(maxAngularVelocity);
  Serial.print("RefreshRate:\t");
  Serial.println(servoRefreshRate);
  Serial.print("servoCStopDegrees:\t");
  Serial.println(servoCStopDegrees);
  Serial.print("servoCCStopDegrees:\t");
  Serial.println(servoCCStopDegrees);
  Serial.print("servoCenterDegrees:\t");
  Serial.println(servoCenterDegrees);
  Serial.print("servoCMaxV:\t");
  Serial.println(servoCMaxV);
  Serial.print("servoCCMinV:\t");
  Serial.println(servoCCMinV);
}
#endif

const ServoSpec savoxSpec(5,   // us dead band
                         700,  // us min not including dead band 
                         2300, // us max
                         1500, // us
                         150,  // degrees from burnout to burnout
                         60/0.08, // 60 degress in 0.08 seconds
                         50); //Hz refresh rate
 

