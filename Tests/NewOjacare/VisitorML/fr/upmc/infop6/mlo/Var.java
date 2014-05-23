package fr.upmc.infop6.mlo;

public class Var extends Formule {
  String v;
  public Var(String v){this.v = v;}
  public String ident(){return v;}
  public void accepte(Visiteur v){v.visite(this);}
}

