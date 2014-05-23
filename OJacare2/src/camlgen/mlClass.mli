open Camlp4.PreCast

val make_top: unit -> Ast.str_item
val make_exc: unit -> Ast.str_item
val make_jni_type: Cidl.clazz list -> Ast.str_item
val make_jni_type_sig: Cidl.clazz list -> Ast.sig_item
(** Génère l'ast correspondant à la déclaration du type JNI de la classe *)

val make_class_type: callback:bool -> Cidl.clazz list -> (string * bool * Ast.class_type) list
(** Génère le 'class type' de la classe : nom, abstract, ast *)

val make_alloc: Cidl.clazz list -> Ast.str_item
val make_alloc_stub: Cidl.clazz list -> Ast.str_item
(** Génère les fonctions d'allocations d'objet java (interne) *)

val make_wrapper: callback:bool -> Cidl.clazz list -> (string * bool * Ast.class_expr) list
val make_wrapper_sig:  Cidl.clazz list -> Ast.sig_item
(** Génère les cellules capsule et/ou souche *)

val make_jniupcast: Cidl.clazz list -> Ast.str_item
val make_jniupcast_sig: Cidl.clazz list -> Ast.sig_item
val make_jnidowncast: Cidl.clazz list -> Ast.str_item
val make_jnidowncast_sig: Cidl.clazz list -> Ast.sig_item
val make_downcast: Cidl.clazz list -> Ast.str_item
val make_downcast_sig: Cidl.clazz list -> Ast.sig_item
val make_instance_of: Cidl.clazz list -> Ast.str_item
val make_instance_of_sig: Cidl.clazz list -> Ast.sig_item
(** Engendre les fonctions de cast *)

val make_array: Cidl.clazz list -> Ast.str_item
val make_array_sig: Cidl.clazz list -> Ast.sig_item
(** Engendre les fonctions de conxtruction de tableaux *)

