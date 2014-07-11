(*	$Id: mlType.ml,v 1.3 2004/07/19 11:22:51 henry Exp $	*)

open Cidl

open Camlp4.PreCast

let _loc = Loc.ghost
  
(** java_type *)
let rec java_signature_of_type t = 
  match t with
    Cvoid -> "void"
  | Cboolean -> "boolean"
  | Cbyte -> "byte"
  | Cchar -> "char"
  | Cshort -> "short"
  | Ccamlint -> "int"
  | Cint -> "int"
  | Clong -> "long"
  | Cfloat -> "float"
  | Cdouble -> "double"
  | Ccallback id -> Ident.get_class_java_icb_qualified_name id
  | Cobject Ctop -> "java.lang.Object"
  | Cobject Cstring -> "java.lang.String"
  | Cobject (Cname id) -> Ident.get_class_java_qualified_name id
  | Cobject (Cjavaarray t)
  | Cobject (Carray t) -> (java_signature_of_type t)^"[]"

		
(** signature java pour la description des appels de methode*)
let java_signature args rtyp = 
  Printf.sprintf "(%s):%s" 
    (String.concat "," (List.map java_signature_of_type args))
    (java_signature_of_type rtyp)

(** signature java pour la description des appels de constructeurs*)
let java_init_signature args = 
  Printf.sprintf "(%s)" 
    (String.concat "," (List.map java_signature_of_type args))

(** nom des modules associés à chaque types de tableaux *)
let array_module_of_type typ = 
  match typ with 
    Cvoid -> "void"
  | Cboolean -> "JavaBooleanArray"
  | Cbyte -> "JavaByteArray"
  | Cchar -> "JavaCharArray"
  | Cshort -> "JavaShortArray"
  | Ccamlint -> "JavaIntArray"
  | Cint -> "int32"
  | Clong -> "JavaLongArray"
  | Cfloat -> "JavaFloatArray"
  | Cdouble -> "JavaDoubleArray"
  | Ccallback _ -> "_callback"
  | Cobject Ctop -> "_top"
  | Cobject Cstring -> "JavaStringArray"
  | Cobject (Cname id) -> Ident.get_class_java_qualified_name id
  | Cobject (Cjavaarray t)
  | Cobject (Carray t) -> (java_signature_of_type t)^"[]"

(** fonction de désencapsulation associée à chaque types de tableaux *)
let array_unwrap_of_type typ = 
  match typ with 
    Cvoid -> "void"
  | Cboolean -> "unwrap_boolean_array"
  | Cbyte -> "unwrap_byte_array"
  | Cchar -> "unwrap_char_array"
  | Cshort -> "unwrap_short_array"
  | Ccamlint -> "unwrap_int_array"
  | Cint -> "int32"
  | Clong -> "unwrap_long_array"
  | Cfloat -> "unwrap_float_array"
  | Cdouble -> "unwrap_double_array"
  | Ccallback _ -> "_callback"
  | Cobject Ctop -> "unwrap_jObject_array"
  | Cobject Cstring -> "unwrap_reference_array"
  | Cobject (Cname id) -> "unwrap_"^(Ident.get_class_java_name id)^"_array"
  | Cobject (Cjavaarray t)
  | Cobject (Carray t) -> "TODO 2 dim"

