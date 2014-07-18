package mypack;

public interface GrControler {

    public CamlEvent waitBlockingNextEvent(int mask);
    public CamlEvent pollNextEvent(int mask);

}
