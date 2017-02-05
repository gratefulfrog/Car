abstract class PushButton{
  // class constants  
  final int pbH = 50,
            pbS = 10,
            debounceDelay = 200;
  final color pushedColor = #000000,
        releasedColor = #FFFFFF,
        overColor = #646464,
        textColor = #FF0000;

  // instance member variables  
  float x,y,av;
  int lastClickTime = 0, 
      pbW = 50;;
  String displayText;
  color c;
  fIndirectable fi;
  
  PushButton(float xx, float yy, fIndirectable ffi, String label, float addVal){
      x = xx;
      y = yy;
      c = releasedColor;
      lastClickTime = millis();
      fi=ffi;
      av = addVal;
      if(ISJS){
        displayText = new String(label + "\f\n" + nfp(av,0,0));

      }
      else{
        displayText = new String(label + '\n' + nfp(av,0,0));
      }  
  }
        
  void display(){
    if (isOver()){
      updateLabel();
        // we are over
        if (mousePressed){
            c = pushedColor;
            onClick();
        }
        else{
            c = overColor;
        }
    }
    else{
        c = releasedColor;
    }
    pushMatrix();
    translate(x,y);
    rectMode(CENTER);
    fill(c);
    stroke(c);
    rect(0,0,pbW,pbH);
    textAlign(CENTER,CENTER);
    fill(textColor);
    text(displayText,0,0);
    popMatrix();
    }
    
  // base class does no label updating
  void updateLabel(){}
  
  boolean isOver(){
      float xx = x-pbW/2.0,
            yy = y-pbH/2.0;
      return(mouseX >= xx &&  mouseX <= xx+pbW && mouseY >= yy && mouseY <= yy+pbH);
  }

  void onClick(){
      if (millis() > (debounceDelay + lastClickTime)){
        doi();
        lastClickTime = millis();
      }
  }
  // to be defined in derived classes
  abstract void doi();
}

class PushButtonAdder extends PushButton{
  
  PushButtonAdder(float xx, float yy, fIndirectable ffi, String label, float addVal){
    super(xx, yy, ffi, label, addVal);
  }
  void doi(){
    // in the adder we add
    fi.addV(av);
  }
}

class PushButtonMultiplier extends PushButton{
  
  PushButtonMultiplier(float xx, float yy, fIndirectable ffi, String label, float addVal){
    super(xx, yy, ffi, label, addVal);
  }
  void doi(){
    // in the adder we multiply
    fi.timesV(av);
  }
}

class PushButtonAdderRow {
  
  PushButtonAdder pbVec[];
  
  PushButtonAdderRow(float xx, float yy, fIndirectable ffi, String label, float addVal[]){
    int nbButtons = addVal.length;
    pbVec = new PushButtonAdder[nbButtons];
    for (int i=0;i<nbButtons;i++){
      pbVec[i]= new PushButtonAdder(xx, yy, ffi, label, addVal[i]);
      pbVec[i].x += (pbVec[i].pbW+pbVec[i].pbS)*i;
    }
  }
  void display(){
    for (int i=0;i<pbVec.length;i++){
      pbVec[i].display();
    }
  }
}

class PushButtonLogMultiplier extends PushButtonMultiplier{
  String fieldName;
  
  float inLow,
        inHigh,
        inMid,
        outLow,
        outHigh,
        outMid;
  
  PushButtonLogMultiplier(float xx, float yy, fIndirectable ffi, String label, float addVal){
    super(xx, yy, ffi, label, addVal);
    pbW = 150;
    inLow = 0;
    inHigh = pbW;
    inMid = inHigh/2.0;
    outLow = 1.0/av;
    outHigh= av;
    outMid = 1.0;
    fieldName = label;
    if (ISJS){
        displayText = fieldName + "\f\n" + fi.get();
    }
    else{
      displayText = fieldName + '\n' + fi.get();
    }
  }
  float mapMouse(){
    float  offset= mouseX - (x-pbW/2.0);
    if (offset <= inMid){
      // low range
      return (((offset-inLow)*(outMid-outLow)/(inMid-inLow)) + outLow);
    }
    else{  
      // high range
      return (((offset-inMid)*(outHigh-outMid)/(inHigh-inMid)) + outMid);
    }
  }

  void doi(){
    fi.timesV(mapMouse());
  }
  
  void display(){
     if (ISJS){
      displayText = fieldName + "\f\n" + nf(fi.get(),0,2);
     }
     else{
      displayText = fieldName + '\n' + nf(fi.get(),0,2);
     }
     super.display();
  }
  void updateLabel(){
    if (ISJS){
      displayText = fieldName + "\f\n" + nf(fi.get()*mapMouse(),0,2);  
    }
    else{
      displayText = fieldName + '\n' + nf(fi.get()*mapMouse(),0,2);  
    }
  }    
}