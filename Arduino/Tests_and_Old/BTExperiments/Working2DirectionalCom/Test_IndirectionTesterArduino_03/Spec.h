#ifndef SPEC_H
#define SPEC_H

class Spec{
  protected:
    const float maxAngle =  70,
                minAngle = -70,
                minAngularVelocity = -0.75,
                maxAngularVelocity = .75;
  public:
    float getMaxAngle() const {return maxAngle;}
    float getMinAngle() const {return minAngle;}
    float getMaxAngularVelocity() const {return maxAngularVelocity;}
    float getMinAngularVelocity() const {return minAngularVelocity;}
};
#endif
