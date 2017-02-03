abstract class TrackSection{
  final float whiteWidth = Defaults.trackWhiteWidth,
              totalWidth = Defaults.trackWhiteWidth * 2 + Defaults.trackBlackWidth;
  
  float startPoint[] =  new float[2],
        endPoint[] =  new float[2],
        endRotation;
  
  abstract void display();
}

 class StraightTrack extends TrackSection{
   float ww,hh;
   
   StraightTrack(float x,float y,float r){
     ww = Defaults.trackStraightLength;
     hh = totalWidth;
     startPoint[0] = x;
     startPoint[1] = y;
     endPoint[0] = x+ww;
     endPoint[1] = y;
     endRotation =r;
   }
   
   void display(){
     pushMatrix();
     pushStyle();
     translate(startPoint[0],startPoint[1]);
     rotate(endRotation);
     fill(Defaults.black);
     rect(0,0,ww,hh);
     fill(Defaults.white);
     rect(0,0,ww,whiteWidth);
     rect(0,totalWidth-whiteWidth,ww,whiteWidth);
     popStyle();
     popMatrix();
   }
 }