open Camlp4.PreCast

val make_call: Ast.expr -> Ast.expr list -> Ast.expr
val make_inherit : string -> string list -> Ast.class_str_item
val make_fun : (string * Cidl.typ) list -> Ast.expr -> Ast.expr
val make_callback_fun : (string * Cidl.typ) list -> Ast.expr -> Ast.expr
val make_class_fun : string list -> Ast.class_expr -> Ast.class_expr
val make_local_decl : (string * Ast.expr) list -> Ast.expr -> Ast.expr
val make_class_local_decl : (string * Ast.expr) list -> Ast.class_expr -> Ast.class_expr
val make_rec_class_type : (string * bool * Ast.class_type) list -> Ast.class_type
val make_rec_class_expr : (string * bool * Ast.class_expr) list -> Ast.class_expr
