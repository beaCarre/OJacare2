package fr.upmc.infop6.mlo;

public class Var extends callback.fr.upmc.infop6.mlo.CB_Formule {
  String v;
  Var(String v){this.v = v;}
  String ident(){return v;}
  void accepte(Visiteur v){v.visite(this);}
}

