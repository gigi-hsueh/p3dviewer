/*
 * Barebones 3D viewer
 * Keith O'Hara <kohara@bard.edu>
 * 
 * Face Data set: http://tosca.cs.technion.ac.il/data/face.zip
 * Jama: http://math.nist.gov/javanumerics/jama/doc/
 *
 */

ArrayList<PVector> vertices = new ArrayList<PVector>();
float centerX, centerY, centerZ=0, angle=0, z=-100;

void loadPoints() {                                        
  String [] lines = loadStrings("face02.vert");
  for (int i = 0; i < lines.length; i++) {
    String[] pieces = split(lines[i], ' ');
    PVector m = new PVector(float(pieces[0]), float(pieces[1]), float(pieces[2]));
    vertices.add(m);
  }
}

void setup() {
  size(800, 600, P3D);
  loadPoints();
  //to initialize the position of the face before any transformation
  centerX = width/2;
  centerY = height/2;
  centerZ = 0.0;
}

void draw() {
  background(0);

  if (keyPressed) {
    if (key == CODED) {
      switch(keyCode) {
        //moving the scene center; Up will move the camera up, which means the image will go down
        case(UP): 
        centerY += 2.0; 
        break;
        case(DOWN): 
        centerY -= 2.0; 
        break;
        case(RIGHT): 
        centerX -= 2.0; 
        break;
        case(LEFT): 
        centerX += 2.0; 
        break;
      }
    } else {
      switch(key) {
        //a rotates to the left and s rotates to the right
        //'+' will zoom in; '-' will zoom out
        case('a'): 
        angle += 0.05;
        break;
        case('s'):
        angle -= 0.05;
        break;
        case('='): 
        z = z + 2.0;
        break;
        case('-'): 
        z = z - 2.0;
        break;
      }
    }
  }
  
  //it will be perspective projection unless the mouse is pressed down
  if (mousePressed) {
    ortho(-width/2, width/2, -height/2, height/2);
  } else {
    float fov = PI /3;
    float cameraZ = (height/2.0) / tan(fov/2.0);
    perspective(fov, float(width)/float(height), cameraZ/10.0, cameraZ*10.0);
  }

  pushMatrix();   // saves the coordinate system; we're about to change it 
  //the main function that sets the position of the camera through setting the eye position, the center of the scene, and the upward axis
  //the eye position follows the mouse, the center of the scene can be moved with keys as well as upward axis
  camera(mouseX, mouseY, (height/2)/tan(PI/6), centerX, centerY, 0, sin(angle), -cos(angle), 0);
  translate(width/2, height/2, z);
  scale(250);
  stroke(255);
  strokeWeight(0.01);
  beginShape(POINTS);
  for (PVector v : vertices) {
    vertex(v.x, v.y, v.z);
  }
  endShape();
  popMatrix();  // restore the old saved coordinate system
}
