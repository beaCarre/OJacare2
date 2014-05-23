package fr.upmc.infop6.mlo;

public class Et extends OpBin {
  public Et(Formule fg, Formule fd){ this.fg = fg; this.fd = fd;}
  public void accepte(Visiteur v){v.visite(this);}
}

