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
    cp5.addSlider("join_t").setRange(0, 0.2).setValue(0.1).setSize(100, 20).setSliderMode(Slider.FLEXIBLE);
    cp5.addSlider("arm_t").setRange(0, 5).setValue(1).setSize(100, 20).setSliderMode(Slider.FLEXIBLE).linebreak();

    cp5.addToggle("vibrate").setHeight(20);
    cp5.addToggle("lightning").setHeight(20).plugTo(lightning);

    cp5.addButton("glitch").setHeight(30);
    cp5.addButton("clear_bg").setHeight(30).linebreak();

    cp5.addToggle("audioInput").setHeight(20).setValue(true);
    cp5.addToggle("blur").setHeight(20);
    cp5.addToggle("dilate").setHeight(20);
    cp5.addToggle("movie").setHeight(20).setValue(true);
    cp5.addToggle("posterize").setHeight(20).linebreak();

    // cp5.addSlider2D("camera").setMinMax(-10, 10, -10, 10);
    cp5.addToggle("manual_camera").setHeight(20);
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
    aCleanBG();
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
    aSetLightning(v);
  }

  void stroke(int w) {
    aSetStrokeweight(w);
  }

  void vibrate(boolean v) {
    aSetVibration(v);
  }

  void joint_t(float v) {
    newJoinTickness = v;
  }

  void arm_t(float v) {
    newLineTickness = v;
  }

  void audioInput(boolean v) {
    aSetAudioinput(v);
  }

  void dilate(boolean v) {
    aSetDilate(v);
  }

  void blur(boolean v) {
    aSetBlur(v);
  }

  void posterize(boolean v) {
    aSetPosterize(v);
  }

  void manual_camera(boolean v) {
    aSetManualcamera(v);
  }

  void movie(boolean v) {
    aSetShowVideo(v);
  }



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
      figure_type(1);
    }
    if (key == '2') {
      figure_type(0);
    }
    if (key == 'l') {
      aToggleLightning();
      cp5.getController("lightning").setValue(  cp5.getController("lightning").getValue()==0?1:0  );
    }
    if (key == 'v') {
      aToggleVibration();
      cp5.getController("vibrate").setValue(  cp5.getController("vibrate").getValue()==0?1:0  );
    }
    if (key == 'd') {
      aToggleDilate();
      cp5.getController("dilate").setValue(  cp5.getController("dilate").getValue()==0?1:0  );
    }
    if (key == 'b') {
      aToggleBlur();
      cp5.getController("blur").setValue(  cp5.getController("blur").getValue()==0?1:0  );
    }
    if (key == 'p') {
      aTogglePosterize();
      cp5.getController("posterize").setValue(  cp5.getController("posterize").getValue()==0?1:0  );
    }
    if (key == 'a') {
      aToggleAudioinput();
      cp5.getController("audioInput").setValue(  cp5.getController("audioInput").getValue()==0?1:0  );
    }
  }

  void setDilate(boolean v) {
    cp5.getController("dilate").setValue(  v?1:0  );
  }

}