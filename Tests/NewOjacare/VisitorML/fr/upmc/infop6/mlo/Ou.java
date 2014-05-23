package fr.upmc.infop6.mlo;

public class Ou extends OpBin {
  public Ou(Formule fg, Formule fd){ this.fg = fg; this.fd = fd;}
  public void accepte(Visiteur v){v.visite(this);}
}
  

