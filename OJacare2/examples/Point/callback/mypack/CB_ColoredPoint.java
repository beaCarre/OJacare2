package callback.mypack;
public class CB_ColoredPoint extends mypack.ColoredPoint {

  private ICB_ColoredPoint cb;
  public CB_ColoredPoint(ICB_ColoredPoint cb, int _p0, int _p1, String _p2   ) {
     super(_p0, _p1, _p2  );
     this.cb = cb;
  }

  public CB_ColoredPoint(ICB_ColoredPoint cb) {
     super();
     this.cb = cb;
  }

  public void _oj_moveto(int _p0, int _p1 ) {
     super.moveto(_p0, _p1 );
  }

  public void moveto(int _p0, int _p1 ) {
     cb.moveto(_p0, _p1 );
  }

  public void _oj_rmoveto(int _p0, int _p1 ) {
     super.rmoveto(_p0, _p1 );
  }

  public void rmoveto(int _p0, int _p1 ) {
     cb.rmoveto(_p0, _p1 );
  }

  public String _oj_toString() {
    return  super.toString();
  }

  public String toString() {
    return  cb.toString();
  }

  public void _oj_display() {
     super.display();
  }

  public void display() {
     cb.display();
  }

  public double _oj_distance() {
    return  super.distance();
  }

  public double distance() {
    return  cb.distance();
  }

  public boolean _oj_eq(mypack.Point _p0) {
    return  super.eq(_p0);
  }

  public boolean eq(mypack.Point _p0) {
    return  cb.eq(_p0);
  }

  public String _oj_getColor() {
    return  super.getColor();
  }

  public String getColor() {
    return  cb.getColor();
  }

  public void _oj_setColor(String _p0) {
     super.setColor(_p0);
  }

  public void setColor(String _p0) {
     cb.setColor(_p0);
  }

  public boolean _oj_eq(mypack.ColoredPoint _p0) {
    return  super.eq(_p0);
  }

  public boolean eq(mypack.ColoredPoint _p0) {
    return  cb.eq(_p0);
  }

}

