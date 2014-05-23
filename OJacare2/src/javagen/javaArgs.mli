val output_convert : Format.formatter -> (string * Cidl.typ) list -> unit
(** écrit de le code Java d'encapsulation pour la liste de couple (variable ,type) *)

val output_call : Format.formatter -> string list -> unit
(** écrit la liste des arguments pour un appel de méthode *)

val output : Format.formatter -> (string * Cidl.typ) list -> unit
(** écrit la liste des arguments pour une déclaration de méthode *)
