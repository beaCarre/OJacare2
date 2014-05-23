(*	$Id: env_idl.mli,v 1.1.1.1 2003/10/19 22:57:41 henry Exp $	*)

(** Environement des noms de classes de l'idl -> identificateur de classe unique *)

type clazz_env
val empty_clazz_env : clazz_env
val add_file : Idl.file -> clazz_env -> clazz_env
val find_class_simple : string list * clazz_env -> Idl.ident -> Ident.clazz
val find_class : string list * clazz_env -> Idl.qident -> Ident.clazz

