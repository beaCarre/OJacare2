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
    public String _stub_toString2(){
        return super.toString2();
    }

}
