package fr.upmc.infop6.mlo;
 

public class Env { 
 public  String[] vars;
 public  boolean[] values;
 public  int size;
 public  Env(int size, String[] vars, boolean[] values){
    this.size=size;
    this.vars =vars; this.values= values;
    if ( (size != 0) && ((size != vars.length) || (size != values.length)))
      throw new Invalid_argument();
  }

 public  String[] get_vars(){return vars;}
 public  boolean[] get_values(){return values;}
 public  int get_size(){return size;}

 public  boolean get(String s){
    for (int i=0; i<size; i++) {
      if (vars[i].equals(s)) return values[i];
    }
    throw new Not_found();
  } 

 public  void display(){
    for (int i = 0; i<size; i++) {
      System.out.print("("+vars[i]+","+values[i]+")");
    }
    System.out.println();
  }
}

