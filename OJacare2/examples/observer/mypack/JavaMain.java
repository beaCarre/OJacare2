package mypack;

public class JavaMain {
    
    public static void main (String [] argv, MlMain mlMain) {

	System.out.println("Hello Java : "+argv[0]);

	ConcreteSubject s1 = new ConcreteSubject(1,2,"s1");
	ConcreteSubject s12= new ConcreteSubject(3,4,"s2");
	Observer o1 = mlMain.createObserver("o1");
	Observer o2 = mlMain.createObserver("o2");

	System.out.println("Java : s1.setX(3)");
	s1.setX(3);

	System.out.println("Java : s1.attach(o1)");
	s1.attach(o1);

	System.out.println("Java : s1.setX(4)");
	s1.setX(4);

	System.out.println("Java : s1.attach(o2)");
	s1.attach(o2);

	System.out.println("Java : s1.setY(-4)");
	s1.setY(-4);

	System.out.println("Java : s1.detach(o1)");
	s1.detach(o1);

	System.out.println("Java : s1.setY(2)");
	s1.setY(2);
	
    }
    
}