(** fonction d'encapsulation associée à chaque types de tableaux *)
let array_wrap_of_type typ = 
  match typ with 
    Cvoid -> "void"
  | Cboolean -> "wrap_boolean_array"
  | Cbyte -> "wrap_byte_array"
  | Cchar -> "wrap_char_array"
  | Cshort -> "wrap_short_array"
  | Ccamlint -> "wrap_int_array"
  | Cint -> "int32"
  | Clong -> "wrap_long_array"
  | Cfloat -> "wrap_float_array"
  | Cdouble -> "wrap_double_array"
  | Ccallback _ -> "_callback"
  | Cobject Ctop -> "wrap_jObject_array"
  | Cobject Cstring -> "wrap_reference_array"
  | Cobject (Cname id) -> "wrap_"^(Ident.get_class_java_name id)^"_array"
  | Cobject (Cjavaarray t)
  | Cobject (Carray t) -> "TODO 2 dim"
	 
(** fonctions de conversion des types ocaml vers le type java : "to_oj_type" *)
let rec convert_to_java typ e =
  match typ with
  | Ccamlint ->  <:expr< Int32.of_int $e$ >>
  | Clong ->  <:expr< Int64.of_int $e$ >>
  | Cchar -> <:expr< Char.code $e$ >>
  | Cobject Cstring -> <:expr< JavaString.of_string $e$ >>
  | Cobject (Cname id) -> <:expr< $e$ # $lid:Ident.get_class_ml_jni_accessor_method_name id$ >>
  | Cobject Ctop -> <:expr< $e$ # _get_jniobj >>
  | Cobject (Cjavaarray t) -> <:expr< OjArray.$lid:array_unwrap_of_type t$ $e$ >>
  | Cobject (Carray t) -> <:expr< OjArray.unwrap_$lid:array_unwrap_of_type t$ $e$ >>
  | Ccallback _ -> <:expr< Jni.wrap_object $e$ >>
  | _ -> e

(** type utilisé par l'utilisateur selon le type java: "ml_type" *)
let rec ml_signature_of_type typ = 
  match typ with
  | Cvoid -> <:ctyp< unit >>
  | Cboolean -> <:ctyp< bool >>
  | Cchar -> <:ctyp< int >>
  | Cbyte -> <:ctyp< int >>
  | Cshort -> <:ctyp< int >>
  | Cint -> <:ctyp< int32 >>
  | Ccamlint -> <:ctyp< int >>
  | Clong -> <:ctyp< int >>
  | Cfloat -> <:ctyp< float >>
  | Cdouble -> <:ctyp< float >>
  | Cobject Cstring -> <:ctyp< string >> 
  | Cobject Ctop -> <:ctyp< JniHierarchy.top >> 
  | Cobject (Cjavaarray typ) -> <:ctyp< OjArray.t $ml_signature_of_type typ$>>
  | Cobject (Carray typ) -> <:ctyp< array $ml_signature_of_type typ$ >>
  | Cobject (Cname id) -> <:ctyp< $lid:Ident.get_class_ml_name id$ >>
  | Ccallback id -> <:ctyp< $lid:Ident.get_class_ml_name id$ >>

let ml_signature args rtyp =
  let rec loop args = match args with
  | [] -> ml_signature_of_type rtyp
  | typ::args -> <:ctyp<  $ml_signature_of_type typ$ -> $loop args$ >>
  in 
  match args with 
  | [] -> <:ctyp< unit -> $ml_signature_of_type rtyp$ >>
  | args -> loop args 


(** type utilisé par OCamlJava selon le type java: "oj_type" *)
let rec ml_jni_signature_of_type typ = 
  match typ with
  | Cvoid -> <:ctyp< unit >>
  | Cboolean -> <:ctyp< bool >>
  | Cchar -> <:ctyp< int >>
  | Cbyte -> <:ctyp< int >>
  | Cshort -> <:ctyp< int >>
  | Cint -> <:ctyp< int32 >>
  | Ccamlint -> <:ctyp< int >>
  | Clong -> <:ctyp< int64 >>
  | Cfloat -> <:ctyp< float >>
  | Cdouble -> <:ctyp< float >>
  | Cobject _ -> <:ctyp< Jni.obj >> 
  | Ccallback id -> <:ctyp< Jni.obj >>

let ml_jni_signature args rtyp =
  let rec loop args = match args with
  | [] -> ml_jni_signature_of_type rtyp
  | typ::args -> <:ctyp<  $ml_jni_signature_of_type typ$ -> $loop args$ >>
  in 
  loop args 

(** Construction de la signature de fonction de classe (constructeur) *)
let ml_class_signature targs rtyp =
  match targs with
  | [] -> <:class_type< [ unit ] -> $rtyp$ >>
  | targs -> List.fold_right
	(fun targ e -> <:class_type< [ $ml_signature_of_type targ$ ] -> $e$>> )
	targs rtyp

(** Convertit les arguments *)
let get_args_convertion convert args =
  let make (narg,targ) =
    narg,convert targ <:expr< $lid:narg$ >>
  in
  List.map make args

(** description de la methode java appelée *)
let get_call_method java_class_name java_name sign = 
  java_class_name^"."^java_name^sign

(** description de l'accesseur java appelée *)
let get_accessors_method java_class_name java_name typ =
  java_class_name^"."^java_name^":"^typ

(** description de la methode java appelée *)
let get_init_method java_class_name sign =
  java_class_name^sign

(** conversion des types d'OCaml-java vers le type OCaml : "to_ml_type" *)
let rec convert_from_java typ e = (* to_ml_type *)
  match typ with
  | Cint -> <:expr< Int32.to_int $e$ >>
  | Ccamlint -> <:expr< Int32.to_int $e$ >>
  | Cchar -> <:expr< Char.chr $e$ >>
  | Clong -> <:expr< Int64.to_int $e$ >>
  | Cobject Cstring -> <:expr< JavaString.to_string $e$ >>
  | Cobject (Cname id) -> <:expr< (new $lid:Ident.get_class_ml_wrapper_name id$ $e$ : $lid:Ident.get_class_ml_name id$) >>
  | Cobject Ctop -> <:expr< (new todo $e$ : java'lang'Object java_instance) >>
  | Cobject (Cjavaarray t) | Cobject (Carray t) ->
    (match t with 
    | Cobject (Cname id) ->  <:expr< $lid:array_wrap_of_type t$ $e$>>
    | t -> <:expr< OjArray.$lid:array_wrap_of_type t$ $e$>>)
  | _ -> e
