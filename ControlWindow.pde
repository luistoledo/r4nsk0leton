class ControlFrame extends PApplet {
  PApplet parent;
  ControlP5 cp5;

  public ControlFrame(PApplet parent) {
    super();
    this.parent = parent;
    PApplet.runSketch(new String[]{this.getClass().getName()}, this);
  }
 
  public void settings() {
    size(450, 400, P2D);
  }
 
  public void setup() {
    cp5 = new ControlP5(this);

    cp5.begin(10,40);
    cp5.setAutoSpacing(30,30);

    cp5.addLabel("r4nsk0leton").setColor(color(200,120,130)).setSize(30,30).linebreak();

    cp5.addSlider("speed").setRange(0.05 , 1.5).setSize(300,30).setValue(0.1).linebreak();

    cp5.addButtonBar("figure_type").setCaptionLabel("figure").addItems(split("tree stone"," ")).setValue(0).setHeight(30);
    cp5.addSlider("nodes").setRange(50, 100).setNumberOfTickMarks(4).setValue(75).setHeight(20);
    cp5.addButton("reload_figure").setHeight(30).setColorBackground(color(0, 100, 50)).linebreak();

    cp5.addSlider("stroke").setRange(0, 10).setValue(1).setSize(200, 20).setNumberOfTickMarks(10).setSliderMode(Slider.FLEXIBLE).linebreak();
    cp5.addSlider("jointTickness").setRange(0, 0.2).setValue(0.1).setSize(200, 20).setSliderMode(Slider.FLEXIBLE).linebreak();
    cp5.addSlider("armTickness").setRange(0, 5).setValue(1).setSize(200, 20).setSliderMode(Slider.FLEXIBLE).linebreak();

    cp5.addToggle("vibrate").setHeight(20);
    cp5.addToggle("lightning").setHeight(20);

    cp5.addButton("glitch").setHeight(30);
    cp5.addButton("clear_bg").setHeight(30).linebreak();

    // cp5.addSlider2D("camera").setMinMax(-10, 10, -10, 10);
    cp5.addSlider("cameraZ").setRange(-10, 250).setValue(190).setSize(200,30).linebreak();

    cp5.addButton("quit").setHeight(30);
    cp5.end();
  }
 
  void draw() {
    background(50);
  }

  void quit() {
    parent.exit();
    exit();
  }

  void speed(float spd) {
    speed = spd / 10000;
  }

  void reload_figure() {
    aNewSkeleton();
  }

  void clear_bg() {
    // aClearBG();
    color bg = (random(1)>0.5) ? color(10,0,50) : 0;
    parent.background(bg);
  }

  void glitch() {
    aRunGlitch();
  }

  void figure_type(int n) {
    if (n==1) {
      aAmplitudeUp();
    } else if(n==0) {
      aAmplitudeDown();
    }
    cp5.getController("nodes").setValue(amplitude);
  }

  void nodes(int n) {
    amplitude = n;
  }

  void cameraZ(int z) {
    aSetZoom(z);
  }

  void lightning(boolean v) {
    aToggleLightning();
  }

  void stroke(int w) {
    aSetStrokeweight(w);
  }

  void vibrate(boolean v) {
    aToggleVibration();
  }

  void jointTickness(float v) {
    newJoinTickness = v;
  }

  void armTickness(float v) {
    newLineTickness = v;
  } 
}