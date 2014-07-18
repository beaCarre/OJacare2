//    $Id: CamlEvent.java,v 1.1 2003/10/22 18:14:56 henry Exp $

package mypack;

import java.awt.AWTEvent;
import java.awt.event.InputEvent;
import java.awt.event.KeyEvent;
import java.awt.event.MouseEvent;

public class CamlEvent {

    public static final int KEY_PRESSED_MASK = 1;
    public static final int BUTTON_DOWN_MASK = 2;
    public static final int BUTTON_UP_MASK = 4;
    public static final int MOUSE_MOTION_MASK = 8;

    public final int kinds;
    public final int mouse_x;
    public final int mouse_y;
    public final boolean button;
    public final boolean keypressed;
    public final char key;

    boolean match(int mask) { return (0 != (mask & this.kinds)); } 

    CamlEvent(InputEvent e, int cur_x, int cur_y, boolean button) {
	int id = e.getID();
	
	if( e instanceof KeyEvent ) {
	    
	    this.kinds = KEY_PRESSED_MASK;
	    
	    if ( id == KeyEvent.KEY_TYPED) {
		this.keypressed = true;
		this.key = ((KeyEvent)e).getKeyChar();
	    } else {
		this.keypressed = false;
		this.key = ' ';
	    }
	    
	    this.mouse_x = cur_x;
	    this.mouse_y = cur_y;
	    this.button = button;
	    
	} else if ( e instanceof MouseEvent ) {

	    MouseEvent me = (MouseEvent) e; 

	    this.mouse_x = me.getX();
	    this.mouse_y = me.getY();
	    
	    this.keypressed = false;
	    this.key = ' ';

	    if ( id == MouseEvent.MOUSE_DRAGGED) {
		this.kinds = MOUSE_MOTION_MASK;
		this.button = true;
	    } else if ( id == MouseEvent.MOUSE_MOVED) {
		this.kinds = MOUSE_MOTION_MASK;
		this.button = false;
	    } else if ( id == MouseEvent.MOUSE_PRESSED) {
		this.kinds = BUTTON_DOWN_MASK;
		this.button = true; 
	    } else { // MOUSE_RELEASED
		this.kinds = BUTTON_UP_MASK;
		this.button = false;
	    }

	} else {

	    this.kinds = 0;
	    this.mouse_x = cur_x;
	    this.mouse_y = cur_y;
	    this.button = button;
	    this.keypressed = false;
	    this.key = ' ';

	}

    }

    CamlEvent(int mouse_x,
	      int mouse_y,
	      boolean button,
	      boolean keypressed,
	      char key) {
	this.kinds = 0;
	this.mouse_x = mouse_x;
	this.mouse_y = mouse_y;
	this.button = button;
	this.keypressed = keypressed;
	this.key = key;
    }

    CamlEvent(int kinds, 
	      int mouse_x,
	      int mouse_y,
	      boolean button,
	      boolean keypressed,
	      char key) {
	this.kinds = kinds;
	this.mouse_x = mouse_x;
	this.mouse_y = mouse_y;
	this.button = button;
	this.keypressed = keypressed;
	this.key = key;
    }

}
