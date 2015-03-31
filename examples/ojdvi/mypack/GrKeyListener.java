package mypack;

import java.awt.*;
import java.awt.image.*;
import java.awt.event.*;


public class GrKeyListener implements KeyListener {

    GrView v;

    public GrKeyListener (GrView v) {
	this.v=v;
    }


    public void keyPressed(KeyEvent e) { e.consume();  }
    public void keyReleased(KeyEvent e) { e.consume(); }
    public void keyTyped(KeyEvent e) { e.consume(); v.enqueue(e); }
}