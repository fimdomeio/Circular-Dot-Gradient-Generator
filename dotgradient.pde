
import processing.pdf.*;

import geomerative.*;
import controlP5.*;

ControlP5 cp5;


RShape shape;
RPoint[][] allPaths;

boolean pdf = false;

int minDiameter = 340;
int maxDiameter = 1184;
int rowCount = 57;
int dotsPerRow = 278;
float initialEllipseProportion = 1.00;
float finalEllipseProportion = 0.47;
float initialDotSize = 4.66;
float finalDotSize = 0.04;
float rowGrowScale = 0.32;
void setup(){
    cp5 = new ControlP5(this);

  if(pdf){
    size (displayWidth,displayHeight, PDF, "bolinhas3.pdf");
  }else{
    size (640,480);
  }
  RG.init(this);
  RCommand.setSegmentator(RCommand.UNIFORMSTEP); // use a uniform distance between points
  RCommand.setSegmentStep(0.5);
  smooth();
  cp5.setColorLabel(0x6666aaff);
  cp5.addSlider("minDiameter").setPosition(10,10).setRange(0,600);
  cp5.addSlider("maxDiameter").setPosition(10,20).setRange(0,1400);
  cp5.addSlider("rowCount").setPosition(10,30).setRange(1,100);
  cp5.addSlider("dotsPerRow").setPosition(10,40).setRange(0,600);
  cp5.addSlider("initialEllipseProportion").setPosition(10,50).setRange(0.01,3);
   cp5.addSlider("finalEllipseProportion").setPosition(10,60).setRange(0.01,3);
  cp5.addSlider("initialDotSize").setPosition(10,70).setRange(0.1,20);
  cp5.addSlider("finalDotSize").setPosition(10,80).setRange(0.1,20);
  cp5.addSlider("rowGrowScale").setPosition(10,90).setRange(0,1);
  
}

void draw(){
  background(0);

  
  RCommand.setSegmentStep(dotsPerRow/2);
  noStroke();
  
  RCommand.setSegmentLength(dotsPerRow*2); // to allow different angle
  drawEllipses(minDiameter, maxDiameter, rowCount, initialEllipseProportion, finalEllipseProportion, rowGrowScale, initialDotSize, finalDotSize);
  //testSegment();
  if(pdf){
     exit(); 
  }
}

void drawEllipses(int minDiameter, int maxDiameter, int rowCount, float initialEllipseProportion, float finalEllipseProportion, float rowGrowScale, float initialDotSize, float finalDotSize ){
  float gradientLenght = maxDiameter - minDiameter;
  float gradientIncrement = gradientLenght/rowCount; 
  float proportionRange = initialEllipseProportion - finalEllipseProportion;
  float proportionIncrement = proportionRange /rowCount;
  for(int i = 0; i < rowCount; i++){
       float diameter = (minDiameter + gradientIncrement*i);
       diameter = diameter - (rowGrowScale*i)*(rowGrowScale*i);
       float proportion = initialEllipseProportion + proportionIncrement*i;
       shape = shape.createEllipse(width/2, height/2, diameter*proportion, diameter);
       stroke(255);
       noFill();
       //shape.draw();
       noStroke();
       fill(255);
       allPaths = shape.getPointsInPaths();
       float dotSize = initialDotSize + ((finalDotSize-initialDotSize)/rowCount*i);
       boolean shouldDraw = false;
       if(i%2 == 1){
          shouldDraw = true;
       } 
       for (RPoint[] singlePath : allPaths) {
         int currentPoint = 0;
         for (RPoint p : singlePath) {
           if(shouldDraw && (currentPoint < singlePath.length-1) && currentPoint != 0 ){
             ellipse(p.x, p.y, dotSize,dotSize);
           }
           currentPoint += 1;
          shouldDraw = !shouldDraw; 
         }
       }
 }
  //rectangle for interface
  fill(0,0,0,255);
  rect(4,4,215, 101);
}
/*
void testSegment(){
  shape = shape.createEllipse(width/2, height/2, 50,50);
  allPaths = shape.getPointsInPaths();
  shape.draw();
  fill(255);
  for (RPoint[] singlePath : allPaths) {
    for (RPoint p : singlePath) {
        ellipse(p.x, p.y, 10,10);   
    }
  }
}*/

