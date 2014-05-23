(*	$Id: utilities.mli,v 1.1.1.1 2003/10/19 22:57:41 henry Exp $	*)

val interval: int -> int -> int list
(** {interval m n} génère la liste {[m;m+1;...;n-1]}, ou la liste vide si {m <= n} *)

val is_capitalized : string -> bool
(** Renvoie si la première lettre de la chaine est une majuscule (faux si la chaine est vide) *)

val split3 : ('a * 'b * 'c) list -> 'a list * 'b list * 'c list
