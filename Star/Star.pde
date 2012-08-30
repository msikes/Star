// - Super Fast Blur v1.1 by Mario Klingemann <http://incubator.quasimondo.com>
// - BlobDetection library

import processing.video.*;
import blobDetection.*;

import controlP5.*;

import ddf.minim.*;

ControlP5 cp5;

AudioPlayer player1;
AudioPlayer player2;
AudioPlayer player3;
AudioPlayer player4;
AudioPlayer player5;
AudioPlayer player6;

Capture cam;
BlobDetection theBlobDetection;
PImage img;
boolean newFrame=false;
ArrayList users = new ArrayList(); //list to hold our users
String moveString;
//User ourUser = new User(0);//refernce to ourUser object

boolean drawBlobs = false;
boolean drawEdges = false;
boolean drawCentroids = false;

float soundOne = -50;
float soundTwo = -50;
float soundThree = -50;
float soundFour = -50;
float soundFive = -50;
float soundSix = 10;

float fadeBg1 = 253;
float fadeBg2 = 253;

int bgcounter1 = 0;
int bgcounter2 = 0;

Minim minim;

PImage a;
PImage b;

ArrayList planets = new ArrayList(); //list to hold our planets

//User[] userArray = new User[4];
//Planet[] planetArray = new Planet[20];

