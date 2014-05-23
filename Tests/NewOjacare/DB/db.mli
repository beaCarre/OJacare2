(* Second mini projet LI332
 * 
 * Travail Ã  faire :
 *  - Ã‰crire un fichier db.ml respectant cette interface db.mli.
 *  - Justifier vos choix par le biais des commentaires dans votre code
 * Remarques :
 * - Vous devez respecter *exactement* cette interface
 * - Votre code sera lie' à un programme de test automatique pour une premiÃ¨re partie de la note
 * - Votre code sera relu pour une seconde partie de la note
 *    1 - dans le cas où certains tests automatiques auraient échoué
 *    2 - pour quelques points de style et de propreté
 * - Si vous n'arrivez pas Ã  implanter certaines fonctions ou méthodes, utilisez (failwith "not implemented").
 * a rendre :
 * - Votre fichier db.ml renomme' en [numero etudiant]_[nom].ml
 *   ou [numero etudiant 2]_[nom 2]_[numero etudiant 2]_[nom 2].ml si vous etes Ã  deux
 * - Par email Ã  benjamin.canou@lip6.fr, avec [LI332] dans le sujet
 * 
 * on peut utiliser des le ml des fonctions, classes, types, qui n'appartiennent pas dans mli.
 * ordre d'implementation pas forcément ordre du mli
 * 1- faire ml qui compile avec failwith "not implemented"
 * 2- compléter au fur et à mesure
 * classe db (base de donnée) interface row (ligne de la bd)
 * conseil : commencer par les opérations de base : ajout suppression edition de colonne, ligne de bd
 * puis recherche : ( "false" -> false : echoue ) et inversement
 * 
 * *)

(** exception raised when an unknown field name is used. *)
exception Unbound_field
(** exception raised when an unknown or already destroyed row is used. *)
exception Unbound_row

(** The (abstract) type of selection expressions. Expressions are
    evaluated internally for a given row to produce a string result
    (by a select operation or a column creation). *)
type expr
(** Gives the value of a field from the row. *)
val field : string -> expr
(** Returns "true" if the results of the two expressions are the same
   or "false" otherwise. *)
val equals : expr -> expr -> expr
(** Produces a constant string. *)
val const : string -> expr
(** Concatenates the results of the two expressions. *)
val concat : expr -> expr -> expr
(** checks if the result of the first expr contains the result of the second expr,
 * when applied, returns "true" or "false" *)
val contains : expr -> expr -> expr
(** applies a standard OCaml operator (&&), (||) etc. to the results of the two expr,
 * assuming "false" is false and anything else is true,
 * when applied, return "true" or "false" *)
val bool_op : (bool -> bool -> bool) -> expr -> expr -> expr
(** applies an OCaml binary string function. *)
val string_op : (string -> string -> string) -> expr -> expr -> expr

(** The type of rows in the database.
   Objects of this type are not to be created by the user.
   They have to be retrieved by a selection or insertion in the database. *) 
class type row = object
  (** Returns the value of a given field.
     May raise Unbound_field. *)
  method access : string -> string
  (** Sets the value of a given field.
     May raise Unbound_field. *)
  method update : string -> string -> unit
  (** Removes this row from its database.
     Any use of the object after a call to this method will raise Unbound_row. *)
  method destroy : unit -> unit
end

(** The type of databases.
   Instanciating this classe creates an empty database,
   using the field names given as arguments. *)
class db : string list -> object
  (** Retrives all the rows as objects of the type row. *)
  method all : row list
  (** Retrives rows for which an application of the given expr returns anything but "false". *)
  method select : expr -> row list
  (** Same as select, but returns only one matching row.
     Can raise Not_found. *)
  method select_one : expr -> row
  (** Removes a row from the database.
     Any use of the object after a call to this method will raise Unbound_row. *)
  method delete : row -> unit
  (** Returns the list of field names. *)
  method describe : string list
  (** Insert a new row from a list associating field names to values.
     If a field is not given, its value is "".
     If an unknown field is given, Unbound_field is raised. *)
  method insert : (string * string) list -> row
  (** Adds a field. If it already exists, this method does nothing.
     A new value is computed for each row using an expression
     (which can use the values of other fields of the row). *)
  method add_column : string -> expr -> unit
  (** Removes a field and the associated values in all rows.
     If an unknown field is given, Unbound_field is raised. *)
  method remove_column : string -> unit
end

(** Imports a database from a CSV file.
   The first line must contains the field names.
   Fields are separated by comas (','), all fields have to be surrounded by
   double quotes ('"'). *)
(*val read_csv : string -> db

(** Exports a database to a CSV file.
   Same format as read_csv. *)
val write_csv : string -> db -> unit*)
val print_db : string -> db -> unit

