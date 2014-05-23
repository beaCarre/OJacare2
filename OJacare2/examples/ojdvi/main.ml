(*    $Id: main.ml,v 1.4 2004/01/14 16:50:14 henry Exp $   *)

open JGraphics

module Dev = Javadev ;;
module View = Dviview.Make(Dev) ;;

(*** Parsing command-line arguments **)

let crop_flag = ref true ;;
let hmargin = ref (View.Cm 1.0) ;;
let vmargin = ref (View.Cm 1.0) ;;
let geometry = ref "864x864" ;;

class mlDvi =
  object
    inherit _stub_ml_dvi ()
	
    method run filename view controler =
      Javadev.set_view view;
      Javadev.set_controler controler;
      View.set_crop !crop_flag;
      View.set_hmargin !hmargin;
      View.set_vmargin !vmargin;
      View.set_geometry !geometry;
      View.main_loop filename 

  end

let _ = mypack_jDviFrame__main (new mlDvi :> ml_dvi)
