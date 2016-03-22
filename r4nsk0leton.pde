import ComputationalGeometry.*;
import peasy.*;

PeasyCam camera;

IsoSkeleton skeleton;
GlitchP5 glitchP5;
ScreenConsole console;

float SUPERLOWSPEED  = 0.0005;
float LOWSPEED  = 0.001;
float MEDSPEED  = 0.02;
float HIGHSPEED = 0.1;
int TREE  = 100;
int STONE = 50;

float speed;
float lineTickness, joinTickness;
float newLineTickness, newJoinTickness;
int amplitude;
int rotDirection = 1;

PVector lights[];
float lightStrength;


//    _____    ______   ______   __  __   ____ 
//   / ___/   / ____/  /_  __/  / / / /  / __ \
//   \__ \   / __/      / /    / / / /  / /_/ /
//  ___/ /  / /___     / /    / /_/ /  / ____/ 
// /____/  /_____/    /_/     \____/  /_/      

void setup() {
  size(800, 600, P3D);
  frameRate(25);
  background(5);
  camera = new PeasyCam(this, 300);

  glitchP5 = new GlitchP5(this);
  skeleton = createRandomSkeleton(10);
  console = new ScreenConsole();

  speed = SUPERLOWSPEED;
  lineTickness = 1;
  joinTickness = 0;
  amplitude = TREE;

  populateLights();
}



//     ____     ____     ___    _       __
//    / __ \   / __ \   /   |  | |     / /
//   / / / /  / /_/ /  / /| |  | | /| / / 
//  / /_/ /  / _, _/  / ___ |  | |/ |/ /  
// /_____/  /_/ |_|  /_/  |_|  |__/|__/   
float zm=0, sp = 0;
void draw() {
  if (!glitchP5.done()) {
    aPastePlane(true);
  }

  if (frameCount % 1000 <= 0) {
    aRandomizeTickness();
  }
  lineTickness = lerp(lineTickness, newLineTickness, 0.001);
  joinTickness = lerp(joinTickness, newJoinTickness, 0.001);

  if (frameCount % (3 * 60 * 25) <= 0) {
    aRunGlitch();
  }
  if (frameCount % (2 * 60 * 25) <= 0) {
    aNewSkeleton();
  }
  if (frameCount % (5 * 60 * 25) <= 0) {
    aClearBG();
  }

  zm = 80;
  sp = speed * frameCount;
  // camera(zm * cos(sp) , 
  //        zm * sin(sp) * rotDirection, 
  //        zm, 
  //        0, 0, 0, 
  //        0, 0, -1);
  // camera.rotateX(zm * cos(sp));
  // camera.rotateY(zm * sin(sp) * rotDirection);
  // camera.rotateZ(zm);
  
  //noStroke();
  stroke(0,10);
  colorMode(HSB);
  fill(frameCount%250, 
       50, 
       100);  

  // lights();
    ambientLight(128, 128, 128);

  for(int i=0; i<lights.length; i++) {
    directionalLight(lightStrength, lightStrength, lightStrength, lights[i].x, lights[i].y, lights[i].z);
  }

  // if (randomGaussian()-1.8 > 0)
  //   directionalLight(80, 50, 50, 50, 0, 1);
  // else
  //   directionalLight(108, 108, 108, 0, 2, -1);

  lightFalloff(1, 0, 1);
  lightSpecular(0, 1, 0);

  pushMatrix();
  rotateX(zm * cos(sp) );
  rotateY(zm * sin(sp) * rotDirection);
  rotateZ(zm);
  skeleton.plot(lineTickness, joinTickness);
  popMatrix();

  console.draw();
  glitchP5.run();
}



//    ______   ____     _   __   ______   ____     ____     __ 
//   / ____/  / __ \   / | / /  /_  __/  / __ \   / __ \   / / 
//  / /      / / / /  /  |/ /    / /    / /_/ /  / / / /  / /  
// / /___   / /_/ /  / /|  /    / /    / _, _/  / /_/ /  / /___
// \____/   \____/  /_/ |_/    /_/    /_/ |_|   \____/  /_____/

void aNewSkeleton(){
  console.log("fire: new skeleton");
  skeleton = createRandomSkeleton(60, amplitude);
  rotDirection *= -1;
}
void aClearBG(){
  console.log("fire: clear background");
  color bg = (random(1)>0.5) ? color(10,0,50) : 0;
  background(bg);
}
void aPastePlane(boolean b){
  console.log("fire: paste plane");
  aPastePlane();
}
void aPastePlane(){
  noStroke();
  fill(200,100,100,100);
  rect(0,0,width,height);
}
void aRunGlitch(){
  console.log("fire: glitch");
  glitchP5.glitch((int)random(0,width), (int)random(0,height), 
                  200, 400, 
                  200, 1200, 
                  3, 1.0f, 10, 40);
  rotDirection *= -1;
}
void aAmplitudeUp(){
  console.log("fire: shaping stones");
  amplitude = STONE;
  aRandomizeTickness();
}
void aAmplitudeDown(){
  console.log("fire: shaping trees");
  amplitude = TREE;
  aRandomizeTickness();
}
void aRandomizeTickness(){
  console.log("fire: randomize tickness");
  newLineTickness = random(0, 5);
  newJoinTickness = random(0, 0.1);
}



//     ____   _   __   ____     __  __   ______
//    /  _/  / | / /  / __ \   / / / /  /_  __/
//    / /   /  |/ /  / /_/ /  / / / /    / /   
//  _/ /   / /|  /  / ____/  / /_/ /    / /    
// /___/  /_/ |_/  /_/       \____/    /_/     

void keyPressed() {
  if (key == 'r') {
    aNewSkeleton();
  }
  if (key == 'b') {
    aClearBG();
  }
  if (key == 'g') {
    aRunGlitch();
  }
  if (key == '1') {
    aAmplitudeUp();
  }
  if (key == '2') {
    aAmplitudeDown();
  }
}



//    _____    __ __    ______   __       ______   ______   ____     _   __
//   / ___/   / //_/   / ____/  / /      / ____/  /_  __/  / __ \   / | / /
//   \__ \   / ,<     / __/    / /      / __/      / /    / / / /  /  |/ / 
//  ___/ /  / /| |   / /___   / /___   / /___     / /    / /_/ /  / /|  /  
// /____/  /_/ |_|  /_____/  /_____/  /_____/    /_/     \____/  /_/ |_/   

IsoSkeleton createRandomSkeleton(int size) {
  int amplitude = 100;
  return createRandomSkeleton(size, amplitude);
}

IsoSkeleton createRandomSkeleton(int size, int amplitude) {
  IsoSkeleton newSkeleton = new IsoSkeleton(this);

  // Create points to make the network
  PVector[] pts = new PVector[size];
  for (int i=0; i<pts.length; i++) {
    //pts[i] = new PVector(random(-50, 50), random(-50, 50), random(-50, 50) );
    pts[i] = new PVector(random(-amplitude, amplitude), 
                         random(-amplitude, amplitude), 
                         random(-amplitude, amplitude) );
  }

  for (int i=0; i<pts.length; i++) {
    for (int j=i+1; j<pts.length; j++) {
      if (pts[i].dist( pts[j] ) < 50) {
        newSkeleton.addEdge(pts[i], pts[j]);
      }
    }
  }
  
  return newSkeleton;
}

void populateLights() {
  lights = new PVector[(int)random(3,7)];
  for(int i=0; i<lights.length; i++) {
    lightStrength = random(TWO_PI);
    lights[i] = new PVector(cos(lightStrength), 0.3, sin(lightStrength));
  }
  lightStrength = random(120,180);
}

