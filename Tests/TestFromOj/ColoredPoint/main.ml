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
p2#set_x  4;;
p2#display ();;


display "Creation d'un point colore pc = (1,3) cyan : ";;
let pc = new colored_point 1 3 "cyan";;
display "OK\n";;

display "Creation d'un point colore pc2 = (2,3) blue : ";;
let pc2 = new colored_point 2 3 "blue";;
display "OK\n";;

display "Envoi pc#display : ";;
pc#display ();;

display "Envoi pc2#display : ";;
pc2#display ();;

display "Envoi pc2#getColor : ";;
let s = pc2#getColor () in print_string s; print_newline ();;

display "eq pc2 pc ? :";;
let r = (pc2#eq_colored_point pc) in print_string (if r then "true" else "false");print_newline ();;

display "Envoi pc2#distance : ";;
let d = pc2#distance () in print_float d; print_newline ();;
