class ScreenConsole {
  
  String buffer;

  ScreenConsole() {
    buffer = "";
  }

  void draw() {
    pushStyle();
    fill(0, 102, 53, 10);
    textSize(10);
    text (buffer, -width/10, -height/10);
    popStyle();
  }

  void log(String str) {
    buffer = str + "\n" + buffer;
    println (str);
  }

}