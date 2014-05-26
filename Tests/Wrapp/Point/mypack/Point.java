//	$Id: Point.java,v 1.1.1.1 2003/10/19 22:57:41 henry Exp $

package mypack;

public class Point {
  
    public int x;
    public int y;
    
    public Point() { 
	this.x = 0;
	this.y = 0;
    };
    
    public Point(int x,int y) {
	this.x = x;
	this.y = y;
    };

    public void moveto(int x, int y) {
	this.x = x;
	this.y = y;
    };

    public void rmoveto(int rx,int ry) {
	this.x += rx;
	this.y += ry;
    };

    public String toString() {
	return "("+x+","+y+")";
    };
    
    public void display() {
	System.out.println(this.toString());
    };

    public double distance() {
	return Math.sqrt(this.x*this.x + this.y*this.y);
    };
    
    public boolean eq(Point p) {
	return this.x == p.x && this.y == p.y;
    };

    public static void main(String args []) {
	Point p1 =new Point(2,3);
	Point p2 =new Point(4,4);
	p1.rmoveto(3,2);
	p1.display();
	p2.display();
    }

}
