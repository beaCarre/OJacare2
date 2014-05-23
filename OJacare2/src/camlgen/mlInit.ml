(*	$Id: mlInit.ml,v 1.4 2004/07/19 11:22:50 henry Exp $	*)

open Cidl

open Camlp4.PreCast
let _loc = Loc.ghost;;
let id = "__id"

let make_fun ~callback cl_list =
  let clazz = "clazz"
  and java_obj = "java_obj" 
  and id = "id" in
  let make_cl cl =   
    if Ident.is_interface cl.cc_ident && callback then
      let ml_name = Ident.get_class_ml_interface_init_name cl.cc_ident
      and java_name = "<init>"
      and targs = [Ccallback cl.cc_ident]
      and jclazz = Ident.get_class_java_stub_signature cl.cc_ident in
      let sign = MlType.java_signature targs Cvoid in
      
      let args = List.map2 (fun i t -> ("_p"^string_of_int i,t)) 
	  (Utilities.interval 0 (List.length targs)) targs in
      let jargs = List.map (fun (narg,targ) -> 
	<:expr< $id:MlType.constructor_of_type targ$ $lid:narg$  >>) args in
      
      let body = <:expr< Jni.call_nonvirtual_void_method 
	  $lid:java_obj$ $lid:clazz$ $lid:id$ [| $list:jargs$ |] >> in
      
      let body = MlGen.make_local_decl (MlType.get_args_convertion MlType.convert_to_java args) body in
      let body =
	match args with 
	  [] -> body
	| args -> MlGen.make_fun args body in
      let body = <:expr< fun ($lid:java_obj$ : $lid:Ident.get_class_ml_jni_type_name cl.cc_ident$) -> $body$ >> in

      let id_expr = <:expr< Jni.get_methodID $lid:clazz$ $str:java_name$ $str:sign$ >> in
	  
      let body = MlGen.make_local_decl 
	  [id,id_expr;
	   clazz, <:expr< Jni.find_class $str:jclazz$ >>] body in
      [ <:str_item< value $lid:ml_name$ = $body$>> ]
    else 
      let make init acc =
	if cl.cc_abstract && not callback then
	  acc
	else
	  let ml_name = 
	    if callback then Ident.get_method_ml_init_stub_name init.cmi_ident
	    else Ident.get_method_ml_init_name init.cmi_ident
	  and java_name = Ident.get_method_java_name init.cmi_ident
	  and targs = 	
	    if callback then (Ccallback init.cmi_class)::init.cmi_args
	    else init.cmi_args 
	  and jclazz = 
	    if callback then Ident.get_class_java_stub_signature init.cmi_class
	    else Ident.get_class_java_signature init.cmi_class in
	  let sign = MlType.java_signature targs Cvoid in

	  let args = List.map2 (fun i t -> ("_p"^string_of_int i,t)) 
	      (Utilities.interval 0 (List.length targs)) targs in
	  let jargs = List.map (fun (narg,targ) -> 
	    <:expr< $id:MlType.constructor_of_type targ$ $lid:narg$  >>) args in
	  
	  let body = <:expr< Jni.call_nonvirtual_void_method 
	      $lid:java_obj$ $lid:clazz$ $lid:id$ [| $list:jargs$ |] >> in

	  let body = MlGen.make_local_decl (MlType.get_args_convertion MlType.convert_to_java args) body in
	  let body =
	    match args with 
	      [] -> body
	    | args -> MlGen.make_fun args body in
	  let body = <:expr< fun ($lid:java_obj$ : $lid:Ident.get_class_ml_jni_type_name init.cmi_class$)-> $body$ >> in

	  let id_expr = <:expr< Jni.get_methodID $lid:clazz$ $str:java_name$ $str:sign$ >> in
	  let err = "Unknown constructor from IDL in class \\\""^
	    (Ident.get_class_java_qualified_name cl.cc_ident)^"\\\" : \\\""^
	    (Ident.get_class_java_name cl.cc_ident)^"("^
	    MlType.idl_signature targs^")\\\"." in
	  let safe_id_expr = 
	    <:expr<try $id_expr$ with _ -> failwith $str:err$>> in

	  let body = MlGen.make_local_decl 
	      [id,safe_id_expr;
	       clazz, <:expr< Jni.find_class $str:jclazz$ >>] body in
	  <:str_item< value $lid:ml_name$ = $body$>> :: acc
      in
      List.fold_right make cl.cc_inits []
  in
  let init_funs = 
    if not callback then 
      List.concat (List.map make_cl  cl_list) 
    else
      List.concat (List.map make_cl (List.filter (fun cl -> cl.cc_callback ) cl_list)) in
  P4helper.str_items init_funs

