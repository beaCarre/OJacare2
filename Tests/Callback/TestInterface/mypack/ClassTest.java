package mypack;



public class ClassTest {
    public Test t;

    public ClassTest(Test t){
	this.t=t;
    }

    public String toString3(){
        return "javablop";
    }
    public void display3(){
	System.out.println("appel t.display depuis Java :");
	t.display2();
	System.out.println("appel t.tostring depuis Java :\n"+t.toString2());
    }
}
