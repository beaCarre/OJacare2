package callback.fr.upmc.infop6.mlo;
import fr.inria.caml.camljava.*;

public class MainML implements fr.upmc.infop6.mlo.MainML {

  private Callback cb;
  public MainML(fr.inria.caml.camljava.Callback cb) {
     this.cb = cb;
  }

  private static long __mid_cree_visiteur = Callback.getCamlMethodID("_stub_cree_visiteur");
  public fr.upmc.infop6.mlo.VisiteurML cree_visiteur() {
    Object [] args = {};
    return (fr.upmc.infop6.mlo.VisiteurML) cb.callObject(__mid_cree_visiteur,args);
  }

}

