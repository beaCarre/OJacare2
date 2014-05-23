package mypack;

public class ConcreteSubject extends Subject {
    
    private int x;
    private float y;
    private String name;
    
    Data getState() {
	return new Data(x,y);
    }
    
    public ConcreteSubject(int x, float y, String name) {
	this.x = x;
	this.y = y;
	this.name = name;
    }
    
    void setX(int x) {
	this.x = x;
	notifyObservers();
    }
    
    void setY(float y) {
	this.y = y;
	notifyObservers();
    }

    public String toString() {
	return name;
    }

}
