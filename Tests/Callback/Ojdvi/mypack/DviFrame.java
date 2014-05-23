//      $Id: DviFrame.java,v 1.4 2004/01/14 16:50:14 henry Exp $

package mypack;

import java.awt.*;

class DviFrame extends Frame {
    
    GrView view;
 
    DviFrame() {

	super("jDvi");
	this.view = new GrView(this);
	this.add(this.view);

    }

    public static void main(MlDvi model) {
	DviFrame frame = new DviFrame();
	FileDialog fd = new FileDialog(frame,"au choix ...");
	fd.show();
	model.run(fd.getDirectory()+fd.getFile(), frame.view, frame.view); 
    }
}
