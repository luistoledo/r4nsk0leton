class ScreenConsole {
  
  String buffer;

  ScreenConsole() {
    buffer = "";
  }

  void draw() {
    pushStyle();
    fill(0, 50);
    textSize(10);
    text (buffer, 0, 0);
    popStyle();
  }

  void log(String str) {
    buffer = str + "\n" + buffer;
    println (str);
  }

}