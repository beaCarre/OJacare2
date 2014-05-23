package fr.upmc.infop6.mlo;

public class Constante extends Formule {
  public boolean  b;

  public Constante(boolean b) {this.b = b;}
  public Constante() {this.b = false;}

  public boolean valeur(){return b;}

  public void  accepte(Visiteur v) {v.visite(this);}
}


