import ddf.minim.*;
import ddf.minim.analysis.*;
import controlP5.*; //导入controlP5库

Minim minim;
AudioPlayer song;
FFT fft;

ControlP5 slider; //定义一个控制条对象

int numParticles = 1024; //粒子数量
Particle[]particles = new Particle[numParticles]; //粒子数组

void setup() {
  size(800, 600); //改变画框的大小
  minim = new Minim(this);
  song = minim.loadFile("audio_file.mp3");
  fft = new FFT(song.bufferSize(), song.sampleRate());
  for (int i = 0; i < numParticles; i++) {
    particles[i] = new Particle();
  }
  song.loop();
  UI(); //调用UI函数，创建控制界面
}

void draw() {
  background(0);
  fft.forward(song.mix);
  for (int i = 0; i < numParticles; i++) {
    float amplitude = fft.getBand(i%fft.specSize()); //获取频谱的值
    particles[i].update(amplitude); //更新粒子的位置和颜色
    particles[i].display(); //显示粒子
  }
  slider.draw(); //绘制控制界面
}

class Particle{
  float x;
  float y;
  float r;
  float hue;
  int shape; //粒子的形状，0为圆形，1为矩形，2为三角形
  
  Particle(){
  x = random(width);
  y = random(height);
  r = random(4,20); //增加粒子的大小范围
  hue = random(360);
  shape = 0;
  }
  
  void update(float amplitude){
  y = height - amplitude * 4; //根据频谱的值改变y坐标
  hue = (hue + 0.1) % 360; //根据频谱的值改变颜色
  }
  
  void display(){
  fill(hue, 255, 255); //使用HSB色彩模式
  noStroke();
  pushMatrix(); //保存当前坐标系
  translate(x, y); //移动到粒子的位置
  rotate(frameCount * 0.01); //旋转粒子
  switch(shape){ //根据粒子的形状绘制不同的图形
    case 0: //圆形
      ellipse(0, 0, r, r);
      break;
    case 1: //矩形
      rectMode(CENTER);
      rect(0, 0, r, r);
      break;
    case 2: //三角形
      triangle(0, -r/2, -r/2, r/2, r/2, r/2);
      break;
  }
  popMatrix(); //恢复之前的坐标系
  }
}

void UI() {
  int sliderWidth = 300;//控制条宽度
  int sliderHeight = 30;//控制条高度

  slider = new ControlP5(this, createFont("微软雅黑", 14)); //创建一个控制条对象，使用微软雅黑字体

  slider.addSlider("numParticles")//粒子数量
    .setPosition(20, 20)
    .setSize(sliderWidth, sliderHeight)
    .setRange(1, 1024)
    .setValue(1024)
    ;

  slider.addSlider("particleSize")//粒子大小
    .setPosition(20, 60)
    .setSize(sliderWidth, sliderHeight)
    .setRange(1, 20)
    .setValue(10)
    ;

  slider.addSlider("particleColor")//粒子颜色
    .setPosition(20, 100)
    .setSize(sliderWidth, sliderHeight)
    .setRange(0, 360)
    .setValue(180)
    ;

  slider.addButton("circle")//圆形按钮
    .setPosition(20, 140)
    .setSize(sliderWidth/3, sliderHeight)
    .setLabel("Circle")
    ;

  slider.addButton("square")//矩形按钮
    .setPosition(20 + sliderWidth/3, 140)
    .setSize(sliderWidth/3, sliderHeight)
    .setLabel("Square")
    ;

  slider.addButton("triangle")//三角形按钮
    .setPosition(20 + sliderWidth*2/3, 140)
    .setSize(sliderWidth/3, sliderHeight)
    .setLabel("Triangle")
    ;

  slider.setAutoDraw(false); //关闭自动绘制
}

void numParticles(float theValue) { //当粒子数量滑动条改变时，调用这个函数
  numParticles = int(theValue); //更新粒子数量
  particles = new Particle[numParticles]; //重新创建粒子数组
  for (int i = 0; i < numParticles; i++) { //初始化每个粒子
    particles[i] = new Particle();
  }
}

void particleSize(float theValue) { //当粒子大小滑动条改变时，调用这个函数
  for (int i = 0; i < numParticles; i++) { //遍历每个粒子
    particles[i].r = theValue; //更新粒子的大小
  }
}

void particleColor(float theValue) { //当粒子颜色滑动条改变时，调用这个函数
  for (int i = 0; i < numParticles; i++) { //遍历每个粒子
    particles[i].hue = theValue; //更新粒子的颜色
  }
}

void circle() { //当圆形按钮被按下时，调用这个函数
  for (int i = 0; i < numParticles; i++) { //遍历每个粒子
    particles[i].shape = 0; //更新粒子的形状为圆形
  }
}

void square() { //当矩形按钮被按下时，调用这个函数
  for (int i = 0; i < numParticles; i++) { //遍历每个粒子
    particles[i].shape = 1; //更新粒子的形状为矩形
  }
}

void triangle() { //当三角形按钮被按下时，调用这个函数
  for (int i = 0; i < numParticles; i++) { //遍历每个粒子
    particles[i].shape = 2; //更新粒子的形状为三角形
  }
}
