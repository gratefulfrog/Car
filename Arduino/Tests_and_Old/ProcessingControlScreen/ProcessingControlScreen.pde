final float displayFactor = 0.5,
            nexusWidth = 768,
            nexusHeight = 1280;
            
final int screenW = round(nexusWidth*displayFactor),
          screenH = round(nexusHeight*displayFactor);

final color black = #000000,
            white = #FFFFFF,
            red   = #FF0000,
            green = #00FF00,
            blue  = #0000FF;
            
final boolean Android = false;

final int screenTextSize = 36,
          androidTextSize = 72;

void settings(){
  if (Android){
    fullScreen();
    orientation(PORTRAIT);
  }
  else{
    size(screenW,screenH); 
  }
}

AngleControl ac;
SpeedControl sc ;

void setup(){
  background(black);
  ac = new AngleControl(30,width/2.0,height/2.0);
  ac.currentAngle = radians(0);
  sc =  new SpeedControl(1000,width,height/2.0);
  if (Android){
    textSize(androidTextSize);
  }
  else{
    textSize(screenTextSize);
  }
}

void draw(){
  background(black);
  ac.display();
  sc.display();
}
  
void mousePressed(){
  if (mouseY > ac.y){
    scMouse();
  }
  else{
    ac.update(mouseX,mouseY);
  }
}

void mouseDragged(){
  if (mouseY > ac.y){
    scMouse();
  }
  else{
    ac.update(mouseX,mouseY);
  }
}
void scMouse(){
  sc.update(mouseX<= width/2.0 ? 1 :  -1);
}