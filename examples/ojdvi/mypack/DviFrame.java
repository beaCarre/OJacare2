//      $Id: DviFrame.java,v 1.4 2004/01/14 16:50:14 henry Exp $

package mypack;

import java.awt.*;

public class DviFrame extends Frame {
    
    GrView view;
 
    DviFrame() {

	super("jDvi");
	this.view = new GrView(this);
	this.add(this.view);

    }

    public static void main(MlDvi model) {
	DviFrame frame = new DviFrame();
	// FileDialog fd = new FileDialog(frame,"au choix ...");
	// fd.show();
	model.run("../../../ocaml-4.02-refman.dvi", frame.view, frame.view); 
    }
}
