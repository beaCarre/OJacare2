open Camlp4.PreCast

val make_fun: callback:bool -> Cidl.clazz list -> Ast.str_item
(** engendre l'ensemble des fonctions d'initialisation *)

val make_class: callback:bool -> Cidl.clazz list -> Ast.str_item
val make_class_sig: callback:bool -> Cidl.clazz list -> Ast.sig_item
(** engendre l'ensemble des classe 'utilisateurs' (1 par constructeur Java) *)
