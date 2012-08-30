class User {
 int id;
 float x;
 float y;
 float targetX, targetY;
 float easing = 0.05;
 
 Boolean started = false;
 
 User(int idee, float xpos, float ypos) {
  id = idee;
  x = xpos;
  y = ypos;
 }

 void update(){
  
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
