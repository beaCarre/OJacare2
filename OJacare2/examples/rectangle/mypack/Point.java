package mypack;

public class Point{

    protected int x;
    protected int y;
    
    public Point(int x, int y) {
	this.x = x;
	this.y = y;
    }

    public int getDistX(Point p) {
	return p.x - this.x;
    }

    public int getDistY(Point p) {
	return p.y - this.y;
    }

    public String toString() {
	return "("+this.x+","+this.y+")";
    }

}
