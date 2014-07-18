open Camlp4.PreCast


val java_signature_of_type: Cidl.typ -> string
val java_signature: Cidl.typ list -> Cidl.typ -> string
val java_init_signature: Cidl.typ list -> string
val convert_to_java: Cidl.typ -> Ast.expr -> Ast.expr
val convert_from_java: Cidl.typ -> Ast.expr -> Ast.expr
val ml_signature_of_type: Cidl.typ -> Ast.ctyp
val ml_signature: Cidl.typ list -> Cidl.typ -> Ast.ctyp
val ml_jni_signature_of_type: Cidl.typ -> Ast.ctyp
val ml_jni_signature: Cidl.typ list -> Cidl.typ -> Ast.ctyp
val ml_class_signature:
  Cidl.typ list -> Ast.class_type -> Ast.class_type
val get_args_convertion:
  ('a -> Ast.expr -> 'b) -> (string * 'a) list -> (string * 'b) list
val get_call_method: string -> string -> string -> string
val get_accessors_method : string -> string -> string -> string
val get_init_method : string -> string -> string 
