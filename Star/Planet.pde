class Planet {
  int id;
  float x = random(1024);//xpos
  float y = random(768);//ypos
  float sz = random(5, 55); //planetSize
  color c = color(random(50,255), random(50,255), random(50,255)); //RGB
  float a = 0; //stroke/planet alpha (?)
  float width = sz; //sets width height for the planet
  float height = sz;
  //float mySize; //stores size of individual planet?
  //float myAlpha;//stores alpha of individual planet?

  Planet(int idee) {
    id = idee;
  }

  void update() {
    noStroke();
    fill(c,a);
    ellipse(x, y, sz, sz);
    if (a > 10) {
      a--;
    } 
    else {
      a=10;
    }
  }

  void grow() {
    a+=2;
    noStroke();
    fill(c,a);
    ellipse(x, y, sz, sz);

    noFill();
    strokeWeight(10);
    stroke(c, a);
    ellipse(x, y, a*2, a*2);

    player1.setGain(soundOne);
    player1.setGain(soundTwo);
    player1.setGain(soundThree);
    player1.setGain(soundFour);
    player1.setGain(soundFive);

    if (sz > 5 && sz < 15) {
      if (soundOne<10) {
        soundOne=soundOne+.05;
      }
    }
    else if (sz > 15 && sz < 25) {
      if (soundTwo<10) {
        soundTwo=soundTwo+.05;
      }
    }
    else if (sz > 25 && sz < 35) {
      if (soundThree<10) {
        soundThree=soundThree+.05;
      }
    }
    else if (sz > 35 && sz < 45) {
      if (soundFour<10) {
        soundFour=soundFour+.05;
      }
    }
    else if (sz > 45 && sz < 50) {
      if (soundFive<10) {
        soundFive=soundFive+.05;
      }
    }
  }
}

