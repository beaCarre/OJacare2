(*	$Id: content.mli,v 1.1.1.1 2003/10/19 22:57:41 henry Exp $	*)

val convert_static :
  (string list * Env_idl.clazz_env) -> Ident.clazz -> Idl.content list -> Cidl.mmethod list 
val convert_dynamic :
  (string list * Env_idl.clazz_env) -> Ident.clazz  -> Cidl.mmethod Env_ident.mmethod_env -> Idl.content list -> 
    Cidl.mmethod list * Cidl.mmethod list
