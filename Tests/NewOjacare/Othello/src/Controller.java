package src;

import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;


public class Controller extends MouseAdapter {
	final int TAILLE = 8;
	
	View v;
	Model m;

	public Controller (Model m, View v){
		this.m=m;
		this.v=v;
		v.bindListener(this);
	}
	
	public void mouseClicked(MouseEvent e){
		
		int x=(int)(e.getX()/80);
		int y=(int)(e.getY()/80);
		if(x>=0 && y >= 0 && x<645 && y<645){
			m.jouerCoup(y, x);
		}
	}
}
