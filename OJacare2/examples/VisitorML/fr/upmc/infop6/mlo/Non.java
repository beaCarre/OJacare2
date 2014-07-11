package fr.upmc.infop6.mlo;

public class Non extends Formule {
 public  Formule f;
 public  Non(Formule f) {this.f = f;}
 public  Formule sous_formule(){return f;}

 public  void accepte(Visiteur v) {v.visite(this);}
}


