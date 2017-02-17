#ifndef INDIRECTION_H
#define INDIRECTION_H
#include <Arduino.h>

#define NB_INDIRECTS (10)

class Indirect;

class Indirect{
  protected:
    float **floatVec;

    static Indirect *indirectVec[];
    static int lastID;;
   
    int nextFreeFloat = 0,
        floatSize;
    Indirect* dispatch(int i) const;

        
  public:
   const int id;
    Indirect(int nbFloats);
    void addElt(float* val);  
    void set(int ind, float val);
    float get(int ind) const;
};

#endif