// ==================================================
// setup()
// ==================================================
void setup()
{
  // Size of applet
  size(1024, 768);
  // Capture
  cam = new Capture(this, 160, 120, 30);
  // BlobDetection
  // img which will be sent to detection (a smaller copy of the cam frame);
  img = new PImage(80, 60);
  theBlobDetection = new BlobDetection(img.width, img.height);
  //theBlobDetection.setPosDiscrimination(true);
  //theBlobDetection.setThreshold(0.2f); // will detect bright areas whose luminosity > 0.2f;

 cam.start();

  for (int i=0;i<4;i++) {
    users.add(new User(i));
  }

  for (int i=0;i<20;i++) {
    planets.add(new Planet(i));
  }

  /*for(int i=0;i<userArray.length;i++){
   userArray[i] = new User(i);
   }
   for(int i=0;i<planetArray.length;i++){
   planetArray[i] = new Planet(i);
   }*/

  minim = new Minim(this);

  cp5 = new ControlP5(this);

  player1 = minim.loadFile("5.mp3", 2048);
  player1.setGain(soundOne);
  player1.loop();

  player2 = minim.loadFile("2.mp3", 2048);
  player2.setGain(soundTwo);
  player2.loop();

  player3 = minim.loadFile("3.mp3", 2048);
  player3.setGain(soundThree);
  player3.loop();

  player4 = minim.loadFile("4.mp3", 2048);
  player4.setGain(soundFour);
  player4.loop();

  player5 = minim.loadFile("6.mp3", 2048);
  player5.setGain(soundFive);
  player5.loop();  

  player6 = minim.loadFile("1.mp3", 2048);
  player6.setGain(soundSix);
  player6.loop();

  a = loadImage("bg.png"); 
  b = loadImage("b.png"); 

  // By default all controllers are stored inside Tab 'default' 
  // add a second tab with name 'extra'

  cp5.addTab("extra")
    .setColorBackground(color(0, 160, 100))
      .setColorLabel(color(255))
        .setColorActive(color(255, 128, 0))
          ;

  // if you want to receive a controlEvent when
  // a  tab is clicked, use activeEvent(true)

  cp5.getTab("default")
    .activateEvent(true)
      .setLabel("my default tab")
        .setId(1)
          ;

  cp5.getTab("extra")
    .activateEvent(true)
      .setId(2)
        ;


  // create a few controllers

  Group g1 = cp5.addGroup("g1")
    .setPosition(100, 100)
      .setWidth(110)
        .setBackgroundHeight(150)
          .setBackgroundColor(color(50))
            .setLabel("drawBlobsAndEdges")
              ;

  // create a toggle
  cp5.addToggle("drawBlobs")
    .setPosition(10, 20)
      .setSize(50, 20)
        .setGroup(g1)
          ;

  // create a toggle
  cp5.addToggle("drawEdges")
    .setPosition(10, 60)
      .setSize(50, 20)
        .setGroup(g1)
          ;

  // create a toggle
  cp5.addToggle("drawCentroids")
    .setPosition(10, 100)
      .setSize(50, 20)
        .setGroup(g1)
          ;        

  Group g2 = cp5.addGroup("g2")
    .setPosition(300, 100)
      .setWidth(300)
        .activateEvent(true)
          .setBackgroundColor(color(80))
            .setBackgroundHeight(100)
              .setLabel("theBlobDetection")
                ;

  // create a toggle and change the default look to a (on/off) switch look
  cp5.addToggle("setPosDiscrimination")
    .setPosition(10, 10)
      .setSize(50, 20)
        .setValue(true)
          .setMode(ControlP5.SWITCH)
            .setGroup(g2)
              ;

  // add a vertical slider
  cp5.addSlider("setThreshold")
    .setPosition(10, 50)
      .setSize(200, 20)
        .setRange(0.0f, 1.0f)
          .setValue(0.2f)
            .setGroup(g2)
              ;

  // reposition the Label for controller 'slider'
  cp5.getController("setThreshold").getValueLabel().align(ControlP5.LEFT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
  cp5.getController("setThreshold").getCaptionLabel().align(ControlP5.RIGHT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);

  // arrange controller in separate tabs

  cp5.getGroup("g1").moveTo("extra");
  cp5.getGroup("g2").moveTo("extra");
  //cp5.getController("slider").moveTo("global");

  // Tab 'global' is a tab that lies on top of any 
  // other tab and is always visible
}

// ==================================================
// setPosDiscrimination()
// ==================================================
void setPosDiscrimination(boolean theFlag) {
  if (theFlag==true) {
    theBlobDetection.setPosDiscrimination(true);
  } 
  else {
    theBlobDetection.setPosDiscrimination(false);
  }
  println("a toggle event.");
}

// ==================================================
// setThreshold()
// ==================================================
void setThreshold(float setThreshold) {
  theBlobDetection.setThreshold(setThreshold);
  println("a slider event. setting background to "+setThreshold);
}

// ==================================================
// controlEvent()
// ==================================================
void controlEvent(ControlEvent theControlEvent) {
  if (theControlEvent.isTab()) {
    println("got an event from tab : "+theControlEvent.getTab().getName()+" with id "+theControlEvent.getTab().getId());
  }
  else if (theControlEvent.isGroup()) {
    println("got an event from group "
      +theControlEvent.group().name()
      +", isOpen? "+theControlEvent.group().isOpen()
      );
  } 
  else if (theControlEvent.isController()) {
    println("got something from a controller "
      +theControlEvent.controller().name()
      );
  }
}

// ==================================================
// keyPressed()
// ==================================================
void keyPressed() {
  if (keyCode==TAB) {
    cp5.getTab("extra").bringToFront();
  }
}

// ==================================================
// captureEvent()
// ==================================================
void captureEvent(Capture cam)
{
  cam.read();
  newFrame = true;
}

// ==================================================
// draw()
// ==================================================
void draw()
{
  smooth();
  if (newFrame)
  {
    newFrame=false;
    cam.loadPixels();

    // Create an opaque image of the same size as the original
    PImage edgeImg = createImage(cam.width, cam.height, RGB);

    // Loop through every pixel in the image.
    for (int y = 0; y < cam.height; y++) {
      for (int x = 0; x < cam.width; x++) {

        // Where are we, pixel-wise?
        int loc = (cam.width - x - 1) + y*cam.width; // Reversing x to mirror the image

        float r = red(cam.pixels[loc]);
        float g = green(cam.pixels[loc]);
        float b = blue(cam.pixels[loc]);
        // Make a new color with an alpha component
        color c = color(r, g, b);
        edgeImg.pixels[y*cam.width+x] = c;
      }//
    }//end of for loop
    // State that there are changes to edgeImg.pixels[]
    edgeImg.updatePixels();
    if (cp5.getTab("extra").isActive()) {
      image(edgeImg, 0, 0, width, height);
    } 
    else {
      //background(0,102);
      fill(0x66000000);
      noStroke();
      rect(0, 0, 1280, 800);
      image(a, 0, 0);
      //draw our users  
      for (int i=0; i<users.size();i++) {
        User temp = (User) users.get(i);
        temp.update();
      }
      //draw our planets  
      for (int i=0; i<planets.size();i++) {
        Planet temp = (Planet) planets.get(i);
        for(int j = 0; j<users.size();j++){
           User tempU = (User) users.get(j);
             if(hitTest(tempU, temp)) {
               println("here");
               temp.grow();
               } else {
               temp.update();
               }
        }//end od j
      }//end of i

      img.copy(edgeImg, 0, 0, cam.width, cam.height, 
      0, 0, img.width, img.height);
      fastblur(img, 2);
      theBlobDetection.computeBlobs(img.pixels);
      drawBlobsAndEdges(drawBlobs, drawEdges, drawCentroids);
    }
  }
}


boolean hitTest(User p1, Planet e1) {
//return true;
return(p1.x<e1.x+e1.width&& p1.x+p1.width>e1.x && p1.y<e1.y+e1.height && p1.y+p1.height>e1.y);
//}
}

// ==================================================
// hitTest()
// ==================================================
//boolean hitTest(User p1, Planet e1) {
//return true;
//return(p1.x<e1.x+e1.width&& p1.x+p1.width>e1.x && p1.y<e1.y+e1.height && p1.y+p1.height>e1.y);
//}
// ==================================================
// drawBlobsAndEdges()
// ==================================================
void drawBlobsAndEdges(boolean drawBlobs, boolean drawEdges, boolean drawCentroids)
{
  noFill();
  Blob b;
  EdgeVertex eA, eB;
  for (int n=0 ; n<theBlobDetection.getBlobNb() ; n++)
  {
    b=theBlobDetection.getBlob(n);
    if (b!=null)
    {
      // Edges
      if (drawEdges)
      {
        strokeWeight(3);
        stroke(0, 255, 0);
        for (int m=0;m<b.getEdgeNb();m++)
        {
          eA = b.getEdgeVertexA(m);
          eB = b.getEdgeVertexB(m);
          if (eA !=null && eB !=null)
            line(
            eA.x*width, eA.y*height, 
            eB.x*width, eB.y*height
              );
        }
      }

      // Blobs
      if (drawBlobs)
      {
        strokeWeight(1);
        stroke(255, 0, 0);
        rect(
        b.xMin*width, b.yMin*height, 
        b.w*width, b.h*height
          );
      }

      // Centroids
      if (drawCentroids)
      {
        strokeWeight(1);
        stroke(0, 0, 255);
        line(
        b.x*width-5, b.y*height, 
        b.x*width+5, b.y*height
          );
        line(
        b.x*width, b.y*height-5, 
        b.x*width, b.y*height+5
          );
      }

      //move the objects
      //if (vals[0]==1) {
      for (int i = 0; i<users.size();i++) {
        User temp = (User) users.get(i);
        //if the message user id and temp user id matches
        if (n == temp.id) {
          temp.targetX = b.x*width;
          temp.targetY = b.y*height;
        }
      }//end of for loop
      //}//end of move code
    }
  }
}

// ==================================================
// Super Fast Blur v1.1
// by Mario Klingemann 
// <http://incubator.quasimondo.com>
// ==================================================
void fastblur(PImage img, int radius)
{
  if (radius<1) {
    return;
  }
  int w=img.width;
  int h=img.height;
  int wm=w-1;
  int hm=h-1;
  int wh=w*h;
  int div=radius+radius+1;
  int r[]=new int[wh];
  int g[]=new int[wh];
  int b[]=new int[wh];
  int rsum, gsum, bsum, x, y, i, p, p1, p2, yp, yi, yw;
  int vmin[] = new int[max(w, h)];
  int vmax[] = new int[max(w, h)];
  int[] pix=img.pixels;
  int dv[]=new int[256*div];
  for (i=0;i<256*div;i++) {
    dv[i]=(i/div);
  }

  yw=yi=0;

  for (y=0;y<h;y++) {
    rsum=gsum=bsum=0;
    for (i=-radius;i<=radius;i++) {
      p=pix[yi+min(wm, max(i, 0))];
      rsum+=(p & 0xff0000)>>16;
      gsum+=(p & 0x00ff00)>>8;
      bsum+= p & 0x0000ff;
    }
    for (x=0;x<w;x++) {

      r[yi]=dv[rsum];
      g[yi]=dv[gsum];
      b[yi]=dv[bsum];

      if (y==0) {
        vmin[x]=min(x+radius+1, wm);
        vmax[x]=max(x-radius, 0);
      }
      p1=pix[yw+vmin[x]];
      p2=pix[yw+vmax[x]];

      rsum+=((p1 & 0xff0000)-(p2 & 0xff0000))>>16;
      gsum+=((p1 & 0x00ff00)-(p2 & 0x00ff00))>>8;
      bsum+= (p1 & 0x0000ff)-(p2 & 0x0000ff);
      yi++;
    }
    yw+=w;
  }

  for (x=0;x<w;x++) {
    rsum=gsum=bsum=0;
    yp=-radius*w;
    for (i=-radius;i<=radius;i++) {
      yi=max(0, yp)+x;
      rsum+=r[yi];
      gsum+=g[yi];
      bsum+=b[yi];
      yp+=w;
    }
    yi=x;
    for (y=0;y<h;y++) {
      pix[yi]=0xff000000 | (dv[rsum]<<16) | (dv[gsum]<<8) | dv[bsum];
      if (x==0) {
        vmin[y]=min(y+radius+1, hm)*w;
        vmax[y]=max(y-radius, 0)*w;
      }
      p1=x+vmin[y];
      p2=x+vmax[y];

      rsum+=r[p1]-r[p2];
      gsum+=g[p1]-g[p2];
      bsum+=b[p1]-b[p2];

      yi+=w;
    }
  }
}

