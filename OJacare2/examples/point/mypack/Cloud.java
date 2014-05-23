// 	$Id: Cloud.java,v 1.1 2004/03/20 00:03:19 henry Exp $	

package mypack;
import java.util.Vector;

public class Cloud {

    Vector data;

    public Cloud() {
	data = new Vector();
    }

    void addPoint(Point p) {
	data.add(p);
    }

    public String toString() {
	return data.toString();
    }

   public static void main(String [] args) {

	Point p1 = new Point();
	Point p2 = new Point(1,3);
	Point pc1 = new ColoredPoint(-4,2,"Cyan");

	Cloud n = new Cloud();

	n.addPoint(p1);
	n.addPoint(p2);
	n.addPoint(pc1);

	System.out.println(n);

   }
    

}
