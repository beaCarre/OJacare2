package mypack;



public class CB_ClassTest extends ClassTest{

    ICB_ClassTest cb;

    public CB_ClassTest(Test cb){
	super();
	this.cb=cb;
    }

    public String toString2(){
        return cb.toString2();
    }
    public String _stub_toString2(){
        return super.toString2();
    }

}