let make_class ~callback cl_list = 
  let clazz = "clazz"
  and java_obj = "java_obj" 
  and id = "id" in
  let make_cl cl =
    if Ident.is_interface cl.cc_ident && callback then 
      let ml_name = Ident.get_class_ml_stub_name cl.cc_ident
      and targs = [] in
      let ml_init_name = Ident.get_class_ml_interface_init_name cl.cc_ident
      and class_wrapper_name = Ident.get_class_ml_stub_wrapper_name cl.cc_ident
      and class_allocator_name = Ident.get_class_ml_stub_allocator_name cl.cc_ident
      in
      
      let class_decl = [ <:class_str_item< inherit $lid:class_wrapper_name$ $lid:java_obj$ >> ] in
      let finit = <:expr< $lid:ml_init_name$ >> in
      let class_decl =  
	<:class_str_item< initializer $MlGen.make_call finit [P4helper.expr_lid java_obj; <:expr< (self :> $lid:ml_name$ (* not so good*) ) >> ]$ >>
	  :: class_decl
      in
      
      let body = 
	<:class_expr< 
	object (self) $list:class_decl$
	end >> in
      
      let body = MlGen.make_class_local_decl 
	  [java_obj,<:expr< $lid:class_allocator_name$ () >>] body in
      
      let body = MlGen.make_class_fun [] body in
      [ <:str_item< class virtual $lid:ml_name$ = $body$ >> ]
	
    else 
      let make init acc =
	if cl.cc_abstract && not callback then
	  acc
	else
	  let ml_name =
 	    if callback then Ident.get_method_ml_stub_name init.cmi_ident
	    else Ident.get_method_ml_name init.cmi_ident 
	  and targs = init.cmi_args in
	  let ml_init_name = Ident.get_method_ml_init_name init.cmi_ident 
	  and class_wrapper_name = 
	    if callback then Ident.get_class_ml_stub_wrapper_name init.cmi_class 
	    else Ident.get_class_ml_wrapper_name init.cmi_class 
	  and class_allocator_name = 
	    if callback then Ident.get_class_ml_stub_allocator_name init.cmi_class 
	    else Ident.get_class_ml_allocator_name init.cmi_class in

	  let nargs = List.map (fun i -> ("_p"^string_of_int i)) 
	      (Utilities.interval 0 (List.length targs)) in
	  let args = List.combine nargs targs in
	  
	  let sign = MlType.java_init_signature targs in
	  let java_name = Ident.get_method_java_name init.cmi_ident in 
	  let java_class_name = Ident.get_class_java_qualified_name init.cmi_class in
	  let call_method = MlType.get_init_method java_class_name sign in
	  

	  let class_decl = [ <:class_str_item< inherit $lid:class_wrapper_name$ $lid:java_obj$ >> ] in
	  let class_decl =  
	    if callback then
	      let finit = <:expr< $lid:Ident.get_method_ml_init_stub_name init.cmi_ident$ >> in
	      <:class_str_item< initializer $MlGen.make_call finit (P4helper.expr_lid java_obj::(<:expr< (self :> $lid:ml_name$ ) >>):: List.map P4helper.expr_lid nargs)$ >>
		:: class_decl
	    else
	      class_decl      
	  in

	  let body = 
	    <:class_expr< 
	    object (self) $list:class_decl$
	    end >> in
	  
	  let body = MlGen.make_class_local_decl 
	      [java_obj, MlGen.make_call <:expr< Java.make $str:call_method$ >> (List.map P4helper.expr_lid (nargs))] body in
	  let body = MlGen.make_class_local_decl (MlType.get_args_convertion MlType.convert_to_java args) body in
	  let body = MlGen.make_class_fun nargs body in
	  
	  if callback then
	    <:str_item< class virtual $lid:ml_name$ = $body$ >> :: acc
	  else
	    <:str_item< class $lid:ml_name$ = $body$ >> :: acc

      in
      List.fold_right make cl.cc_inits []
  in
  let init_funs = 
    if not callback then 
      List.concat (List.map make_cl  cl_list) 
    else
      List.concat (List.map make_cl (List.filter (fun cl -> cl.cc_callback ) cl_list)) in
  P4helper.str_items init_funs

let make_class_sig ~callback cl_list = 
  let make_cl cl =
    if Ident.is_interface cl.cc_ident && callback then 
      let ml_name = Ident.get_class_ml_stub_name cl.cc_ident
      and targs = [] in
      
      let jni_type_name = Ident.get_class_ml_jni_type_name cl.cc_ident
      and jni_accessor_name = Ident.get_class_ml_jni_accessor_method_name cl.cc_ident in
      
      let method_list = [] in
      
      (* méthode *)
      let method_list = List.rev_append (MlMethod.make_class_type ~callback:callback cl.cc_public_methods) method_list in 
      let method_list = List.rev_append (MlMethod.make_callback_class_type cl.cc_public_methods) method_list in
      
      (* accesseur *)
      let method_list = 
	  <:class_sig_item< method $lid:jni_accessor_name$ : $lid:jni_type_name$ >> :: method_list in
      
      (* héritage *)
      let method_list = 
	List.fold_right (fun cl method_list -> 
	  <:class_sig_item< method $lid:Ident.get_class_ml_jni_accessor_method_name cl.cc_ident$ : 
	      $lid:Ident.get_class_ml_jni_type_name cl.cc_ident$ >> :: method_list )
	  cl.cc_all_inherited method_list in
      let method_list =
	<:class_sig_item< inherit JniHierarchy.top >> :: method_list in
      
      let sign = MlType.ml_class_signature targs <:class_type< object $list:method_list$ end >> in
      [ <:sig_item< class virtual $lid:ml_name$ : $sign$ >> ]
    else 
      let make init acc =
	if cl.cc_abstract && not callback then
	  acc
	else
	  let ml_name =
 	    if callback then Ident.get_method_ml_stub_name init.cmi_ident
	    else Ident.get_method_ml_name init.cmi_ident 
	  and targs = init.cmi_args 
	  and class_sig_name = 
	    if callback then Ident.get_class_ml_stub_name init.cmi_class 
	    else Ident.get_class_ml_name init.cmi_class in
	  let sign = MlType.ml_class_signature targs <:class_type< $lid:class_sig_name$ >> in
	  if callback then
	    <:sig_item< class virtual $lid:ml_name$ : $sign$ >> :: acc
	  else
	    <:sig_item< class $lid:ml_name$ : $sign$ >> :: acc

      in
      List.fold_right make cl.cc_inits []
  in
  let init_funs = 
    if not callback then 
      List.concat (List.map make_cl  cl_list) 
    else
      List.concat (List.map make_cl (List.filter (fun cl -> cl.cc_callback ) cl_list)) in
  P4helper.sig_items init_funs
