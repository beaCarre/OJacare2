package callback.mypack;

public class CB_ColoredPoint extends mypack.ColoredPoint {

    public ICB_ColoredPoint cb;

    public CB_ColoredPoint(ICB_ColoredPoint cb) {
	super();
	this.cb=cb;
    }
    public CB_ColoredPoint(ICB_ColoredPoint cb,int x,int y, String c) {
	super(x,y,c);
	this.cb=cb;
    }

    public void moveto(int _p0, int _p1 ){
	cb.moveto(_p0,_p1);
    }
    public void rmoveto(int _p0, int _p1 ) {
	cb.rmoveto(_p0,_p1);
    }
    public String toString(){
	return 	cb.toString();
    }
    public void display(){
	cb.display();
    }
    public double distance() {
	return 	cb.distance();
    }
    public boolean eq(mypack.Point _p0){
	return 	cb.eq(_p0);
    }
    public String getColor(){
	return 	cb.getColor();
    }
    public void setColor(String _p0){
	cb.setColor(_p0);
    }
    public boolean eq(mypack.ColoredPoint _p0){
	return 	cb.eq(_p0);
    }

    public void _stub_moveto(int _p0, int _p1 ) {
	super.moveto(_p0,_p1);
    }
    public void _stub_rmoveto(int _p0, int _p1 ) {
	super.rmoveto(_p0,_p1);
    }
    public String _stub_toString(){
	return 	super.toString();
    }
    public void _stub_display(){
	super.display();
    }
    public double _stub_distance(){
	return 	super.distance();
    }
    public boolean _stub_eq(mypack.Point _p0){
	return 	super.eq(_p0);
    }
    public String _stub_getColor(){
	return super.getColor();
    }
    public void _stub_setColor(String _p0){
	super.setColor(_p0);
    } 
    public boolean _stub_eq(mypack.ColoredPoint _p0){
	return super.eq(_p0);
    }
}

