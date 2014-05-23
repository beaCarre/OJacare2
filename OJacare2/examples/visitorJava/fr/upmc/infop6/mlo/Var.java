package fr.upmc.infop6.mlo;

public class Var extends Formule {
  String v;
  Var(String v){this.v = v;}
  String ident(){return v;}
  void accepte(Visiteur v){v.visite(this);}
}

