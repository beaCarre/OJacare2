package fr.upmc.infop6.mlo;

public class Et extends OpBin {
  Et(Formule fg, Formule fd){ this.fg = fg; this.fd = fd;}
  void accepte(Visiteur v){v.visite(this);}
}

