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
  //frameRate(60);
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
  if ( isAnimating ) {

    if (isAnimationReady) {
      //reset animation 
      fill(255);
      noStroke();
      rect(0, 0, width, height);

      //reset saved points
      saveLine = new StringBuilder();

      //linesIt = (random(1)<.5)?lines.iterator():lines.descendingIterator(); 
      linesIt = lines.iterator();
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
      // undo button
      linesIt = lines.descendingIterator();
      linesIt.next();
      while (linesIt.hasNext()) {
        linesIt.remove();
        if (linesIt.next().x == -9999) {
          break;
        }
      }
    } else if ( mouseX > 165  && mouseX < 225  && mouseY < 50) {
      // clear sketch button
      lines.clear();
      isAnimating = true;
      isAnimationReady = true;
    } else if ( mouseX > 230 && mouseX < 295 && mouseY < 50 ) {
      //save to file button
      saveStrings(new File("handwriting-animation"+random(1)+".txt"), new String[]{saveLine.toString()});
    }
  } else if ( mouseX > 300 && mouseX< 355 && mouseY < 50 ) {
    //open file button
    selectInput("Select your ", "fileSelected");
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

void drawGUI() {
  line(0, 50, width, 50);
  noStroke();
  fill(235, 80, 80);
  triangle(10, 10, 10, 40, 35, 25);
  fill(0);
  rect(55, 10, 10, 30);
  rect(75, 10, 10, 30);

  textFont(createFont("Arial", 16, true), 22);
  fill(0, 0, 0, 0);
  stroke(1);
  rect(95, 10, 60, 30);
  fill(0);
  text("undo", 100, 32);

  fill(0, 0, 0, 0);
  rect(165, 10, 58, 30);
  fill(255, 0, 0);
  text("clear", 170, 32);

  fill(0, 0, 0, 0);
  rect(233, 10, 58, 30);
  fill(0);
  text("save", 238, 32 ); 

  fill(0, 0, 0, 0);
  rect(300, 10, 58, 30);
  fill(0);
  text("open", 305, 32 );
}

void fileSelected(File selection) {
  if (selection == null) {
  } else {
    String[] temp = loadStrings(new File(selection.getAbsolutePath()));
 
    for(int i = 0; i < temp.length;i ++){
    
    }
     }
}