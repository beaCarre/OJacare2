package mypack;

public class RectangleGeo {

    Point p1, p2;

    public RectangleGeo(Point p1, Point p2) {
	this.p1 = p1;
	this.p2 = p2;
    }

    public int computeArea() {
	return Math.abs(p1.getDistX(p2) * p1.getDistY(p2));
    }

    public String toString() {
	return "RectangleGeo : "+this.p1+" - "+this.p2+".";
    }

    public static void main(String args[]) {

	Point p1 = new Point(3,5);
	Point p2 = new Point(5,2);
	RectangleGeo rect = new RectangleGeo(p1,p2);

	System.out.println(rect.computeArea());

    }

}
