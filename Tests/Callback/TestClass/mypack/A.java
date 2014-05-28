package mypack;

public class A {

    ClassTest ct;

    public A(ClassTest ct){
	super();
	this.ct=ct;
    }

    public String toStringA(){
        return ct.toString2();
    }
    public void displayA(){
	System.out.println("appel ct.display depuis Java :");
	ct.display2();
	System.out.println("appel ct.tostring depuis Java :\n"+ct.toString2());
    }
}
