
// this is may solution that enables the buttons to indirectly assign values
// to member variables of other classes
abstract class Indirectable{ 
  abstract float get();
  abstract void set(float f);
}

class fIndirectable extends Indirectable{
  float val;
  fIndirectable(float v){
    val= v;
  }
  final float get(){
    return val;
  }
  void set(float f){
    val = f;
  }
  void addV(float v){
    val +=v;
  }
  void timesV(float v){
    val *=v;
  }
}