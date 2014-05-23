package fr.upmc.infop6.mlo;

public class VisiteurTS implements Visiteur {
  String res;
  public VisiteurTS(){res="";}
  public String get_res(){String s = res; res =""; return s; }

  public void visite(Constante c){res=res+c.valeur();}

  public void visite(Non n){res=res+"!("; n.sous_formule().accepte(this);res=res+")";}

  public void visite(Et e){
    res=res+"(";
    e.sous_formule_g().accepte(this);
    res=res+" ^ ";
    e.sous_formule_d().accepte(this); 
    res=res+")";}

  public void visite(Ou o){
    res=res+"(";
    o.sous_formule_g().accepte(this);
    res=res+" v ";
    o.sous_formule_d().accepte(this); 
    res=res+")";}

  public void visite(Var v){res=res+v.ident();}
} 
 
