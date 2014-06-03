package callback.mypack; 

public interface ICB_ColoredPoint {

    public void moveto(int _p0, int _p1 );
    public void rmoveto(int _p0, int _p1 );
    public String toString();
    public void display();
    public double distance() ;
    public boolean eq(mypack.Point _p0);
    public String getColor();
    public void setColor(String _p0);
    public boolean eq_colored_point(mypack.ColoredPoint _p0);
}
