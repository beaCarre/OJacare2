open Camlp4.PreCast

val make_class_type: callback:bool -> Cidl.mmethod list -> Ast.class_sig_item list
(** g�n�re la liste des signatures (pour inclure dans le 'class type' *)

val make_dyn: string -> string -> callback:bool -> Cidl.mmethod list -> (string * Ast.expr) list * Ast.class_str_item list
(** g�n�re le code d'implantation des m�thodes, avec des appels virtuel ou non.
   Les deux premier arguments correspondent on nom des variables globales � la classe clazz et java_obj *)

val make_callback: Cidl.mmethod list -> Ast.class_str_item list
val make_callback_class_type: Cidl.mmethod list -> Ast.class_sig_item list
(** g�n�re le code des m�thodes appel� par Java, lors d'un callback :
   elle assure la conversion des arguments et appel la m�thode dite 'utilisateur' 
   (g�n�r� par make_dyn ou red�fini par le programmeur) *)

val make_static: Cidl.clazz list -> Ast.str_item 
val make_static_sig: Cidl.clazz list -> Ast.sig_item 
(** g�n�re la liste des m�thodes static de toute les classes *)
