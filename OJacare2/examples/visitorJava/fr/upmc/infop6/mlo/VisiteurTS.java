package fr.upmc.infop6.mlo;

public class VisiteurTS implements Visiteur {
    String res;
    VisiteurTS(){res="";}
    String get_res(){String s = res; res =""; return s; }

  public void visite_cst(boolean b){res=res+b;}

  public void visite_non(Formule sf){res=res+"!("; sf.accepte(this);res=res+")";}

    public void visite_et(Formule fg, Formule fd){
    res=res+"(";
    fg.accepte(this);
    res=res+" ^ ";
    fd.accepte(this); 
    res=res+")";}

    public void visite_ou(Formule fg, Formule fd){ 
    res=res+"(";
    fg.accepte(this);
    res=res+" v ";
    fd.accepte(this); 
    res=res+")";}

  public void visite_var(String nom){res=res+nom;}
} 
 
