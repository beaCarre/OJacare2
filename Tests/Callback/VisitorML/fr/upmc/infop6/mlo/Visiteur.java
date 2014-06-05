package fr.upmc.infop6.mlo;

public interface Visiteur {
    public void visite(Constante c);
   public  void visite(Non n);
   public  void visite(Et e);
   public  void visite(Ou o );
   public  void visite(Var v );
}

