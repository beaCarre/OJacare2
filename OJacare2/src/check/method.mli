(*	$Id: method.mli,v 1.2 2004/03/11 20:22:59 henry Exp $	*)

val convert_dynamic: (string list * Env_idl.clazz_env) -> Ident.clazz -> Idl.mmethod -> 
  (Cidl.mmethod list * Cidl.mmethod Env_ident.mmethod_env) -> (Cidl.mmethod list * Cidl.mmethod Env_ident.mmethod_env)
val convert_static : 
 (string list * Env_idl.clazz_env) -> Ident.clazz -> Idl.mmethod -> 
  Cidl.mmethod list -> Cidl.mmethod list 

val have_abstract : Cidl.mmethod list -> bool
