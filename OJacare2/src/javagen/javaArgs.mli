

val output_call : Format.formatter -> string list -> unit
(** �crit la liste des arguments pour un appel de m�thode *)

val output : Format.formatter -> (string * Cidl.typ) list -> unit
(** �crit la liste des arguments pour une d�claration de m�thode *)
