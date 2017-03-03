/*  This will run on the emulator
 * first start teh emulator, then "run on emulator" 
 * and on the nexus 4 and on the yezz Andy 3.5
 * just run on device
 */


void setup() {
  fullScreen();
  noStroke();
  fill(0);
}

void draw() {
  background(204);
  if (mousePressed) {
    if (mouseX < width/2) {
      rect(0, 0, width/2, height); // Left
    } else {
      rect(width/2, 0, width/2, height); // Right
    }
  }
}