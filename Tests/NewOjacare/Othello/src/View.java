package src;

import java.awt.event.MouseListener;
import java.util.Observable;
import java.util.Observer;

import javax.swing.JFrame;
import javax.swing.JPanel;


public class View extends JFrame implements Observer{
	
	JPanel plateau;
	Model model;
	
	public View(Model m){
		super("Othello");
		m.addObserver(this);
		plateau= new Plateau(m);
		setContentPane(plateau);
		setDefaultCloseOperation(EXIT_ON_CLOSE);
		setVisible(true);
		pack();
	}
	
	@Override
	public void update(Observable o, Object arg1) {		
		
		plateau.revalidate();
		plateau.repaint();
	}
	
	public void bindListener(MouseListener controller){
		plateau.addMouseListener(controller);
	}

}
