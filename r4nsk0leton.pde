import ComputationalGeometry.*;
import peasy.*;
import controlP5.*;
import ddf.minim.*;

Minim minim;
AudioInput audioInput;

PeasyCam camera;

ControlFrame cw;

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
int strokew;
int zoom, newZoom;
boolean manualCamera;
boolean vibration;
boolean blur, dilate, posterize;
boolean cleanBG;
boolean audioNoise;

PVector lights[];
float lightStrength;
boolean lightning;


//    _____    ______   ______   __  __   ____ 
//   / ___/   / ____/  /_  __/  / / / /  / __ \
//   \__ \   / __/      / /    / / / /  / /_/ /
//  ___/ /  / /___     / /    / /_/ /  / ____/ 
// /____/  /_____/    /_/     \____/  /_/      

void settings() {
  size(800, 600, P3D);
}

void setup() {
  cw = new ControlFrame(this);

  frameRate(25);
  background(5);
  camera = new PeasyCam(this, 100);
  zoom = 190; newZoom = 190; manualCamera = false;

  glitchP5 = new GlitchP5(this);
  skeleton = createRandomSkeleton(10);
  console = new ScreenConsole();

  minim = new Minim(this);
  audioInput = minim.getLineIn();

  speed = SUPERLOWSPEED;
  lineTickness = 1;
  joinTickness = 0;
  amplitude = TREE;
  lightning = false;
  strokew = 1;
  vibration = false;
  blur = false;
  dilate = false;
  posterize = false;
  cleanBG = false;
  audioNoise = true;

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

  if (cleanBG) {
    cleanBG = false;
    background(getCleanBGColor());
  }

  if (frameCount % 1000 <= 0) {
    console.log("randomize tickness");
    aRandomizeTickness();
  }
  if (vibration && frameCount % 2 <= 0) {
    newLineTickness = lineTickness + random(-0.01,0.01);
    newJoinTickness = joinTickness + random(-0.5,0.5);
  }
  constrain(newLineTickness, 0, 0.2);
  constrain(newJoinTickness, 0, 5);
  lineTickness = lerp(lineTickness, newLineTickness, vibration?0.5:0.001);
  joinTickness = lerp(joinTickness, newJoinTickness, vibration?0.5:0.001);

  if (audioNoise) {
      lineTickness += audioInput.left.get(1)/2;
      joinTickness += audioInput.right.get(0)/10;
  }

  if (frameCount % (3 * 60 * 25) <= 0) {
    aRunGlitch();
  }
  if (frameCount % (2 * 60 * 25) <= 0) {
    aNewSkeleton();
  }
  if (frameCount % (5 * 60 * 25) <= 0) {
    aCleanBG();
  }
  if (frameCount % (3 * 60 * 25) <= 0) {
    aToggleDilate();
  }
  if (frameCount % (3 * 60 * 25) <= 0) {
  }
  if (frameCount % (3 * 60 * 25) <= 0) {
  }

  zm = 10;
  sp = speed * frameCount;
  
  // if (abs(zoom-newZoom)>0.1) {
    zoom = (int)lerp (zoom, newZoom, 0.05);
  // }
  if (!manualCamera){
    camera.setDistance(zoom);
  }

  stroke(0,10);
  strokeWeight(strokew);
  colorMode(HSB);
  fill(frameCount%255, 
       50, 
       100);  

  lights();
    // ambientLight(128, 128, 128);

  for(int i=0; i<lights.length; i++) {
    directionalLight(lightStrength, lightStrength, lightStrength, lights[i].x, lights[i].y, lights[i].z);
  }

  if (lightning) {
    if (randomGaussian()-1.8 > 0)
      directionalLight(80, 50, 50, 50, 0, 1);
    else
      directionalLight(108, 108, 108, 0, 2, -1);
  
    lightFalloff(1, 0, 1);
    lightSpecular(0, 1, 0);
  }

  if (dilate)
    filter(DILATE);

  if (blur)
    filter(BLUR, 2);

  if (posterize)
    filter(POSTERIZE, 10);
  pushMatrix();
  camera.setRotations( zm * cos(sp),
                       zm * sin(sp) * rotDirection,
                       zm);

  // rotateX(zm * cos(sp) );
  // rotateY(zm * sin(sp) * rotDirection);
  // rotateZ(zm);
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
  console.log("A new skeleton");
  skeleton = createRandomSkeleton(60, amplitude);
  rotDirection *= -1;
}
void aCleanBG(){
  console.log("cristal clear shit");
  cleanBG = true;
}
int getCleanBGColor() {
  return (random(1)>0.5) ? color(10,0,50) : 0;
}
void aPastePlane(boolean b){
  // console.log("fire: paste plane");
  aPastePlane();
}
void aPastePlane(){
  noStroke();
  fill(200,100,100,100);
  rect(-width/4, -height/3, width,height);
}
void aRunGlitch(){
  console.log("glitch");
  glitchP5.glitch((int)random(0,width), (int)random(0,height), 
                  200, 400, 
                  200, 1200, 
                  3, 1.0f, 10, 40);
  rotDirection *= -1;
}
void aAmplitudeUp(){
  console.log("stones to be");
  amplitude = STONE;
  aRandomizeTickness();
}
void aAmplitudeDown(){
  console.log("shaping trees");
  amplitude = TREE;
  aRandomizeTickness();
}
void aRandomizeTickness(){
  console.log("randomize tickness");
  newLineTickness = random(0, 5);
  newJoinTickness = random(0, 0.1);
}
void aSetLightning(boolean v) {
  console.log(v?"lightning on":"lightning is off");
  lightning = v;
}
void aToggleLightning() {
  if (lightning) aSetLightning(false);
  else aSetLightning(true);
}
void aSetStrokeweight(int w) {
  console.log(w + "stroke weight");
  strokew = w;
}
void aSetZoom(int z) {
  console.log("zzzzoooooooommm");
  newZoom = z;
}
void aToggleVibration() {
  if (vibration) aSetVibration(false);
  else aSetVibration(true);
}
void aSetVibration(boolean v) {
  console.log((vibration?"must":"not") +" vibrate!");
  vibration = v;
}
void aSetDilate(boolean v) {
  console.log((v?"dilat£":"not d"));
  dilate = v;
}
void aToggleDilate() {
  if (dilate) aSetDilate(false);
  else aSetDilate(true);
}
void aSetBlur(boolean v) {
  console.log("bulr" + (blur?"YE$":"N0"));
  blur = v;
}
void aToggleBlur() {
  if (blur) aSetBlur(false);
  else aSetBlur(true);
}
void aSetPosterize(boolean v) {
  console.log((posterize?"Posterize":"posterize not"));
  posterize = v;
}
void aTogglePosterize() {
  if (posterize) aSetPosterize(false);
  else aSetPosterize(true);
}
void aSetManualcamera(boolean v) {
  console.log(manualCamera?"auto pilot":"you drive");
  manualCamera = v;
}
void aToggleManualcamera() {
  if (manualCamera) aSetManualcamera(false);
  else aSetManualcamera(true);
}
void aSetAudioinput(boolean v) {
  console.log(v?"lets drone baby":"got bored");
  audioNoise = v;
}
void aToggleAudioinput() {
  if (audioNoise) aSetAudioinput(true);
  else aSetAudioinput(false);
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
  if (key == 'c') {
    aCleanBG();
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
  if (key == 'l') {
    aToggleLightning();
  }
  if (key == 'v') {
    aToggleVibration();
  }
  if (key == 'd') {
    aToggleDilate();
  }
  if (key == 'b') {
    aToggleBlur();
  }
  if (key == 'p') {
    aTogglePosterize();
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
  lights = new PVector[(int)random(2,4)];
  for(int i=0; i<lights.length; i++) {
    lightStrength = random(TWO_PI);
    lights[i] = new PVector(cos(lightStrength), 0.3, sin(lightStrength));
  }
  lightStrength = random(120,180);
}

