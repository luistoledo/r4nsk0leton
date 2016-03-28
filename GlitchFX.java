//package glitchP5;

import processing.core.PApplet;

public class GlitchFX
{
  PApplet parent;
  int[] area = new int[0];
  int[] area_ = new int[0];
  int lastxPos; 
  int lastyPos; 
  int lastw;
  int lasth;
  int lastsX;
  int lastsY;

  int[]lastPixels;

  GlitchFX(PApplet p)
  {
    this.parent = p;
    lastPixels = new int[parent.width*parent.height];
  }

  void open()
  {
    parent.loadPixels();
  }

  void close()
  {	

    parent.updatePixels();
    PApplet.arrayCopy(parent.pixels, lastPixels);
  }

  void glitch(int xPos, int yPos, int w, int h, int sX, int sY)
  {
    computeArea(xPos, yPos, w, h, sX, sY);
    int shiftr = 6;
    if (area.length<area_.length)
    {
      for (int j = 0; j < area.length; j++) 
      {
        parent.pixels[area[j]] = lastPixels[area_[j]] ;
        // parent.pixels[area[j]] += parent.pixels[area_[j]] << shiftr;
      }
    } else
    {
      for (int j = 0; j < area_.length; j++) 
      {
        parent.pixels[area[j]] += lastPixels[area_[j]] << shiftr;
        // parent.pixels[area[j]] += parent.pixels[area_[j]] << shiftr;
      }
    }
  }

  void computeArea(int xPos, int yPos, int w, int h, int sX, int sY)
  {
    if (xPos != lastxPos || yPos != lastyPos || w != lastw || h != lasth || sX != lastsX || sY != lastsY)
    {
      int startX = PApplet.constrain(xPos-w/2, 0, parent.width-1);
      int startY = PApplet.constrain(yPos-h/2, 0, parent.height-1);
      int endX = PApplet.constrain(xPos+w/2, 0, parent.width-1);
      int endY = PApplet.constrain(yPos+h/2, 0, parent.height-1);

      int startX_ = PApplet.constrain(xPos-w/2+sX, 0, parent.width-1);
      int startY_ = PApplet.constrain(yPos-h/2+sY, 0, parent.height-1);
      int endX_ = PApplet.constrain(xPos+w/2+sX, 0, parent.width-1);
      int endY_ = PApplet.constrain(yPos+h/2+sY, 0, parent.height-1);

      w = Math.abs(startX-endX);
      h = Math.abs(startY-endY);

      area = new int[w*h];
      int i=0;
      for (int y=startY; y<endY; y++)
      {
        for (int x=startX; x<endX; x++)
        {
          area[i]=parent.width*y+x;
          i++;
        }
      }

      w = Math.abs(startX_-endX_);
      h = Math.abs(startY_-endY_);
      area_ = new int[w*h];
      i=0;
      for (int y=startY_; y<endY_; y++)
      {
        for (int x=startX_; x<endX_; x++)
        {
          area_[i]=parent.width*y+x;
          i++;
        }
      }
    }
    lastxPos  = xPos;
    lastyPos  = yPos;
    lastw     = w ;
    lasth     = h ;
    lastsX    = sX;
    lastsY    = sY ;
  }
}