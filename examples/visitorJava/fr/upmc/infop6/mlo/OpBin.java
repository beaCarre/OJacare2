package fr.upmc.infop6.mlo;

public abstract class OpBin extends callback.fr.upmc.infop6.mlo.CB_Formule {
  Formule fg, fd;
  Formule sous_formule_g(){return fg;}
  Formule sous_formule_d(){return fd;}
}


