package fr.upmc.infop6.mlo;

public class Non extends callback.fr.upmc.infop6.mlo.CB_Formule {
  Formule f;
  Non(Formule f) {this.f = f;}
  Formule sous_formule(){return f;}

  void accepte(Visiteur v) {v.visite(this);}
}


