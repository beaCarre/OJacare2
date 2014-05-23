package callback.mypack;
import fr.inria.caml.camljava.*;

class ColoredPoint extends mypack.ColoredPoint {

  private Callback cb;
  public ColoredPoint(fr.inria.caml.camljava.Callback cb, int _p0, int _p1, String _p2   ) {
     super(_p0, _p1, _p2  );
     this.cb = cb;
  }

  public ColoredPoint(fr.inria.caml.camljava.Callback cb) {
     super();
     this.cb = cb;
  }

  private static long __mid_moveto = Callback.getCamlMethodID("_stub_moveto");
  public void moveto(int _p0, int _p1 ) {
    Object [] args = {new fr.inria.caml.camljava.Camlint(_p0), new fr.inria.caml.camljava.Camlint(_p1) };
    cb.callVoid(__mid_moveto,args);
  }

  private static long __mid_rmoveto = Callback.getCamlMethodID("_stub_rmoveto");
  public void rmoveto(int _p0, int _p1 ) {
    Object [] args = {new fr.inria.caml.camljava.Camlint(_p0), new fr.inria.caml.camljava.Camlint(_p1) };
    cb.callVoid(__mid_rmoveto,args);
  }

  private static long __mid_toString = Callback.getCamlMethodID("_stub_toString");
  public String toString() {
    Object [] args = {};
    return (String) cb.callObject(__mid_toString,args);
  }

  private static long __mid_display = Callback.getCamlMethodID("_stub_display");
  public void display() {
    Object [] args = {};
    cb.callVoid(__mid_display,args);
  }

  private static long __mid_distance = Callback.getCamlMethodID("_stub_distance");
  public double distance() {
    Object [] args = {};
    return cb.callDouble(__mid_distance,args);
  }

  private static long __mid_eq = Callback.getCamlMethodID("_stub_eq");
  public boolean eq(mypack.Point _p0) {
    Object [] args = {_p0};
    return cb.callBoolean(__mid_eq,args);
  }

  private static long __mid_getColor = Callback.getCamlMethodID("_stub_getColor");
  public String getColor() {
    Object [] args = {};
    return (String) cb.callObject(__mid_getColor,args);
  }

  private static long __mid_setColor = Callback.getCamlMethodID("_stub_setColor");
  public void setColor(String _p0) {
    Object [] args = {_p0};
    cb.callVoid(__mid_setColor,args);
  }

  private static long __mid_eq_colored_point = Callback.getCamlMethodID("_stub_eq_colored_point");
  public boolean eq(mypack.ColoredPoint _p0) {
    Object [] args = {_p0};
    return cb.callBoolean(__mid_eq_colored_point,args);
  }

}

