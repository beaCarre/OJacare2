package fr.upmc.infop6.mlo;

public interface Visiteur {
    void visite_cst(boolean b);
    void visite_non(Formule sf);
    void visite_et(Formule fg, Formule fd);
    void visite_ou(Formule fg, Formule fd);
    void visite_var(String nom);
}
