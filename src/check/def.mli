(*	$Id: def.mli,v 1.1.1.1 2003/10/19 22:57:41 henry Exp $	*)

val convert : (string list *  Env_idl.clazz_env) -> Env_ident.t -> Idl.def -> Env_ident.t
