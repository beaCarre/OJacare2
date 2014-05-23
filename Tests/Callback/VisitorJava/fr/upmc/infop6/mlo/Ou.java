package fr.upmc.infop6.mlo;

public class Ou extends OpBin {
  Ou(Formule fg, Formule fd){ this.fg = fg; this.fd = fd;}
  void accepte(Visiteur v){v.visite(this);}
}
  

