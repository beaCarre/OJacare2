package callback.fr.upmc.infop6.mlo;
import fr.inria.caml.camljava.*;

public class VisiteurML implements fr.upmc.infop6.mlo.VisiteurML {

  private Callback cb;
  public VisiteurML(fr.inria.caml.camljava.Callback cb) {
     this.cb = cb;
  }

  private static long __mid_visite_cst = Callback.getCamlMethodID("_stub_visite_cst");
  public void visite(fr.upmc.infop6.mlo.Constante _p0) {
    Object [] args = {_p0};
    cb.callVoid(__mid_visite_cst,args);
  }

  private static long __mid_visite_non = Callback.getCamlMethodID("_stub_visite_non");
  public void visite(fr.upmc.infop6.mlo.Non _p0) {
    Object [] args = {_p0};
    cb.callVoid(__mid_visite_non,args);
  }

  private static long __mid_visite_et = Callback.getCamlMethodID("_stub_visite_et");
  public void visite(fr.upmc.infop6.mlo.Et _p0) {
    Object [] args = {_p0};
    cb.callVoid(__mid_visite_et,args);
  }

  private static long __mid_visite_ou = Callback.getCamlMethodID("_stub_visite_ou");
  public void visite(fr.upmc.infop6.mlo.Ou _p0) {
    Object [] args = {_p0};
    cb.callVoid(__mid_visite_ou,args);
  }

  private static long __mid_visite_var = Callback.getCamlMethodID("_stub_visite_var");
  public void visite(fr.upmc.infop6.mlo.Var _p0) {
    Object [] args = {_p0};
    cb.callVoid(__mid_visite_var,args);
  }

  private static long __mid_get_res = Callback.getCamlMethodID("_stub_get_res");
  public String get_res() {
    Object [] args = {};
    return (String) cb.callObject(__mid_get_res,args);
  }

}

