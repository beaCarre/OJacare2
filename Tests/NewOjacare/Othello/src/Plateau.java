package src;

import java.awt.Dimension;
import java.awt.Graphics;
import java.awt.Graphics2D;

import javax.swing.JPanel;


public class Plateau extends JPanel{
	
	Model m;
	
	public Plateau(Model m){
		setPreferredSize(new Dimension(650, 650));
		this.m=m;
	}
	
	@Override
	protected void paintComponent(Graphics g){
		super.paintComponent(g);
		m.paintPlateau((Graphics2D)g);
	}
}
