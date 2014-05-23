open Formule
open Format

class visiteur_ml = 
  object (self)
    inherit _stub_jVisiteurML ()
	
    val buf = Buffer.create 80

    method visite_cst cst = 
      Buffer.add_string buf (if cst#valeur () then "true" else "false")

    method visite_var var = 
     Buffer.add_string buf  (var#ident ())

    method visite_non non = 
      let sf = non#sous_formule () in
      Buffer.add_string buf "!(";
      sf#accepte (self :> jVisiteur);
      Buffer.add_string buf ")"
 
    method visite_et et = 
      let fg = et#sous_formule_g ()
      and fd = et#sous_formule_d () in
      Buffer.add_string buf "(";
      fg#accepte (self :> jVisiteur);
      Buffer.add_string buf " ^ "; 
      fd#accepte (self :> jVisiteur);
      Buffer.add_string buf ")";
	  
    method visite_ou ou = 
      let fg = ou#sous_formule_g ()
      and fd = ou#sous_formule_d () in
      Buffer.add_string buf "(";
      fg#accepte (self :> jVisiteur);
      Buffer.add_string buf " v "; 
      fd#accepte (self :> jVisiteur);
      Buffer.add_string buf ")";

    method get_res () =
      let s = Buffer.contents buf in
      Buffer.reset buf;
      s

  end

class mainML =
  object
    inherit _stub_jMainML ()
    method cree_visiteur () =
      (new visiteur_ml :> jVisiteurML)
  end

let _ = fr_upmc_infop6_mlo_jMainJava__main (new mainML :> jMainML)
