 (*	$Id: main-point.ml,v 1.4 2004/03/28 21:04:37 henry Exp $	*)

open P

let display s = print_string s; flush stdout ;;

display "Creation d'un point p  : ";;
let p = new default_point ();;
display "OK\n";;

display "Creation d'un point p2 = (1,1) : ";;
let p2 = new point 1 1;;
display "OK\n";;

display "Envoi p#display : ";;
p#display ();;
display "Envoi p2#display : ";;
p2#display ();;

display "Envoi p#moveto 4 3 : ";;
p#moveto 4 3;;
p#display ();;

display "Envoi p#rmoveto 2 -2 : ";;
p#rmoveto 2 ~-2;;
p#display ();;
  
display "Envoi p2#toString : ";;
let s = p2#toString () in print_string s; print_newline ();;

display "Envoi p2#distance : ";;
let d = p2#distance () in print_float d; print_newline ();;

display "Envoi p2#set_x 4 : ";;
p2#set_x 4;;
p2#display ();;

display "Creation d'un point colore pc = (1,3) cyan : ";;
let pc = new colored_point 1 3 "cyan";;
display "OK\n";;

display "Creation d'un point colore pc2 = (2,3) blue : ";;
let pc2 = new colored_point 1 3 "blue";;
display "OK\n";;

display "Envoi pc#display : ";;
pc#display ();;

display "Envoi pc2#display : ";;
pc2#display ();;

display "Envoi pc2#getColor : ";;
let s = pc2#getColor () in print_string s; print_newline ();;

display "Creation d'un nuage de point : ";;
let n = new empty_cloud ();;
display "OK\n";;

display "Ajout des points p2 pc1 pc2 p1 au nuage n: ";;
n#addPoint p2;;
n#addPoint (pc :> jPoint);;
n#addPoint (pc2 :> jPoint);;
n#addPoint p;;
display "OK\n";;

display "Envoi n#toString : ";;
let s = n#toString () in print_string s; print_newline ();;

class ml_colored_point x y c  =
  object
    inherit _stub_colored_point x y c as super
    method getColor () = "Caml"^(super#getColor ())
  end;;

display "Creation d'un point callback cb1 = (5,6) blue ";;
let cb1 = new ml_colored_point 5 6 "blue";;
display "OK\n";;

display "Envoi cb1#getColor : ";;
let s = cb1#getColor () in print_string s; print_newline ();;

display "Envoi cb1#toString : ";;
let s = cb1#toString () in print_string s; print_newline ();;

display "Ajout du point cb au nuage n: ";;
n#addPoint (cb1 :> jPoint);;
display "OK\n";;

display "Envoi n#toString : ";;
let s = n#toString () in print_string s; print_newline ();;
