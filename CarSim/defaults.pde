class Defaults{
  // main windows defaults:
  static final int windowWidth  = 1500,
                   windowHeight = 800;
  
  static final float mm2pix = 1.0;
   
  // for the long tail:
  static final int tailLength = 1000;
  
  static final float  wheelWidth = 10 * mm2pix,
                      wheelHeight = 20  * mm2pix,
                      carWidth  = 100  * mm2pix,
                      carHieght =  160  * mm2pix,
                      axelWidth = carWidth -  wheelWidth;
  
  
  static final color  red   = #FF0000,
                      green = #00FF00,
                      blue  = #0000FF,
                      targetColor = red,
                      wheelColor = blue;
            
  Defaults(){};
}