package fr.upmc.infop6.mlo;
 

class Env { 
  String[] vars;
  boolean[] values;
  int size;
  Env(int size, String[] vars, boolean[] values){
    this.size=size;
    this.vars =vars; this.values= values;
    if ( (size != 0) && ((size != vars.length) || (size != values.length)))
      throw new Invalid_argument();
  }

  String[] get_vars(){return vars;}
  boolean[] get_values(){return values;}
  int get_size(){return size;}

  boolean get(String s){
    for (int i=0; i<size; i++) {
      if (vars[i].equals(s)) return values[i];
    }
    throw new Not_found();
  } 

  void display(){
    for (int i = 0; i<size; i++) {
      System.out.print("("+vars[i]+","+values[i]+")");
    }
    System.out.println();
  }
}

