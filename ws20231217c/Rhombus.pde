class Rhombus {
  PVector[] rhomVertex;//菱形四个点向量
  PVector[] contourVertex;//菱形四个内轮廓向量
  float contourRatio = 0.25;//内轮廓宽度比例：值越小内轮廓宽度越大，中间孔洞越小
  PVector center;//菱形中心点向量
  PVector normal;//菱形法线向量
  boolean drawShape;//是否绘制菱形
  boolean drawContour;//是否绘制菱形内轮廓
  
  //构造函数
  Rhombus(PVector p1, PVector p2, PVector p3, PVector p4) {//传递菱形的四个向量数据
    rhomVertex = new PVector[4];
    contourVertex = new PVector[rhomVertex.length];
    rhomVertex[0] = p1;
    rhomVertex[1] = p2;
    rhomVertex[2] = p3;
    rhomVertex[3] = p4;
    center = ct();//获得菱形中心点向量值
    normal = calcuNormal();//获得菱形法线向量值
    contourVertex = contour();//获得菱形四个内轮廓向量值
  }

  void run() {
    if (drawShape) {
      if (drawContour) {
        drawRhombusContour();//绘制菱形内轮廓
      } else {
        drawRhombus();//绘制菱形
      }
      if (showNormalLine) {
        displayNormal();//绘制法线
      }
    }
  }
  PVector calcuNormal() {
    PVector p1p2 = PVector.sub(rhomVertex[1], rhomVertex[0]);
    PVector p1p3 = PVector.sub(rhomVertex[2], rhomVertex[0]);
    PVector norm = p1p2.cross(p1p3);
    return norm;
  }

  PVector[] contour() {
    PVector[] ctmp = new PVector[contourVertex.length];
    for (int i = 0; i < rhomVertex.length; i ++) {
      PVector tmp = PVector.sub(rhomVertex[i], center);
      float len = tmp.mag();
      len *= contourRatio;
      tmp.normalize();
      tmp.setMag(len);
      tmp.add(center);
      ctmp[i] = new PVector(tmp.x, tmp.y, tmp.z);
    }
    return ctmp;
  }

  void drawRhombusContour() {
    stroke(0);
    strokeWeight(1);
    fill(255);

    for (int i = 0; i < 4; i ++) {
      beginShape(QUAD);
      vertex(rhomVertex[i].x, rhomVertex[i].y, rhomVertex[i].z);
      vertex(contourVertex[i].x, contourVertex[i].y, contourVertex[i].z);
      vertex(contourVertex[(i+1)%4].x, contourVertex[(i+1)%4].y, contourVertex[(i+1)%4].z);
      vertex(rhomVertex[(i+1)%4].x, rhomVertex[(i+1)%4].y, rhomVertex[(i+1)%4].z);
      endShape();
    }
  }

  void drawRhombus() {
    beginShape(QUAD);
    stroke(0);
    strokeWeight(1);
    fill(255);
    for (int i = 0; i < rhomVertex.length; i ++) {
      vertex(rhomVertex[i].x, rhomVertex[i].y, rhomVertex[i].z);
    }
    endShape();
  }

  /**
   * [ct description]
   * @Author   bit2atom
   * @DateTime 2022-10-20T21:22:54+0800
   * @return   {[PVector]}                 [计算菱形中心点向量]
   */
  PVector ct() {
    float cx = 0;
    float cy = 0;
    float cz = 0;

    for (int i = 0; i < rhomVertex.length; i ++) {
      cx += rhomVertex[i].x;
      cy += rhomVertex[i].y;
      cz += rhomVertex[i].z;
    }

    cx /= 4.0;
    cy /= 4.0;
    cz /= 4.0;
    PVector cv = new PVector(cx, cy, cz);

    return cv;
  }

  void displayNormal() {
    PVector nm = new PVector(normal.x, normal.y, normal.z);
    nm.normalize();//法线向量归一化
    nm.setMag(10);//设置法线长度为10
    nm.add(center);
    stroke(0);
    strokeWeight(3);
    point(center.x, center.y, center.z);//菱形中心点
    stroke(200, 0, 200);
    strokeWeight(1);
    line(center.x, center.y, center.z, nm.x, nm.y, nm.z);//从菱形中心点向发现顶点绘制一条直线
  }
}
