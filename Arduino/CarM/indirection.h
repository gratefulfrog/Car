#ifndef INDIRECTION_H
#define INDIRECTION_H

#define NB_INTS (10)
#define NB_FLOATS (20)

class Indirect{
  protected:
    float **floatVec;

    int nextFreeFloat = 0,
        floatSize;
        
  public:
    Indirect(int nbFloats);
    void addElt(float* val);  
    void set(int ind, float *val);
    float* get(int ind) const;
};

#endif
