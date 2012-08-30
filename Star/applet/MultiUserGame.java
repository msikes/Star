import processing.core.*; 
import processing.xml.*; 

import hypermedia.video.*; 
import java.awt.*; 
import integralhistogram.*; 
import template.*; 
import codeanticode.gsvideo.*; 
import codeanticode.glgraphics.*; 
import fullscreen.*; 
import japplemenubar.*; 
import controlP5.*; 

import java.applet.*; 
import java.awt.Dimension; 
import java.awt.Frame; 
import java.awt.event.MouseEvent; 
import java.awt.event.KeyEvent; 
import java.awt.event.FocusEvent; 
import java.awt.Image; 
import java.io.*; 
import java.net.*; 
import java.text.*; 
import java.util.*; 
import java.util.zip.*; 
import java.util.regex.*; 

public class MultiUserGame extends PApplet {

/**
* MultiUserGame
* by Shawn Cook, Koya Oneda, Margo Sikes and Mike Thomas.
*
*
*/
















OpenCV opencv;
GSCapture cam;

// Contrast/brightness values
int contrast_value    = 0;
int brightness_value  = 0;

User ourUser = new User(0,50,50);

public void setup()
{
  size(640, 480); 
  
  cam = new GSCapture(this, 640, 480);
  cam.start();
  
  opencv = new OpenCV(this);
  
  opencv.allocate(640,480);
  
  // Load detection description, here-> front face detection : "haarcascade_frontalface_alt.xml"
  //opencv.cascade( OpenCV.CASCADE_FRONTALFACE_ALT );
}

public void captureEvent(GSCapture c) {
  c.read();
}

public void stop() {
  opencv.stop();
  super.stop();
}

public void draw()
{ 
  opencv.copy(cam);
    
  opencv.convert(GRAY);
  opencv.contrast(contrast_value);
  opencv.brightness(brightness_value);

  // Proceed with detection
  Rectangle[] faces = opencv.detect(1.2f, 2, OpenCV.HAAR_DO_CANNY_PRUNING, 40, 40);

  // Display the image
  image(cam, 0, 0);

  // Draw face area(s)
  noFill();
  stroke(255, 0, 0);
  for(int i = 0; i < faces.length; i++) {
    rect(faces[i].x, faces[i].y, faces[i].width, faces[i].height); 
  }
  
  //background(51);
  
  ourUser.update();
}
class User {
 int id;
 float x;
 float y;
 float targetX, targetY;
 float easing = 0.05f;
 
 Boolean started = false;
 
 User(int idee, float xpos, float ypos) {
  id = idee;
  x = xpos;
  y = ypos;
 }

 public void update(){
  
  targetX = mouseX;
  float dx = targetX - x;
  if(abs(dx) > 1) {
    x += dx * easing;
  }
  
  targetY = mouseY;
  float dy = targetY - y;
  if(abs(dy) > 1) {
    y += dy * easing;
  }
  ellipse(x, y, 66, 66); 
 } 
  
}
  static public void main(String args[]) {
    PApplet.main(new String[] { "--bgcolor=#FFFFFF", "MultiUserGame" });
  }
}
