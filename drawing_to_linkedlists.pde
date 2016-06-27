//import processing.svg.*;

import java.util.*;

LinkedList<PVector> lines;
Iterator<PVector> linesIt;
boolean isAnimationReady = false;
boolean isAnimating = false;
StringBuilder saveLine = new StringBuilder();


void setup() {
  size(displayWidth, displayHeight);
  //fullScreen();
  background(255);
  smooth(8);
  frameRate(60);
  fill(0);
  lines = new LinkedList<PVector>();
}

PVector a = new PVector(0, 0);
PVector b = new PVector(0, 0);
int i = 0;
void draw() {
  pushMatrix();
  drawGUI();
  popMatrix();
  //draw every 30 seconds
  if ( isAnimating && frameCount % 1 == 0 ) {

    if (isAnimationReady) {
      //reset animation 
      fill(255);
      noStroke();
      rect(0, 0, width, height);

      //reset saved points
      saveLine = new StringBuilder();

      linesIt = (random(1)<.5)?lines.iterator():lines.descendingIterator(); 
      if (linesIt.hasNext()) {
      a = linesIt.next();
      }
      if (linesIt.hasNext()) {
        b = linesIt.next();
      }
      isAnimationReady = false;
    }

    if (linesIt.hasNext()) {

      //if drawing starts with a dot, draw the dot seperately
      a = b;

      if (linesIt.hasNext()) { 
        b = linesIt.next();
      }

      //println(a.x+","+a.y+"->"+b.x+","+b.y);

      saveLine.append(a.x+","+a.y+"->"+b.x+","+b.y+"\n");

      if (b.x != -9999 && a.x !=-9999) {
        fill(0);
        stroke(1);
        strokeWeight(5);
        line(a.x, a.y, b.x, b.y);
      }
    } else {
      isAnimating = false;
    }
  }
}

void mouseClicked() {
  strokeWeight(1);

  if ( !lines.isEmpty() ) {
    println("test"+ mouseX+ " | " +mouseY);
    if (mouseX < 45 && mouseY < 50 ) {
      //play button pressed
      isAnimationReady = true;
      isAnimating = true;

      fill(100, 255, 00);
      triangle(10, 10, 10, 40, 35, 25);
    } else if ( mouseX > 45  && mouseX < 90  && mouseY < 50  && isAnimating) {
      isAnimating = false;
      fill(200, 200, 200);
      rect(55, 10, 10, 30);
      rect(75, 10, 10, 30);
    } else if ( mouseX > 95  && mouseX < 160  && mouseY < 50  && !isAnimating) {
      // undo last line
      linesIt = lines.descendingIterator();
      linesIt.next();
      while (linesIt.hasNext()) {
        linesIt.remove();
        //println("elements removed: " + linesIt.next());
        if (linesIt.next().x == -9999) {
          break;
        }
      }
    }else if( mouseX > 165  && mouseX < 225  && mouseY < 50){
      lines.clear();
      isAnimating = true;
      isAnimationReady = true;
    }
  }
  if (!isAnimating && mouseY > 50) {
    //single tap
    addPoint();
    addPoint();
    addPoint();
    lines.add(new PVector(-9999, -9999));
  }
}

void mouseDragged() {
  if (!isAnimating && mouseY > 50) {
    addPoint();
  }
}

void mouseReleased() {
  //delimiting point for spaces

  if (!isAnimating &&  mouseY > 50) {
    lines.add(new PVector(-9999, -9999));
  }
}

void addPoint() {
  stroke(4);
  strokeWeight(4);
  fill(0);
  int x = mouseX;
  int y = mouseY;

  lines.add(new PVector(x, y));
  ellipse(x, y, 1, 1);
}

void keyPressed() { 
  //println(key + "|" + keyCode );
  if (!lines.isEmpty() && !isAnimating) {
    if (keyCode == 524 || key == 'u') {
      // undo last line
      linesIt = lines.descendingIterator();
      linesIt.next();
      while (linesIt.hasNext()) {
        linesIt.remove();
        //println("elements removed: " + linesIt.next());
        if (linesIt.next().x == -9999) {
          break;
        }
      }
    } else if (key == 'a') {
      isAnimationReady = true;
      isAnimating = true;
    } else if (key == 'p') {  
      saveStrings(new File("drawing.txt"), new String[]{saveLine.toString()});
    }
  } else if (key == 's' ) {
    isAnimating = false;
  }
}

void drawGUI() {
  noStroke();
  line(0, 50, width, 50);
  fill(235, 80, 80);
  triangle(10, 10, 10, 40, 35, 25);
  fill(0);
  rect(55, 10, 10, 30);
  rect(75, 10, 10, 30);
  textFont(createFont("Arial", 16, true), 22);
  fill(0,0,0,0);
  stroke(1);
  rect(95,10,60,30);
  fill(0);
  text("undo", 100, 32);
  //text("do", 105, 40);
  fill(0,0,0,0);
  rect(165,10,58,30);
  fill(255,0,0);
  text("clear",170,32);
}