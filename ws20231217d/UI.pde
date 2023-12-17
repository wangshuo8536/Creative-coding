import controlP5.*;
import peasy.*;

ControlP5 slider;
PeasyCam cam;

void UI() {
  int sliderWidth = 300;//控制条宽度
  int sliderHeight = 30;//控制条高度

  cam = new PeasyCam(this, 800);

  slider = new ControlP5(this, createFont("微软雅黑", 14));

  slider.addSlider("heightSection")//花瓶高度细分数
    .setPosition(20, 20)
    .setSize(sliderWidth, sliderHeight)
    .setRange(1, 72)
    .setValue(36)
    ;

  slider.addSlider("laySection")//花瓶每层扇面细分数
    .setPosition(20, 60)
    .setSize(sliderWidth, sliderHeight)
    .setRange(3, 128)
    .setValue(72)
    ;

  slider.addSlider("layerHeight")//每层高度
    .setPosition(20, 100)
    .setSize(sliderWidth, sliderHeight)
    .setRange(0, 200)
    .setValue(20)
    ;

  slider.addSlider("rotateRange")//花瓶轴向扭曲弧度值
    .setPosition(20, 140)
    .setSize(sliderWidth, sliderHeight)
    .setRange(0, PI*8)
    .setValue(PI)
    ;

  slider.addSlider("ProbOfShowShape")//每个菱形单元的显示概率
    .setPosition(20, 180)
    .setSize(sliderWidth, sliderHeight)
    .setRange(0, 1)
    .setValue(0.75)
    ;

  slider.addSlider("ProbOfShowContourShape")//每个菱形单元绘制内轮廓的概率
    .setPosition(20, 220)
    .setSize(sliderWidth, sliderHeight)
    .setRange(0, 1)
    .setValue(0.5)
    ;

  slider.addToggle("showNormal")//显示菱形单元法线
    .setPosition(20, height-100)
    .setSize(sliderWidth/3, sliderHeight)
    .setValue(true)
    .setMode(ControlP5.SWITCH)
    ;

  slider.setAutoDraw(false);
}

void showNormal(boolean theFlag) {
  if (theFlag==true) {
    showNormalLine = true;
  } else {
    showNormalLine = false;
  }
}

void controlEvent(ControlEvent theEvent) {
  if (theEvent.isFrom(slider.getController("heightSection")) ||
    theEvent.isFrom(slider.getController("laySection")) ||
    theEvent.isFrom(slider.getController("layerHeight")) ||
    theEvent.isFrom(slider.getController("rotateRange")) ||
    theEvent.isFrom(slider.getController("ProbOfShowShape")) ||
    theEvent.isFrom(slider.getController("ProbOfShowContourShape"))) {
    setSystem();
  }
}
