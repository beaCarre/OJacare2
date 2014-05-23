(*    $Id: main.ml,v 1.4 2004/01/14 16:50:14 henry Exp $   *)

open JGraphics

module Dev = Javadev ;;
module View = Dviview.Make(Dev) ;;

(*** Parsing command-line arguments **)

let crop_flag = ref true ;;
let hmargin = ref (View.Cm 1.0) ;;
let vmargin = ref (View.Cm 1.0) ;;
let geometry = ref "864x864" ;;




let _ = mypack_jDviFrame__main (mlDvi :> ml_dvi)
