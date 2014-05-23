import fr.inria.caml.camljava.OCaml;

public class Main {
    public static void main (String[] args) {
	System.loadLibrary("OCaml");
	OCaml.startup(args);

	System.out.println("Hello world from Java!!");
    }
}
