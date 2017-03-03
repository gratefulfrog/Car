#include "app.h"


TestApp::TestApp() : Indirect(3){
  float01 = 1.1;
  float02 = 2.2;
  float03 = 3.3;

  float* fv[] = {&float01, &float02, &float03};
  for (int i =0;i<3;i++){
    addElt(fv[i]);
  }
}



