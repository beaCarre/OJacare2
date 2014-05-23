package fr.upmc.infop6.mlo;

public interface Visiteur {
    void visite(Constante c);
    void visite(Non n);
    void visite(Et e);
    void visite(Ou o );
    void visite(Var v );
}

