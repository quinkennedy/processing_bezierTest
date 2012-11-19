import controlP5.*;
import geomerative.*;
import org.apache.batik.svggen.font.table.*;
import org.apache.batik.svggen.font.*;

int fontSize = 75;
boolean drawWord = true;
int groupSize = 9;
int fontFidelity = 5;
ControlP5 cp5;
boolean needsUpdate = true;
String[] fontList;
String fontPath = "/Library/Fonts";
String currFont = fontPath+"/Ayuthaya.ttf";

void setup(){
  size(800, 400);
  RG.init(this);
  fontList = getFontList();
  setupControl();
}

void setupControl(){
  cp5 = new ControlP5(this);
  
  cp5.addNumberbox("nbGrouping")
     .setPosition(0,0)
     .setSize(100,14)
     .setScrollSensitivity(1.1)
     .setValue(groupSize)
     ;//minimum of 2
  cp5.addNumberbox("nbFontSize")
     .setPosition(110, 0)
     .setSize(100, 14)
     .setScrollSensitivity(1.1)
     .setValue(fontSize)
     ;//minimum of.. 1?
  cp5.addNumberbox("nbFontFidelity")
     .setPosition(220, 0)
     .setSize(100, 14)
     .setScrollSensitivity(1.1)
     .setValue(fontFidelity)
     ;//minimum of.. 1?
    // create a toggle
  cp5.addToggle("tWholeWord")
     .setPosition(330,0)
     .setSize(50,20)
     .setMode(ControlP5.SWITCH)
     .setValue(drawWord)
     ;
  DropdownList d1 = cp5.addDropdownList("ddlFont")
    .setPosition(390, 10)
    ;
    
  //add items to d1
  d1.addItems(fontList);
  //d1.addItem("test", 0);
  //d1.addItem("test2", 1);
}

String[] getFontList(){
  java.io.File folder = new java.io.File(fontPath);
  java.io.FilenameFilter ttfFilter = new java.io.FilenameFilter(){
    public boolean accept(File dir, String name){
      return name.toLowerCase().endsWith(".ttf");
    }
  };
  
  String[] filenames = folder.list(ttfFilter);
  return filenames;
}

public void nbFontSize(int value){
  if (value != fontSize && value >= 1){
    fontSize = value;
    needsUpdate = true;
  }
}

public void nbGrouping(int value){
  if (value != groupSize && value > 1){
    groupSize = value;
    needsUpdate = true;
  }
}

public void nbFontFidelity(int value){
  if (value != fontFidelity && value >= 1){
    fontFidelity = value;
    needsUpdate = true;
  }
}

public void tWholeWord(boolean value){
  if (value != drawWord){
    drawWord = value;
    needsUpdate = true;
  }
}

public void ddlFont(int value){
  println("[ddlFont] " + value);
  if (value >= 0 && value < fontList.length){
    currFont = fontPath + "/" + fontList[value];
    needsUpdate = true;
  }
}

void controlEvent(ControlEvent theEvent) {
  // DropdownList is of type ControlGroup.
  // A controlEvent will be triggered from inside the ControlGroup class.
  // therefore you need to check the originator of the Event with
  // if (theEvent.isGroup())
  // to avoid an error message thrown by controlP5.

  if (theEvent.isGroup()) {
    // check if the Event was triggered from a ControlGroup
    println("event from group : "+theEvent.getGroup().getValue()+" from "+theEvent.getGroup());
    if (theEvent.getGroup().getName().startsWith("ddlFont")){
      ddlFont(floor(theEvent.getGroup().getValue()));
    }
  } 
  else if (theEvent.isController()) {
    println("event from controller : "+theEvent.getController().getValue()+" from "+theEvent.getController());
  }
}

void draw(){
  if (needsUpdate){
    background(255);
    noFill();
    stroke(0);
    //drawString("QUIN KENNEDY");
    drawLines(new String[]{"My Name Is Quin", "Don't Forget It", "or do, whatever..."});
    //translate(0, fontSize);
    //drawString("My Name Is Quin\nDon't Forget It\nor do, whatever...");
    //drawFont("My Name Is Quin\nDon't Forget It\nor do, whatever...");
    //test();
    needsUpdate = false;
  }
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
  RFont f = new RFont(currFont, fontSize, RFont.LEFT);
  RGroup g = f.toGroup(s);
  RCommand.setSegmentLength(fontFidelity);
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
