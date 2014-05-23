(*	$Id: mlType.ml,v 1.3 2004/07/19 11:22:51 henry Exp $	*)

open Cidl

open Camlp4.PreCast

let _loc = Loc.ghost

let string_of_type t =
  match t with 
  | Cboolean -> "boolean"
  | Cchar -> "char"
  | Cbyte -> "byte"
  | Cshort -> "short"
  | Cint -> "int"
  | Ccamlint -> "int"
  | Clong -> "long"
  | Cfloat -> "float"
  | Cdouble -> "double"
  | Cobject _ -> "object"
  | Cvoid -> "void"
  | Ccallback _ -> invalid_arg "string_of_type"

let constructor_of_type t = 
  <:ident<$uid:
    match t with 
    | Cboolean -> "Boolean"
    | Cchar -> "Char"
    | Cbyte -> "Byte"
    | Cshort -> "Short"
    | Cint -> "Int"
    | Ccamlint -> "Camlint"
    | Clong -> "Long"
    | Cfloat -> "Float"
    | Cdouble -> "Double"
    | Cobject _ -> "Obj"
    | Ccallback _ -> "Obj"
    | Cvoid -> invalid_arg "constructor_of_type"
  $>>
  
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
  | Ccallback _ -> "fr.inria.caml.camljava.Callback"
  | Cobject Ctop -> "java.lang.Object"
  | Cobject Cstring -> "java.lang.String"
  | Cobject (Cname id) -> Ident.get_class_java_qualified_name id
  | Cobject (Cjavaarray t)
  | Cobject (Carray t) -> "["^(java_signature_of_type t)

let rec idl_signature_of_type t = 
  match t with
    Cvoid -> "void"
  | Cboolean -> "boolean"
  | Cbyte -> "byte"
  | Cchar -> "char"
  | Cshort -> "short"
  | Ccamlint -> "int"
  | Cint -> "int32"
  | Clong -> "long"
  | Cfloat -> "float"
  | Cdouble -> "double"
  | Ccallback _ -> "_callback"
  | Cobject Ctop -> "_top"
  | Cobject Cstring -> "string"
  | Cobject (Cname id) -> Ident.get_class_java_qualified_name id
  | Cobject (Cjavaarray t)
  | Cobject (Carray t) -> (idl_signature_of_type t)^"[]"
				 
let java_signature args rtyp = 
  Printf.sprintf "(%s):%s" 
    (String.concat "," (List.map java_signature_of_type args))
    (java_signature_of_type rtyp)

let java_init_signature args = 
  Printf.sprintf "(%s)" 
    (String.concat "," (List.map java_signature_of_type args))

let idl_signature args  = 
    String.concat "," (List.map idl_signature_of_type args)
    
let rec convert_to_java typ e = (* to_oj_type*)
  match typ with
    | Ccamlint ->  <:expr< Int32.of_int $e$ >>
    | Clong ->  <:expr< Int64.of_int $e$ >>
  | Cobject Cstring -> <:expr< JavaString.of_string $e$ >>
  | Cobject (Cname id) -> <:expr< $e$ # $lid:Ident.get_class_ml_jni_accessor_method_name id$ >>
  | Cobject Ctop -> <:expr< $e$ # _get_jniobj >>
  | Cobject (Cjavaarray t) -> <:expr< $e$ # _get_jniobj >>
  | Cobject (Carray t) -> 
      let elt = <:expr< elt >> in
      let allocname = match t with Ccamlint -> "Jni.new_int_array" | t -> "Jni.new_"^(string_of_type t)^"_array" 
      and set = "Jni.set_"^(string_of_type t)^"_array_element" in
      let alloc = match t with
      | Cobject Ctop -> <:expr< $lid:allocname$ length (Jni.find_class "java/lang/Class") >>
      | Cobject (Cname id) -> <:expr< $lid:allocname$ length (Jni.find_class $str:Ident.get_class_java_signature id$) >>
      | Cobject Cstring -> <:expr< $lid:allocname$ length (Jni.find_class "java/lang/String") >>
      | Cobject (Carray t) -> <:expr< $lid:allocname$ length (Jni.find_class "java/lang/Object") >>
      | _ -> <:expr< $lid:allocname$ length >> in
      <:expr< 
      let data = $e$ in 
      let length = Array.length data in 
      let res = $alloc$ in 
      do { 
       ignore(Array.fold_right (fun elt -> fun  i -> do { $lid:set$ res i $convert_to_java t elt$; pred i } ) data (pred length));
       res } >> 
  | Ccallback _ -> <:expr< Jni.wrap_object $e$ >>
  | _ -> e
	
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
  | Cobject (Cjavaarray typ) -> <:ctyp< JniArray.jArray $ml_signature_of_type typ$>>
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

(* Construction de la signature de fonction de classe (constructeur) *)
let ml_class_signature targs rtyp =
  match targs with
  | [] -> <:class_type< [ unit ] -> $rtyp$ >>
  | targs -> List.fold_right
	(fun targ e -> <:class_type< [ $ml_signature_of_type targ$ ] -> $e$>> )
	targs rtyp

(* Convertit les arguments *)
let get_args_convertion convert args =
  let make (narg,targ) =
    narg,convert targ <:expr< $lid:narg$ >>
  in
  List.map make args

(* nom de la fonction Jni *) (*ok *)
let get_call_method java_class_name java_name sign = 
  java_class_name^"."^java_name^sign
    
let get_accessors_method java_class_name java_name typ =
  java_class_name^"."^java_name^":"^typ

let get_init_method java_class_name sign =
  java_class_name^sign

let rec convert_from_java typ e = (* to_ml_type *)
  match typ with
    |Cint -> <:expr< Int32.to_int $e$ >>
    |Ccamlint -> <:expr< Int32.to_int $e$ >>
    |Clong -> <:expr< Int64.to_int $e$ >>
  | Cobject Cstring -> <:expr< JavaString.to_string $e$ >>
  | Cobject (Cname id) -> <:expr< (new $lid:Ident.get_class_ml_wrapper_name id$ $e$ : $lid:Ident.get_class_ml_name id$) >>
  | Cobject Ctop -> <:expr< (new todo $e$ : java'lang'Object java_instance) >>
  | Cobject (Cjavaarray t) -> 
      let jniobj = <:expr< $lid:"jniobj"$ >> in
      let obj = <:expr< $lid:"obj"$ >> in
      <:expr< (new JniArray._Array 
			    Jni.$lid:"get_"^ string_of_type t ^ "_array_element"$
			    Jni.$lid:"set_"^ string_of_type t ^ "_array_element"$
			    (fun jniobj -> $convert_from_java t jniobj$ ) 
			    (fun obj -> $convert_to_java t obj$)
			    $e$ : JniArray.jArray $ml_signature_of_type t$ ) >>
  | Cobject (Carray t) ->
      let elt = <:expr< $lid:"Jni.get_"^ string_of_type t ^ "_array_element"$ java_obj i >> in
      <:expr< 
      let java_obj = $e$ in
      Array.init (Jni.get_array_length java_obj) (fun i -> $convert_from_java t elt$) >>
  | _ -> e
