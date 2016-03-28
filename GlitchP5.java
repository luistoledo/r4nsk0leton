//package glitchP5;

import processing.core.PApplet;
import java.util.ArrayList;

public class GlitchP5
{
  PApplet parent;
  GlitchFX glfx;
  ArrayList<TimedGlitcher> timedGlitchers = new ArrayList<TimedGlitcher>();

  public GlitchP5(PApplet parent)
  {
    this.parent = parent;
    glfx = new GlitchFX(parent);
  }

  public void run()
  {
    glfx.open();
    for (int i=timedGlitchers.size()-1; i>=0; i--)
    {
      TimedGlitcher tg = timedGlitchers.get(i);
      tg.run();
      if (tg.done())
        timedGlitchers.remove(tg);
    }
    glfx.close();
  }

  public boolean done() {
    return timedGlitchers.size()==0 ? true : false;
  }

  public void glitch(int x, int y, int spreadX, int spreadY, int diaX, int diaY, int amount, float randomness, int attack, int sustain)
  {
    for (int i = 0; i < amount; i++) 
    {
      int att = (int)parent.random(attack);
      timedGlitchers.add(new TimedGlitcher(	(int)(x+(parent.random(-spreadX/2, spreadX/2))), 
        (int)(y+(parent.random(-spreadY/2, spreadY/2))), 
        (int)(diaX*randomness), (int)(diaY*randomness), 
        randomness, att, (int)parent.random(sustain))
        );
    }
  }

  private class TimedGlitcher
  {
    int x, y, diaX, diaY, on;
    int timer, delay;
    float randomness;

    int sX, sY;

    int onset = 0;

    TimedGlitcher(int x, int y, int diaX, int diaY, float randomness, int on, int time)
    {
      this.x = x;
      this.y = y;
      this.diaX = diaX;
      this.diaY = diaY;
      this.randomness = randomness;
      this.on = on;
      this.timer = time;

      sX = (int)(parent.random(-10, 10));
      sY = (int)(parent.random(-10, 10));

      delay = 10;
    }



    void run()
    {
      delay--;
      if (delay <= 0) {
        if (onset >= on)
        {
          glfx.glitch(x, y, diaX, diaY, sX, sY);
          timer--;
        }
        onset++;
        delay = 0;
      }
    }

    boolean done()
    {
      if (timer <= 0) 
        return true;
      else
        return false;
    }
  }
}