/******************
Code by Bing
Inspired by Vamoss
Original code link:
https://www.openprocessing.org/sketch/873380
******************/

//Image from Wikipedia
//https://en.wikipedia.org/wiki/Girl_with_a_Pearl_Earring

ArrayList<Seed> seeds = new ArrayList<Seed>();
ArrayList<Tree> trees = new ArrayList<Tree>();
ArrayList<Leaf> leaves = new ArrayList<Leaf>();

int ground, treeTop;
boolean firstClick = true;

PImage img;

void setup() {
  size(800, 800);
  background(0);
  
  ground = height - 30;
  treeTop = height - 600;
  
  textAlign(CENTER, CENTER);
  textSize(40);
  fill(255);
  text("Click to drop seed", width/2, height/2);
  
  img = loadImage("girl.jpg"); //change the image file name
}

void draw() {
  //SEEDS
  strokeWeight(4);
  stroke(0);
  fill(255);
  for (int i = seeds.size() - 1; i >= 0; i--) {
    Seed seed = seeds.get(i);
    seed.y += 30; //increase the falling speed
    if (seed.y > ground) {
      //transform seed in tree
      seeds.remove(i);
      trees.add(new Tree(seed.x, ground));
    } else {
      ellipse(seed.x, seed.y, 10, 10);
    }
  }
  
  //BRANCHS
  noStroke();
  for (int i = trees.size() - 1; i >= 0; i--) {
    Tree tree = trees.get(i);
    tree.dir += (noise(tree.phase + millis()/100) - 0.5) / 3;
    tree.dir += (PI - tree.dir) * 0.09 / (tree.generation + 1);//point north
    tree.pos.x += sin(tree.dir) * 2;
    tree.pos.y += cos(tree.dir) * 2;
    fill(lerpColor(color(255), color(139, 69, 19), tree.generation/10));
    rectMode(CENTER);
    rect(tree.pos.x, tree.pos.y, tree.radius * 2, tree.radius * 2);
    
    //shadow the branch
    filter(INVERT); //invert the color
    filter(BLUR, 6); //blur the image
    fill(0);
    for (float j = 0; j < PI; j += PI/10) {
      float x = cos(j) * tree.radius;
      float y = sin(j) * tree.radius;
      ellipse(tree.pos.x + x, tree.pos.y + y, j, j);
    }
    filter(INVERT); //invert the color back
    filter(BLUR, -6); //unblur the image
    //note: the filter() function affects the whole image, not just the branch
    
    tree.radius *= 0.99 / (tree.generation/300 + 1); //decrease the radius
    tree.life = (int) random(150, 600) / (tree.generation / 10 + 1); //increase the life
    
    if (tree.life < 0) {
      trees.remove(i);
      if (tree.radius > 3) {
        //transform root in branchs
        trees.add(new Tree(tree.pos.x, tree.pos.y, tree));
        trees.add(new Tree(tree.pos.x, tree.pos.y, tree));
      } else {
        //transform final branch in leaves
        leaves.add(new Leaf(tree.pos.x, tree.pos.y));
      }
    }
  }
  
  //LEAVES
  noStroke();
  int w = width / 2 - img.width / 2;
  for (int i = leaves.size() - 1; i >= 0; i--) {
    Leaf leaf = leaves.get(i);
    float x = leaf.pos.x + random(-50, 50);
    float y = leaf.pos.y + random(-50, 50);
    fill(img.get(mod(floor(x - w), img.width), mod(floor(y - treeTop), img.height)));
    float size = random(3, 10);
    pushMatrix();
      translate(x, y);
      rotate(random(TWO_PI));
      point(0, 0); //change ellipse to point
    popMatrix();
    
    leaf.life--;
    if (leaf.life < 0) {
      leaves.remove(i);
    }
  }
}

void mousePressed() {
  if (firstClick) {
    firstClick = false;
    background(0);
  }
  seeds.add(new Seed(mouseX, mouseY));
}

//delete mouseDragged() function
/*
void mouseDragged() {
  seeds.add(new Seed(mouseX, mouseY));
}
*/

class Seed {
  float x, y;
  
  Seed(float x, float y) {
    this.x = x;
    this.y = y;
  }
}

class Tree {
  PVector pos;
  float phase;
  float dir;
  float radius;
  int life;
  int generation;
  
  Tree(float x, float y) {
    this(x, y, null);
  }
  
  Tree(float x, float y, Tree root) {
    if (root == null) {
      pos = new PVector(x, y);
      dir = PI;
      radius = random(10, 30);
      generation = 0;
    } else {
      pos = root.pos.copy();
      dir = root.dir;
      radius = root.radius;
      generation = root.generation + 1;
    }
    phase = random(1000);
    life = (int) random(30, 120) / (generation / 10 + 1);
  }
}

class Leaf {
  PVector pos;
  int life;
  
  Leaf(float x, float y) {
    pos = new PVector(x, y);
    life = (int) random(20, 60);
  }
}

int mod(int m, int n) {
  return ((m % n) + n) % n;
}
