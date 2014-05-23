package callback.fr.upmc.infop6.mlo;
import fr.upmc.infop6.mlo.*;

public class VisiteurML implements fr.upmc.infop6.mlo.VisiteurML {
    
    

  public VisiteurML() {
      super();
  }
  
  public String get_res() {
      super.get_res();
  }
    void visite(Constante c){
      super.visite(c);
  }
    void visite(Non n){
      super.visite(n);
  }
    void visite(Et e){
      super.visite(e);
  }
    void visite(Ou o ){
      super.visite(o);
  }
    void visite(Var v ){
      super.visite(v);
  }
}

