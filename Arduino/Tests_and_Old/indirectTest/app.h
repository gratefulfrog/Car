#ifndef APP_H
#define APP_H

#include "indirection.h"

class TestApp: public Indirect{
  private:
    float float01,
          float02,
          float03;
  public:
    TestApp();
};
#endif

