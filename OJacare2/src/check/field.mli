(*	$Id: field.mli,v 1.1.1.1 2003/10/19 22:57:41 henry Exp $	*)

val convert_static :
  (string list *  Env_idl.clazz_env) -> Ident.clazz -> Idl.field -> Cidl.mmethod list -> Cidl.mmethod list

val convert_dynamic :
    (string list *  Env_idl.clazz_env) -> Ident.clazz -> Idl.field ->
      Cidl.mmethod list * Cidl.mmethod Env_ident.mmethod_env ->
	Cidl.mmethod list * Cidl.mmethod Env_ident.mmethod_env 
	
