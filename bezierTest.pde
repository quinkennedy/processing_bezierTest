import geomerative.*;
import org.apache.batik.svggen.font.table.*;
import org.apache.batik.svggen.font.*;

int fontSize = 75;
boolean drawWord = false;
int groupSize = 12;

void setup(){
  size(800, 400);
  noLoop();
  RG.init(this);
}

void draw(){
  background(255);
  noFill();
  stroke(0);
  //drawString("QUIN KENNEDY");
  //drawString("JESSICA WONG");
  drawLines(new String[]{"Paul D Quin", "     +     ", "Vince Blaskovich"});
  //translate(0, fontSize);
  //drawString("Paul D Quin\n     +     \nVince Blaskovich");
  //drawFont("Paul D Quin\n     +     \nVince Blaskovich");
  //test();
}

void drawLines(String s[]){
  for(int i = 0; i < s.length; i++){
    pushMatrix();
    translate(0, (i+1)*fontSize);
    if (drawWord){
      drawFont(s[i]);
    } else {
      drawString(s[i]);
    }
    popMatrix();
  }
}

void drawString(String s){
  pushMatrix();
  pushMatrix();
  for(int i = 0; i < s.length(); i++){
    if (s.charAt(i) == '\n'){
      popMatrix();
      translate(0, fontSize);
      pushMatrix();
      continue;
    }
    translate(fontSize/2, 0);
    if (s.charAt(i) == ' '){
      continue;
    }
    drawFont(s.substring(i, i+1));
  }
  popMatrix();
  popMatrix();
}

void drawFont(String s){
  //println((String[])PFont.list());
  //println("haha");
  pushMatrix();
  translate(fontSize/2, 0);
  RFont f = new RFont("/Library/Fonts/Ayuthaya.ttf", fontSize, RFont.LEFT);
  RGroup g = f.toGroup(s);
  RCommand.setSegmentLength(5);
  RCommand.setSegmentator(RCommand.UNIFORMLENGTH);
  g = g.toPolygonGroup();
  RPoint rPoints[] = g.getPoints();
  PVector points[] = new PVector[rPoints.length];
  for(int i = 0; i < points.length; i++){
    points[i] = new PVector(rPoints[i].x, rPoints[i].y);
  }
  //drawBezier(points);
  drawBezierSegments(points, groupSize);
  //drawControls(points);
  popMatrix();
}

void drawBezierSegments(PVector points[], int SegmentLength){
  for(int i = 0; i + SegmentLength <= points.length; i+= SegmentLength-1){
    drawBezier(points, i, SegmentLength);
  }
}

void test(){
  noFill();
  stroke(0,255,0);
  bezier(10, 10, 10, 100, 100, 50, 150, 150);
  
  stroke(255,0,0);
  PVector points[] = new PVector[]{new PVector(10, 10),
    new PVector(10, 100),
    new PVector(100, 50),
    new PVector(150, 150)};/*
    new PVector(50, 100),
    new PVector(300, 120),
    new PVector(40, 190)};*/
  drawBezier(points); 
  stroke(0, 0, 0);
  drawControls(points);
}

void drawControls(PVector points[]){
  for(int i = 0; i < points.length; i++){
    point(points[i].x, points[i].y);
  }
}

void drawBezier(PVector points[]){
  drawBezier(points, 0, points.length);
}

void drawBezier(PVector points[], int nStart, int nLength){
  beginShape();
  for(float i = 0; i <= 1.0; i += 0.01){
    PVector curr = bezierAt(points, nStart, nLength, i);
    //point(curr.x, curr.y);
    curveVertex(curr.x, curr.y);
  }
  endShape();
}

PVector bezierAt(PVector points[], int iStart, int nLength, float nLocation){
  PVector one, two;
  if (nLength > 2){
    int subLength = nLength/2+1;
    one = bezierAt(points, iStart, subLength, nLocation);
    two = bezierAt(points, iStart + nLength - subLength, subLength, nLocation);
  } else {
    one = points[iStart];
    two = points[iStart+1];
  }
  return new PVector((two.x-one.x)*nLocation+one.x, (two.y-one.y)*nLocation+one.y);
}
