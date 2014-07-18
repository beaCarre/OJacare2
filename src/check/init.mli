(*	$Id: init.mli,v 1.1.1.1 2003/10/19 22:57:41 henry Exp $	*)

val convert :
  (string list * Env_idl.clazz_env) -> Ident.clazz -> Idl.init list -> Cidl.init list
