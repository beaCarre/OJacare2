(*	$Id: env_ident.mli,v 1.3 2004/03/20 00:00:22 henry Exp $	*)

type t
val empty : t

val add_interface : t -> Ident.clazz -> Cidl.clazz  -> t
val add_class : t -> Ident.clazz -> Cidl.clazz  -> t

val find_interface : t -> Ident.clazz -> Cidl.clazz 
val find_class : t -> Ident.clazz -> Cidl.clazz

val env_to_list : t -> Cidl.clazz list
val add_from_list : Cidl.clazz list -> t -> t


type 'a mmethod_env
val add_method: Cidl.mmethod ->  Cidl.mmethod mmethod_env ->  Cidl.mmethod mmethod_env 
val create_method_env:  ?concrete:bool -> Cidl.clazz list -> Cidl.clazz option -> Cidl.mmethod mmethod_env
val mmethod_env_to_list: 'a mmethod_env -> 'a list
