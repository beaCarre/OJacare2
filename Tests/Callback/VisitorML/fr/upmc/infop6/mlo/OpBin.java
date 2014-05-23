package fr.upmc.infop6.mlo;

public abstract class OpBin extends Formule {
  Formule fg, fd;
  Formule sous_formule_g(){return fg;}
  Formule sous_formule_d(){return fd;}
}


