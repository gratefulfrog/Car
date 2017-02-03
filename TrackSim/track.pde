abstract class TrackSection{
  final float whiteWidth = Defaults.trackWhiteWidth,
              totalWidth = Defaults.trackWhiteWidth * 2 + Defaults.trackBlackWidth;
  
  float startPoint[] =  new float[2],
        endPoint[] =  new float[2],
        endRotation;
  
  abstract void display();
}

 class StraightTrack extends TrackSection{
   float w = Defaults.trackStraightLength,
         h = totalWidth;
   
   StraightTrack(float x,float y,float r){
     startPoint[0] = x;
     startPoint[1] = y;
     endPoint[0] = x+w;
     endPoint[1] = y;
     endRotation =r;
   }
   
   void display(){
     pushMatrix();
     pushStyle();
     translate(startPoint[0],startPoint[1]);
     rotate(endRotation);
     fill(Defaults.black);
     rect(0,0,w,h);
     fill(Defaults.white);
     rect(0,0,w,whiteWidth);
     rect(0,totalWidth-whiteWidth,w,whiteWidth);
     popStyle();
     popMatrix();
   }
 }