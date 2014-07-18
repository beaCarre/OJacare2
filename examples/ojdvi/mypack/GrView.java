// 	$Id: GrView.java,v 1.4 2004/01/14 16:50:14 henry Exp $	

package mypack;

import java.awt.*;
import java.awt.image.*;
import java.awt.event.*;

public class GrView extends java.awt.Canvas implements GrControler {
 
    public int widthV, heightV;
    private Frame frame;

    public GrView(Frame frame) {
	super();
	this.frame = frame;
    }
    
    public void close() {
	this.image.flush();
	this.image = null;
	this.buffer = null;
	this.setVisible(false);
    }

    public void init(int w, int h) {

	this.setSize(w,h);
	this.setVisible(true);

	Rectangle bounds = new Rectangle();
	bounds = this.getBounds(bounds);
	this.widthV = bounds.width;
	this.heightV = bounds.height;
	
	this.initBuffer();

	this.frame.pack();
	this.frame.show();

	this.initDrawing();
	this.initEvent();
	
    }

    // Buffer /////////////////////////////////////

    Image image;
    Graphics buffer, screen;

    void initBuffer() {
	this.image = new BufferedImage(this.widthV,this.heightV,BufferedImage.TYPE_INT_RGB);
	this.buffer = this.image.getGraphics();
    }

    public void paint(Graphics gr) {
	gr.drawImage(this.image, 0, 0, this);
    }
    public void update(Graphics gr) {
    }

    // Drawing ////////////////////////////////////

    // hack -> pour que le buffer ne soit affiche que lorsque la page est fini
    //    (cad quand on attand un evt)   FIXME : lock ???
    private boolean hasChange;

    static final int red = 255 << 16;
    static final int green = 255 << 8;
    static final int blue = 255;
    static final int white = (red | green | blue);
    public static final int transp = -1;

    private Color color;

    void initDrawing() {
	this.screen = this.getGraphics();
	this.setColor(white);
	this.clear();
	this.hasChange = false;
    }

    public void clear() {
	//screen.setColor(Color.white);
	//screen.fillRect(0,0,this.width,this.height);
	//screen.setColor(this.color); // Hack HasChange
	buffer.setColor(Color.white);
	buffer.fillRect(0,0,this.widthV,this.heightV);
	buffer.setColor(this.color);
    }

    public void setColor(int color) {
	this.color = new Color(color);
	//screen.setColor(this.color); // Hack HasChange
	buffer.setColor(this.color);
    }

    public void fillRect(int x, int _y, int w, int h) {
	int y = this.heightV - _y - h;
	//screen.fillRect(x, y, w, h);  // Hack HasChange
	buffer.fillRect(x, y, w, h);
	this.hasChange = true;
    }

    public void drawImage(Image img, int x, int _y) {
	int y = this.heightV - _y - img.getHeight(this);
	//screen.drawImage(img,x,y,this); // Hack HasChange
	buffer.drawImage(img,x,y,this);
	this.hasChange = true;
    }

    public Image makeImage(int [] pixels,int w,int h) {

	//int w,h;
	Image img;
	int [] data;
	ImageProducer img_prod;


	data  = pixels;

	//w = pixels.length;
	//h = pixels[0].length;
	//data = new int[w*h];
	//for(int i = 0 ; i < w ; i++) {
	//    for(int j = 0; j < h ; j++) {
	//	data[i+j*w] = (pixels[i][j] < 0) ? 0 : pixels[i][j] | (255 << 24) ;
	//    }
	//}

	img_prod = new MemoryImageSource(w,h,data,0,w);
	img = this.createImage(img_prod);
	
	return img;
    }

    // Event ///////////////////////
    
    static final int NB = 256;
    CamlEvent [] queue;
    int queue_start, queue_end;

    int cur_x = 0, cur_y = 0;
    boolean button = false;

    Object trackMouseMotionLock;
    boolean trackMouseMotion;

    private void initEvent() {
	this.queue = new CamlEvent[NB];
	this.queue_start = 0;
	this.queue_end = 0;

	this.addKeyListener(new GrKeyListener());
	this.addMouseMotionListener(new GrMouseMotionListener());
	this.addMouseListener(new GrMouseListener());

	this.trackMouseMotionLock = new Object();	
	this.trackMouseMotion = false;

	 this.requestFocus();
    }

