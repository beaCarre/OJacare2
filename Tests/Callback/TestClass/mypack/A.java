package mypack;

public class A {

    ClassTest ct;

    public A(ClassTest ct){
	super();
	this.ct=ct;
    }

    public String toStringA(){
        return "A."+ct.toString2();
    }
    public void displayA(){
	ct.display2();
    }
}
