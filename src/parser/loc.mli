(*	$Id: loc.mli,v 1.1.1.1 2003/10/19 22:57:42 henry Exp $	*)

(** Utilitaire pour le retour au source *)

type t = Loc of int * int 
(** Type repr�sentant la position *)

val get: unit -> t
(** {get name} ermet lors du "Parsing" de r�cuperer la position du code source, dans le fichier {name}, de la r�gle r�duite *)

val print_source : in_channel -> t -> unit
(** Affiche le code incrimin� *)
