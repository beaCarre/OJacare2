package mypack;

import java.util.Collection;
import java.util.Iterator;
import java.util.Vector;

public abstract class Subject {

    private Collection observers;
    public Subject() { observers = new Vector(); }

    public void attach(Observer o) { observers.add(o); }
    public void detach(Observer o) { observers.remove(o); }

    public void notifyObservers() {
	Iterator it = observers.iterator();
	while(it.hasNext()) 
	    ((Observer)it.next()).update(this);
    }

}