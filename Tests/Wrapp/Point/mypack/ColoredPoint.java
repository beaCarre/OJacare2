//	$Id: ColoredPoint.java,v 1.1 2004/03/20 00:03:19 henry Exp $

package mypack;
import mypack.Point;

public class ColoredPoint extends Point implements Colored {

    String c;

    public ColoredPoint() {
	super();
	this.c = "";
    }

    public ColoredPoint(int x,int y, String c) {
	super(x,y);
	this.c = c;
    }

    public String getColor() {
	return this.c;
    }

    public void setColor(String c) {
	this.c = c;
    }

    public String toString() {
	return super.toString()+":"+this.getColor();
    }

    public boolean eq(ColoredPoint p) {
	return super.eq(p) && this.c.equals(p.c);
    }
    public static void main(String args []) {
	ColoredPoint p1 =new ColoredPoint(2,3,"Rouge");
	ColoredPoint p2 =new ColoredPoint(4,4,"Bleu");
	p1.rmoveto(3,2);
	p1.display();
	p2.display();
    }

}
