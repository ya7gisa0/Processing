//SimpleOpenNI
import SimpleOpenNI.*;
SimpleOpenNI kinect;

//Sonic Painter
Maxim maxim;

//animation set
int numFrames = 8;  // The number of frames in the animation
int frame = 0;
PImage[] images = new PImage[numFrames];

//sound library
import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;

Minim minim;
AudioSample collision;
AudioSample magicChime;
AudioSample shootingStar;

// Learning Processing
// Daniel Shiffman
// http://www.learningprocessing.com ..definitely thanks
Shape[] shapes = new Shape[5];
public int number = 0;
//catch nearest depth
int closestValue;
public int closestX;
public int closestY;

// declare global variables for the
// previous x and y coordinates
int previousX;
int previousY;

void setup() {
  size(800, 520);
  kinect = new SimpleOpenNI(this);
  kinect.enableDepth();
  maxim = new Maxim(this);
  frameRate(24);
  shapes[0] = new Shape(color(255, 255, 0), 0, 100, 4, random(15, 18)); // Parameters go inside the parentheses when the object is constructed.
  shapes[1] = new Shape(color(255, 255, 0), 500, 10, -6, random(20, 22));
  shapes[2] = new Shape(color(255, 255, 0), 0, 180, 7, random(26, 32));
  shapes[3] = new Shape(color(255, 255, 0), 0, 150, 4, random(29, 30));
  shapes[4] = new Shape(color(255, 255, 0), 0, 450, 4, random(30, 32));
  //cars = reverse(cars);

  //sound stuff
  // we pass this to Minim so that it can load files from the data directory
  minim = new Minim(this);

  // loadFile will look in all the same places as loadImage does.
  // this means you can find files that are in the data folder and the 
  // sketch folder. you can also pass an absolute path, or a URL.
  collision = minim.loadSample("cartoon015.mp3", 512);
  magicChime = minim.loadSample("magic-chime-02.mp3", 512);
  shootingStar = minim.loadSample("bell-shooting.wav", 512);
  //Animation stuff here
  images[0]  = loadImage("star001.gif");
  images[1]  = loadImage("star0015.gif"); 
  images[2]  = loadImage("star002.gif");
  images[3]  = loadImage("star0025.gif"); 
  images[4]  = loadImage("star003.gif");
  images[5]  = loadImage("star0035.gif"); 
  images[6]  = loadImage("star004.gif");
  images[7]  = loadImage("star0045.gif");
}

void draw() {
  background(255);
  frame = (frame+1) % numFrames;  // Use % to cycle through frames
  int offset = 0;
  for (int x = 0; x < width; x += images[0].width) { 
    image(images[(frame+offset) % numFrames], x, -20);
    offset+=1;
    //image(images[(frame+offset) % numFrames], x, height/2);
    //offset+=2;
  }

  closestValue = 8000;

  kinect.update();
  

  int[] depthValues = kinect.depthMap();

  for (int y = 0; y < 480; y++) {
    for (int x = 0; x < 640; x++) {
      int i = x + y * 640;
      int currentDepthValue = depthValues[i];

      if (currentDepthValue > 0 && currentDepthValue < closestValue) {

        closestValue = currentDepthValue;
        closestX = x;
        closestY = y;
      }
    }
  }

  //draw shape
  shapes[number].move();
  shapes[number].display();
  shapes[number].mouseHover();

  //sonic painter
  float red = map(200, 0, width, 0, 120);
  float blue = map(200, 0, width, 0, 120);
  float green = dist(closestX, closestY, width/2, height/2);

  float speed = dist(previousX, previousY, closestX, closestY);
  float alpha = map(speed, 0, 20, 0, 10);
  //println(alpha);
  //float lineWidth = map(speed, 0, 10, 10, 1);
  //lineWidth = constrain(lineWidth, 0, 10);

  noStroke();
  fill(255, alpha);
  //rect(width/2, height/2, width, height);

  stroke(red, green, blue, 255);
  float r = random(10,17);
  strokeWeight(r);
  // draw a line from the previous point
  // to the new closest one
  line(previousX, previousY, closestX, closestY);
  // save the closest point
  // as the new previous one
  previousX = closestX;
  previousY = closestY;
}


class Shape { // Even though there are multiple objects, we still only need one class. No matter how many cookies we make, only one cookie cutter is needed.Isnâ€™t object-oriented programming swell?
  color c;
  float xpos;
  float ypos;
  float xspeed;
  float yspeed;

  Shape(color tempC, float tempXpos, float tempYpos, float tempXspeed, 
  float tempYspeed) { // The Constructor is defined with arguments.
    c = tempC;
    xpos = tempXpos;
    ypos = tempYpos;
    xspeed = tempXspeed;
    yspeed = tempYspeed;
  }

  void display() {
    stroke(0);
    strokeWeight(0);
    fill(c);
    //rectMode(CENTER);
    //rect(xpos, ypos, 20, 10);
    pushMatrix();
    translate(xpos, ypos);
    rotate(frameCount / -5.0);
    star(0, 0, 7.5, 17.5, 5);
    popMatrix();
  }

  void move() {
    xpos = xpos + xspeed;
    ypos = ypos + yspeed;
    if (xpos > width) {
      xpos = 0;
    }
    if (xpos < 0) {
      xpos = width;
    }
    if (ypos > height +random(2000, 3000)) {

      ypos = 0;
    }
    if (ypos == 0) {
      magicChime.trigger();
    }
  }

  void mouseHover() {
    if (closestX>xpos -20 && closestX < xpos+20 && closestY  > ypos-20 && closestY < ypos + 20) {
      if (number == 4) {
        number=0;
      }
      number++;
      // play the file from start to finish.
      // if you want to play the file again, 
      // you need to call rewind() first.
      shootingStar.trigger();
    }
  }

  void star(float x, float y, float radius1, float radius2, int npoints) {
    float angle = TWO_PI / npoints;
    float halfAngle = angle/2.0;
    beginShape();
    for (float a = 0; a < TWO_PI; a += angle) {
      float sx = x + cos(a) * radius2;
      float sy = y + sin(a) * radius2;
      vertex(sx, sy);
      sx = x + cos(a+halfAngle) * radius1;
      sy = y + sin(a+halfAngle) * radius1;
      vertex(sx, sy);
    }
    endShape(CLOSE);
  }
}

