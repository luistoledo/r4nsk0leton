class ControlFrame extends PApplet {
  PApplet parent;
  ControlP5 cp5;

  public ControlFrame(PApplet parent) {
    super();
    this.parent = parent;
    PApplet.runSketch(new String[]{this.getClass().getName()}, this);
  }
 
  public void settings() {
    size(450, 350, P2D);
  }
 
  public void setup() {
    cp5 = new ControlP5(this);

    cp5.begin(10,10);
    cp5.setAutoSpacing(30,30);

    cp5.addLabel("r4nsk0leton").linebreak();
    cp5.addSlider("speed").setRange(0.05 , 1.5).setSize(300,30).setValue(0.1).linebreak();

    cp5.addButtonBar("figure_type").setCaptionLabel("figure").addItems(split("tree stone"," ")).setValue(0).setHeight(30);
    cp5.addSlider("nodes").setRange(50, 100).setNumberOfTickMarks(4).setValue(75).setHeight(30);
    cp5.addButton("reload_figure").setHeight(30).linebreak();

    cp5.addSlider("stroke").setRange(0, 10).setValue(1).setHeight(30).linebreak();

    cp5.addButton("glitch").setHeight(30);
    cp5.addButton("lightning").setHeight(30);
    cp5.addButton("clear_bg").setHeight(30).linebreak();

    // cp5.addSlider2D("camera").setMinMax(-10, 10, -10, 10);
    cp5.addSlider("cameraZ").setRange(-10, 250).setValue(190).setHeight(30).linebreak();

    // cp5.setAutoSpacing(30,50);
    cp5.addButton("quit").setHeight(30);
    cp5.end();
  }
 
  void draw() {
    background(20);
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
    println(n);
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

  void lightning() {
    aToggleLightning();
  }

  void stroke(int w) {
    aSetStrokeweight(w);
  }

  void style(String theControllerName) {
    Controller c = cp5.getController(theControllerName);
    c.setHeight(30);
    
    // add some padding to the caption label background
    c.getCaptionLabel().getStyle().setPadding(4,4,3,4);
    
    // shift the caption label up by 4px
    // c.getStyle().setMargin(20,30,40,50); 
    
    // set the background color of the caption label
    c.getCaptionLabel().setColorBackground(color(10,20,30,140));
  }
 
}