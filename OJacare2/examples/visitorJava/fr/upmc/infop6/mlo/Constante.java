package fr.upmc.infop6.mlo;

public class Constante extends callback.fr.upmc.infop6.mlo.CB_Formule {
  boolean  b;

  Constante(boolean b) {this.b = b;}
  Constante() {this.b = false;}

  boolean valeur(){return b;}

  void  accepte(Visiteur v) {v.visite(this);}
}


