package callback.fr.upmc.infop6.mlo;
import fr.upmc.infop6.mlo.*;

public interface VisiteurML {

    public String get_res();
    void visite(Constante c);
    void visite(Non n);
    void visite(Et e);
    void visite(Ou o );
    void visite(Var v );
}

