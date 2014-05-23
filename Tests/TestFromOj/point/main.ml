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
