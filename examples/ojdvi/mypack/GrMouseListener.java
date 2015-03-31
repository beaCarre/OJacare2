package mypack;

import java.awt.*;
import java.awt.image.*;
import java.awt.event.*;

public class GrMouseListener implements MouseListener {
    GrView v;

    public GrMouseListener (GrView v) {
	this.v=v;
    }

    public void mouseClicked(MouseEvent e) { e.consume(); }
    public void mouseEntered(MouseEvent e) { e.consume(); }
    public void mouseExited(MouseEvent e) { e.consume(); }
    public void mousePressed(MouseEvent e) { e.consume(); v.button = true; v.enqueue(e); v.requestFocus(); }
    public void mouseReleased(MouseEvent e) { e.consume(); v.button = false; v.enqueue(e); }
}