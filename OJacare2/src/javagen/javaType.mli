

val output : Format.formatter -> Cidl.typ -> unit
(** �crit le type en Java *)

val output_convert_to_ml : Format.formatter -> string * Cidl.typ -> unit
(** {output_convert_to_ml ppf (name,typ)} �crit le code Java d'encapsulation 
 pour la variable {name} de type {typ} *)
