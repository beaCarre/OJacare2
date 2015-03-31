package mypack;

import java.awt.*;
import java.awt.image.*;
import java.awt.event.*;


public class GrMouseMotionListener implements MouseMotionListener {

    GrView v;

    public GrMouseMotionListener (GrView v){
	super();
	this.v = v;
    }


    public void mouseDragged(MouseEvent e) { 
	e.consume(); v.cur_x = e.getX(); v.cur_y = e.getY(); 
	synchronized(v.trackMouseMotionLock) {
	    if(v.trackMouseMotion) {
		v.trackMouseMotion = false;
		v.enqueue(e);
	    }
	}
    }
    public void mouseMoved(MouseEvent e)  { 
	e.consume(); v.cur_x = e.getX(); v.cur_y = e.getY(); 
	synchronized(v.trackMouseMotionLock) {
	    if(v.trackMouseMotion) {
		v.trackMouseMotion = false;
		v.enqueue(e);
	    }
	}
    }
}