val output_convert : Format.formatter -> (string * Cidl.typ) list -> unit
(** �crit de le code Java d'encapsulation pour la liste de couple (variable ,type) *)

val output_call : Format.formatter -> string list -> unit
(** �crit la liste des arguments pour un appel de m�thode *)

val output : Format.formatter -> (string * Cidl.typ) list -> unit
(** �crit la liste des arguments pour une d�claration de m�thode *)
