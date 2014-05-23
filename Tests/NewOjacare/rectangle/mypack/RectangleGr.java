package mypack;

public class RectangleGr {

    Point p1, p2;

    public RectangleGr(Point p1, Point p2) {
	this.p1 = p1;
	this.p2 = p2;
    }

    public int computePerimeter() {
	return 2 * (Math.abs(p1.getDistX(p2)) + Math.abs(p1.getDistY(p2)));
    }

    public String toString() {
	return "RectangleGr : "+this.p1+" - "+this.p2+".";
    }

}
