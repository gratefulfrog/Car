#ifndef DEFAULTS_H
#define DEFAULTS_H

class Defaults{
  protected:
  public:
    // external constants
    static const float trackWidth = 280, //mm
                       whiteWidth = 20; // mm
    // derived constants
    static const float blackWidth = trackWidth - 2*whiteWidth,
                       distanceMiddle2White = blackWidth/2.0;

    // car constants
    static const float B = 100, // mm distance between to rightward looking distance sensors
                       maxSteeringAngle = radians(30),
                       maxSteeringAngularVelocity = radians(150),
                       maxVelocity =  10;  //mm par milli second 
    static const int   servoPin     = 9,
                       speedPin     = 11,
                       heartBeatPin = 12,
                       speepPin     = 13;

    // navigtation constants
    static const float trackerMiddleEpsilon = 50, // mm when less than this dist, we are in the middle
                       jumpSpeed = 20/1000.0;  // 20mm/sec in mm/ms
};

#endif
