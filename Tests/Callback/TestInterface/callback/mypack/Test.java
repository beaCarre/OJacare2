package callback.mypack;
import fr.inria.caml.camljava.*;

public class Test implements mypack.Test {

  private Callback cb;
  public Test(fr.inria.caml.camljava.Callback cb) {
     this.cb = cb;
  }

  private static long __mid_toStringT = Callback.getCamlMethodID("_stub_toStringT");
  public String toStringT() {
    Object [] args = {};
    return (String) cb.callObject(__mid_toStringT,args);
  }

  private static long __mid_displayT = Callback.getCamlMethodID("_stub_displayT");
  public void displayT() {
    Object [] args = {};
    cb.callVoid(__mid_displayT,args);
  }

}

