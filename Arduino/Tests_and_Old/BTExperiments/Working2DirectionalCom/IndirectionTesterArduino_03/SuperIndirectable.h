#ifndef SUPERINDIRECTABLE_H
#define SUPERINDIRECTABLE_H

class SuperIndirectable{
  protected:
    float val;
    virtual float valSet(float val);
  public:
    float set(float val) { return ValSet(val);}
    float get(float val) { return val;}
  
};

class SIFloat public: SuperIndirectable{
  protected:
    float valSet(float val);
};

#endif

