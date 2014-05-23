

val output : Format.formatter -> Cidl.typ -> unit
(** écrit le type en Java *)

val output_convert_to_ml : Format.formatter -> string * Cidl.typ -> unit
(** {output_convert_to_ml ppf (name,typ)} écrit le code Java d'encapsulation 
 pour la variable {name} de type {typ} *)
