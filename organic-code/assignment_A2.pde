/*

----this work is originally creted for an assignment,
   you could use the code below without any permission----
Name: Yuma Yanagisawa
Title: Organic Code
Description: The sketch aims to simulate the beauty of the nature
             The iconic image in the center is a flower, around it there are weeds.
             Even weeds are cut off, the flower still remains.

*/

/*
Global Variables
*/
//check the current state
boolean isPressedAlready = false;
int animationPhase = 0;

//define colors
color[] palette = {#AE773E, #7666F9, #F9D500, #F99BF8};

/*
setup
*/
void setup() {
  size(720, 720);
  smooth();
  //interaction-driven sketch, no-automatic-update
  noLoop();
  background(palette[0]);  
}

void draw() {
  // go to the center
  translate(width/2, height/2);
  // define how many times bezier vertex drawing is called
  int loopTimes = 8000;
  // define the max val of a bezier image might appear
  int maxRandomVal = 360;
  //if already pressed
  if(animationPhase > 1){
    float rotateVal = random(1, 6);
    rotate(PI/rotateVal);
    // decrease the loop times 
    loopTimes=2000;
    // when the animation phase is equal to 10, the weeds are cut off
    if(animationPhase%10 == 0) {
      background(palette[0]);
    }
  }
  if(isPressedAlready == true){
    for(int i = 0; i < loopTimes; i++) {
      float rotateVal = random(360);
      rotate(rotateVal);
      beginShape();
      float randomRed = random(30, 180);
      fill(randomRed, 188, 49);
      float randomX = random(maxRandomVal);
      float randomY = random(maxRandomVal);
      float randomFraction = random(30);
      translate(randomX, randomY);
      vertex(30, 20);
      bezierVertex(8, 0, 80, 75, 30+randomFraction, 75);
      bezierVertex(50, 80, 60, 25, 30, 20);
      endShape();
      translate(-randomX, -randomY);
      rotate(-rotateVal);
    }
    /*
    flower
    */
    //first draw a purple circle
    fill(palette[1]);
    ellipse(0, 0, 100, 100);
    fill(palette[2]);
    ellipse(0, 0, 11, 11);
    //clear fill as bezier images are layerd
    noFill();
    //rotate 90 degrees
    rotate(PI/4);
    //make the iconic image in the center using bezier curve
    for(int i=0; i < 4; i++) {
      if(i!=0){rotate(PI/2);}
      bezier(-25, 25, 25, -25, 25, 25, -25, -25);
    }
    //fill pink
    fill(palette[3]);
    for(int i=0; i < 4; i++) {
      if(i!=0) {
        rotate(PI/2);
      }
      beginShape();
      curveVertex(-25, 25);
      curveVertex(25, -25);
      curveVertex(25, 25);
      curveVertex(-25, -25);
      endShape();
    }
  }
}

/*
when key is released
*/
void keyReleased() {
  //s : save png
  if (key == 's' || key == 'S') saveFrame("screenshot.png");
  // else, redraw
  if (key != 's' || key != 'S'){
    isPressedAlready = true;
    redraw();
    animationPhase++;
  } 
}

/*
When mouse pressed
*/
void mousePressed() {
  //redraw
  isPressedAlready = true;
  animationPhase++;
  redraw();
}
