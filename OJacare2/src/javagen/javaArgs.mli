

val output_call : Format.formatter -> string list -> unit
(** écrit la liste des arguments pour un appel de méthode *)

val output : Format.formatter -> (string * Cidl.typ) list -> unit
(** écrit la liste des arguments pour une déclaration de méthode *)
