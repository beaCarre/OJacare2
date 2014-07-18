(*	$Id: idl_parser.mli,v 1.1.1.1 2003/10/19 22:57:42 henry Exp $	*)

(** Interface pour le parser avec idl.mli *)

val from_file : string -> Idl.file
(** {from_file name} parse le fichier {name}. *)
