open Visiteur
open Formule

let v = new visiteurTS ();;

print_string (string_of_formule f1);
print_newline ();
(new formule f1)#accepte (v :> jVisiteur);
print_string (v#get_res ());
print_newline ();;

print_string "--";
print_newline ();;

print_string (string_of_formule f2);
print_newline ();
(new formule f2)#accepte (v :> jVisiteur);
print_string (v#get_res ());
print_newline ();;

print_string "--";
print_newline ();;

print_string (string_of_formule f3);
print_newline ();
(new formule f3)#accepte (v :> jVisiteur);
print_string (v#get_res ());
print_newline ();;
