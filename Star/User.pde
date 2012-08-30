class User {
  int id;
  float x;
  float y;
  float targetX, targetY;
  float easing = 0.025;
  float radius = 10.0;
  float width = 100;
  float height = 100;
  color c = color(random(180,255), random(180,255), random(180,255));

  Boolean started = false;

  User(int idee) {
    id = idee;
  }

  void update() {
    
    radius = radius + sin( frameCount / 4 );

    //targetX = mouseX;
    float dx = targetX - x;
    if (abs(dx) > 1) {
      x += dx * easing;
    }

    //targetY = mouseY;
    float dy = targetY - y;
    if (abs(dy) > 1) {
      y += dy * easing;
    }
    fill(c);
    strokeWeight(2);
    stroke(255);
    ellipse(x, y, radius, radius);
  }
}
