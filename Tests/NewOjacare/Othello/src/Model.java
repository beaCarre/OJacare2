package src;

import java.awt.Color;
import java.awt.Graphics2D;
import java.awt.geom.Ellipse2D;
import java.util.Observable;

import javax.swing.JOptionPane;

public class Model extends Observable{

	public final int TAILLE = 8;
	public final int [][] TABDIR = {{0,-1},{1,-1},{1,0},{1,1},{0,1},{-1,1},{-1,0},{-1,-1}};
	// N=0, NE=1, E=2, SE=3, S=4, SO=5, O=6, NO=7
	public final int NBDIR = 8;

	int [][] grille; // -1 si vide, 0 ou 1
	int jCourant; // 0:noir ou 1:blanc

	public Model(){
		grille = new int [8][8];
		for(int i=0;i<8;i++){
			for(int j=0;j<8;j++){
				grille[i][j]=-1;
			}	
		}
		grille[3][4]=0;
		grille[4][3]=0;
		grille[3][3]=1;
		grille[4][4]=1;
		jCourant=0;
	}

	public boolean isDirValide(int i, int j, int dir, int joueur){
		i=i+TABDIR[dir][0];
		j=j+TABDIR[dir][1];
		if(i>=0&&j>=0&&i<TAILLE&&j<TAILLE&&grille[i][j]==(joueur+1)%2){
			while( i>=0 && i<8 && j>=0 && j<8 && grille[i][j]!=-1){
				if(grille[i][j]==joueur){
					return true;
				}
				/*if(grille[i][j]==-1){
					return false;
				}*/
				i=i+TABDIR[dir][0];
				j=j+TABDIR[dir][1];
			}
		}
		return false;
	}
	public void remplirDir(int i, int j, int dir, int joueur){
		i=i+TABDIR[dir][0];
		j=j+TABDIR[dir][1];
		while(grille[i][j]!=joueur && i>=0 && i<8 && j>=0 && j<8 ){
			if((grille[i][j]==(joueur+1)%2)){
				grille[i][j]=jCourant;
			}
			i=i+TABDIR[dir][0];
			j=j+TABDIR[dir][1];
		}
	}

	public boolean isCoupValide(int x, int y,int joueur){
		for(int i=0;i<NBDIR;i++){
			if(grille[x][y]==-1 && isDirValide(x, y, i, joueur)){
				return true;
			}
		}
		return false;
	}
	public boolean isBloque(int joueur){
		for(int i=0;i<TAILLE;i++){
			for(int j=0;j<TAILLE;j++){
				if (isCoupValide(i, j, joueur)){
					return false;
				}
			}
		}
		return true;
	}
	public boolean isFini(){
		if (isBloque(jCourant)&&isBloque((jCourant+1)%2)){
			return true;
		}
		return false;
	}

	public int vainceur(){
		int nbN=0;
		int nbB=0;
		for(int i=0;i<TAILLE;i++){
			for(int j=0;j<TAILLE;j++){
				if(grille[i][j]==0)
					nbN++;
				if(grille[i][j]==1)
					nbB++;
			}
		}
		if(nbN==nbB)
			return -1;
		if(nbN>nbB)
			return 0;
		return 1;
	}

	public void jouerCoup(int x, int y){
		if (isBloque(jCourant)){
			afficheFin("vous ne pouvez pas jouer, c'est encore à votre adversaire de jouer");
			jCourant=(jCourant+1)%2;
			return;
		}
		if (isCoupValide(x,y,jCourant)){
			grille[x][y]=jCourant;
			for(int i=0;i<NBDIR;i++){
				if(isDirValide(x, y, i, jCourant)){
					remplirDir(x, y, i, jCourant);
				}
			}
			//prevenir la vue
			setChanged();
			notifyObservers();
			
			jCourant=(jCourant+1)%2;
			if (isFini()){
				afficheFin("jeu terminé,".concat((vainceur()==0)?"le joueur Noir a gagné":(vainceur()==1)?"le joueur Blanc a gagné":"Egalité"));
			}
		}
	}
	
	private void afficheFin(final String msg) {
		new Thread(){
			public void run(){
				JOptionPane.showMessageDialog(null, msg);
			}
		}.start();
		
	}


	public void paintPlateau(Graphics2D g) {
		g.setColor(new Color(50,205,50));
		//g.drawRect(5, 5, 640, 640);
		g.fillRect(5, 5, 640, 640);
		g.setColor(Color.black);
		for(int i=0;i<TAILLE+1;i++){
			g.drawLine(5, 5+i*80, 645, 5+i*80);
			g.drawLine( 5+i*80, 5, 5+i*80, 645);
		}
		for(int i=0;i<TAILLE;i++){
			for(int j=0;j<TAILLE;j++){
				if (grille[i][j]==0){
					g.setColor(Color.BLACK);
					//g.drawOval(i*80+5, i*80+5, 60, 60);
					g.fillOval(j*80+15, i*80+15, 60, 60);
				}
				if (grille[i][j]==1){
					g.setColor(Color.WHITE);
					//g.drawOval(i*80+45, j*80+45, 60, 60);
					g.fillOval(j*80+15, i*80+15, 60, 60);
				}
			}
		}

	}


}
