(*	$Id: type.mli,v 1.1.1.1 2003/10/19 22:57:41 henry Exp $	*)

val convert : (string list * Env_idl.clazz_env) -> bool -> Idl.typ -> Cidl.typ
val convert_args :
  (string list * Env_idl.clazz_env) -> Idl.arg list -> Cidl.typ list