    private void enqueue(CamlEvent evt) { // FIXME : modulo sur end et begin
	synchronized (this.queue) {
	    if (this.queue_end - this.queue_start < NB) {
		this.queue[this.queue_end % NB] = evt;
		this.queue_end++;
		this.queue.notifyAll();
	    }
	}
    };

   private void enqueue(InputEvent evt) { // FIXME : modulo sur end et begin
	enqueue(new CamlEvent(evt,this.cur_x,this.cur_y,this.button));
    }

   private CamlEvent dequeueBlocking() {
	synchronized (this.queue) {
	    try {
		while(this.queue_start == this.queue_end)
		    this.queue.wait();
		int index = this.queue_start % NB;
		this.queue_start++;

		return this.queue[index];
	    } catch (InterruptedException e) { return null; }
	}
    }

    private CamlEvent dequeuePoll() {
	synchronized (this.queue) {
	    if(this.queue_start == this.queue_end) {
		return null;
	    }
	    else {
		int index = this.queue_start % NB;
		this.queue_start++;
		return this.queue[index];
	    }
	}
    }

    public CamlEvent waitBlockingNextEvent(int mask) {
	CamlEvent evt;
	// Hack : cf hasChange
	if(hasChange) {
	    this.paint(screen);
	    hasChange = false;
	}
	// Fin Hack
	if( 0 != ( mask & CamlEvent.MOUSE_MOTION_MASK)) 
	    synchronized(this.trackMouseMotionLock) {
		this.trackMouseMotion = true;
	    };
	do {
	    evt = dequeueBlocking();
	}
	while( !evt.match(mask) );
	    synchronized(this.trackMouseMotionLock) {
		this.trackMouseMotion = false;
	    };
	return evt;
    }

    public CamlEvent pollNextEvent(int mask) {
	CamlEvent evt;
	boolean keypressed = false;
	char key = ' ';
	if( 0 != ( mask & CamlEvent.MOUSE_MOTION_MASK)) 
	    synchronized(this.trackMouseMotionLock) {
		this.trackMouseMotion = true;
	    };
	do {
	    evt = dequeuePoll();
	    
	    if(evt == null) 
		return new CamlEvent(cur_x,cur_y,button,keypressed,key);
	    else {
		if (evt.keypressed) {
		    keypressed = true;
		    key = evt.key;
		}
	    }
	}
	while(!evt.match(mask));
	synchronized(this.trackMouseMotionLock) {
	    this.trackMouseMotion = false;
	};
	return evt;
    }


    private class GrKeyListener implements KeyListener {
	public void keyPressed(KeyEvent e) { e.consume();  }
	public void keyReleased(KeyEvent e) { e.consume(); }
	public void keyTyped(KeyEvent e) { e.consume(); enqueue(e); }
    }

    private class GrMouseMotionListener implements MouseMotionListener {
	public void mouseDragged(MouseEvent e) { 
	    e.consume(); cur_x = e.getX(); cur_y = e.getY(); 
	    synchronized(trackMouseMotionLock) {
		if(trackMouseMotion) {
		    trackMouseMotion = false;
		    enqueue(e);
		}
	    }
	}
	public void mouseMoved(MouseEvent e)  { 
	    e.consume(); cur_x = e.getX(); cur_y = e.getY(); 
	    synchronized(trackMouseMotionLock) {
		if(trackMouseMotion) {
		    trackMouseMotion = false;
		    enqueue(e);
		}
	    }
	}
    }

    private class GrMouseListener implements MouseListener {
	public void mouseClicked(MouseEvent e) { e.consume(); }
	public void mouseEntered(MouseEvent e) { e.consume(); }
	public void mouseExited(MouseEvent e) { e.consume(); }
	public void mousePressed(MouseEvent e) { e.consume(); button = true; enqueue(e); requestFocus(); }
	public void mouseReleased(MouseEvent e) { e.consume(); button = false; enqueue(e); }
    }
  

}
