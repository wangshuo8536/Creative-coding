float z = 0;

ArrayList fractals;

void setup(){
  size(600, 600, P3D);
  fractals = new ArrayList();
  fractals.add(new Fractal(80.0, 20.0, random(10, 90), 1.1));
}

void draw(){

  //if (mousePressed){
  //  z += 4;  
  //}
  //else{
  //  z -= 0.5;
  //}
  
  // use mouse wheel to control z value
  z = constrain(z, 0, 500);
  translate(width/2, height/2, z);
  float camy = map(radians(mouseX), 0, 14, 0, TWO_PI);
  float camx = map(radians(mouseY), 0, 14, 0, TWO_PI);

  rotateX(camx*2);
  rotateY(camy);
  background(0, 0, 25);
  stroke(155, 100, 255, 155);

  for (int i=fractals.size()-1; i>=0; i--){
    Fractal fractal = (Fractal) fractals.get(i);
    fractal.draw();
    //if (keyPressed == true){
    //  fractals.remove(i);
    //  fractals.add(new Fractal(70.0, 20.0, random(10, 90), random(0.2, 1.1)));
    //}
    
    // use right mouse button to replace key press
    if (mousePressed && mouseButton == RIGHT) {
      fractals.remove(i);
      fractals.add(new Fractal(70.0, 20.0, random(10, 90), random(0.2, 1.1)));
    }
  }
  println ("frameRate;"+frameRate);
  saveFrame();
}
class Fractal{
  float b;
  float g;
  float r;
  float fac;

  Fractal(float ib, float ig, float ir, float ifac){
    b = ib;
    g = ig;
    r = ir;
    fac = ifac;
  }

  void draw(){
    //line(0, 0, 0, 60);
    branch(b, g, r, fac);
  }

  void branch(float b, float g, float r, float fac){
    b*=0.8;
    r*=fac;
    if (b > g){
      pushMatrix();
      rotateX(r);
      //line(0, 0, 0, -b);
      //circle(0, -b/2, b); // draw a circle instead of a line
      sphereDetail(10); // set the sphere detail to 10
      sphere(b/2); // draw a sphere instead of a circle
      translate(0, -b);
      branch(b, g, r, fac);
      popMatrix();

      pushMatrix();
      rotateX(-r);
      //line(0, 0, 0, -b);
      //circle(0, -b/2, b); // draw a circle instead of a line
      sphereDetail(10); // set the sphere detail to 10
      sphere(b/2); // draw a sphere instead of a circle
      translate(0, -b);
      branch(b, g, r, fac);
      popMatrix();

      pushMatrix();
      rotateZ(r);
      //line(0, 0, 0, -b);
      //circle(0, -b/2, b); // draw a circle instead of a line
      sphereDetail(10); // set the sphere detail to 10
      sphere(b/2); // draw a sphere instead of a circle
      translate(0, -b);
      branch(b, g, r, fac);
      popMatrix();

      pushMatrix();
      rotateZ(-r);
      //line(0, 0, 0, -b);
      //circle(0, -b/2, b); // draw a circle instead of a line
      sphereDetail(10); // set the sphere detail to 10
      sphere(b/2); // draw a sphere instead of a circle
      translate(0, -b);
      branch(b, g, r, fac);
      popMatrix();
    }
  }
}

// add a mouse wheel event listener
void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  //println(e); // print the wheel count
  if (e > 0) { // wheel up
    z += e * 16; // increase z value
  } else { // wheel down
    z += e * 1; // decrease z value
  }
}
