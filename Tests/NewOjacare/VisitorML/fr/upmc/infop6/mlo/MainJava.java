package fr.upmc.infop6.mlo;

public class MainJava {

     static Formule f1() {
	Constante c1 = new Constante(true);
	Constante c2 = new Constante(true);
	Constante c3 = new Constante(false);
	Et e = new Et(c2,c3);
	return(new Ou(c1,e));
	
    }

     static Formule f2() {
	Var a = new Var("a");
	Var b = new Var("b");
	
	Non na = new Non(a);
	Non nb = new Non(b);

	Ou nab = new Ou(na,b);
	Ou anb = new Ou(a,nb);
	return(new Et(nab,anb));
    }
    
     static Formule f3() {
	Var a = new Var("a");
	Non na = new Non(a);
	
	Et enaa = new Et(na,a);
	Ou onaa = new Ou(na,a);
	return(new Ou(enaa,onaa));
    }

    public static void main(MainML ml) {
	
	Formule f1 = MainJava.f1();
	Formule f2 = MainJava.f2();
	Formule f3 = MainJava.f3();
	VisiteurML v1 = ml.cree_visiteur ();
	VisiteurTS v2 = new VisiteurTS ();

	f1.accepte(v1);
	System.out.println(v1.get_res());
	f1.accepte(v2);
	System.out.println(v2.get_res());
	System.out.println("--");

	f2.accepte(v1);
	System.out.println(v1.get_res());
	f2.accepte(v2);
	System.out.println(v2.get_res());
	System.out.println("--");

	f3.accepte(v1);
	System.out.println(v1.get_res());
	f3.accepte(v2);
	System.out.println(v2.get_res());
	System.out.println("--");
    }
}