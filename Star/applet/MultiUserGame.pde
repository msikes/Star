/**
* MultiUserGame
* by Shawn Cook, Koya Oneda, Margo Sikes and Mike Thomas.
*
*
*/

import hypermedia.video.*;
import java.awt.*;

import integralhistogram.*;
import template.*;

import codeanticode.gsvideo.*;

import codeanticode.glgraphics.*;

import fullscreen.*;
import japplemenubar.*;

import controlP5.*;

OpenCV opencv;
GSCapture cam;

// Contrast/brightness values
int contrast_value    = 0;
int brightness_value  = 0;

User ourUser = new User(0,50,50);

void setup()
{
  size(640, 480); 
  
  cam = new GSCapture(this, 640, 480);
  cam.start();
  
  opencv = new OpenCV(this);
  
  opencv.allocate(640,480);
  
  // Load detection description, here-> front face detection : "haarcascade_frontalface_alt.xml"
  //opencv.cascade( OpenCV.CASCADE_FRONTALFACE_ALT );
}

void captureEvent(GSCapture c) {
  c.read();
}

public void stop() {
  opencv.stop();
  super.stop();
}

void draw()
{ 
  opencv.copy(cam);
    
  opencv.convert(GRAY);
  opencv.contrast(contrast_value);
  opencv.brightness(brightness_value);

  // Proceed with detection
  Rectangle[] faces = opencv.detect(1.2, 2, OpenCV.HAAR_DO_CANNY_PRUNING, 40, 40);

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
