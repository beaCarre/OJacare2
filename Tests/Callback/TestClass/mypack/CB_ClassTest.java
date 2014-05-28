package mypack;



public class CB_ClassTest extends ClassTest{

    Test test;

    public CB_ClassTest(Test test){
	super();
	this.test=test;
    }

    public String toString2(){
        return test.toString2();
    }
    public void display2(){
        super.display2();
    }
}
