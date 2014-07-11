(*	$Id: mlInit.ml,v 1.4 2004/07/19 11:22:50 henry Exp $	*)

open Cidl

open Camlp4.PreCast
let _loc = Loc.ghost;;

let make_class ~callback cl_list = 
  let java_obj = "java_obj" in
  let make_cl cl =
    if Ident.is_interface cl.cc_ident && callback then 
      let ml_name = Ident.get_class_ml_stub_name cl.cc_ident 
      and class_wrapper_name = Ident.get_class_ml_stub_wrapper_name cl.cc_ident
      in
      let class_decl = [ <:class_str_item< inherit $lid:class_wrapper_name$ >> ] in
      let body = 
	<:class_expr< 
	object (self) $list:class_decl$
	end >> in
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
	  let class_wrapper_name = 
	    if callback then Ident.get_class_ml_stub_wrapper_name init.cmi_class 
	    else Ident.get_class_ml_wrapper_name init.cmi_class 
	  in
	  let nargs = List.map (fun i -> ("_p"^string_of_int i)) 
	    (Utilities.interval 0 (List.length targs)) in
	  let args = List.combine nargs targs in
	  
	  let sign = MlType.java_init_signature targs in
	  let sign_cb = MlType.java_init_signature (Ccallback(init.cmi_class)::targs) in
	  let java_class_name = Ident.get_class_java_qualified_name init.cmi_class in
	  let java_cb_class_name = Ident.get_class_java_cb_qualified_name init.cmi_class in
	  let call_method =   
	    if not callback then MlType.get_init_method java_class_name sign
	    else MlType.get_init_method java_cb_class_name sign_cb
	  in
	  let init_name = Ident.get_method_ml_init_stub_name init.cmi_ident in

	  let class_decl =
	    if callback then
	      let init = <:expr< $lid:init_name$ >> in
	      let finit = <:expr<$ (MlGen.make_call2 init (List.map P4helper.expr_lid nargs)) $>> in
(*	      let wrap = <:class_expr< $$ >> in *)
	      let largs =  <:class_expr< $lid:class_wrapper_name$ $finit$ >> in
	      [ <:class_str_item< inherit $largs$>> ]
		 
	    else
	      [ <:class_str_item< inherit $lid:class_wrapper_name$ $lid:java_obj$ >> ]  
	  in
	  
	  let body = 
	    <:class_expr< 
	    object (self) $list:class_decl$
	    end >> in
	  let ref_proxy ="jni_ref_proxy" in	 
	  let call =  MlGen.make_call2 <:expr< Java.make $str:call_method$ >> (List.map P4helper.expr_lid (ref_proxy::nargs)) in
	  let call =  <:expr< fun ($lid:ref_proxy$ : $lid:Ident.get_class_ml_jni_icb_type_name init.cmi_class $) -> $call$>> in

	  let body = 
	  if callback then
	    MlGen.make_class_local_decl 
	      [init_name,  MlGen.make_fun2 args call] body 
	  else 
	    MlGen.make_class_local_decl 
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
      List.concat (List.map make_cl (List.filter (fun cl -> cl.cc_callback || (Method.have_callback cl.cc_methods) ) cl_list)) in
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
      
      (* accesseur *)
      let method_list = 
	  <:class_sig_item< method $lid:jni_accessor_name$ : $lid:jni_type_name$ >> :: method_list in
      
      (* héritage *)
      let method_list = 
	List.fold_right (fun cl method_list -> 
	  <:class_sig_item< method $lid:Ident.get_class_ml_jni_accessor_method_name cl.cc_ident$ : 
	      $lid:Ident.get_class_ml_jni_type_name cl.cc_ident$ >> :: method_list )
	  cl.cc_all_inherited method_list in
      
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
	  and class_sig_name =  Ident.get_class_ml_name init.cmi_class in
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
      List.concat (List.map make_cl (List.filter (fun cl -> cl.cc_callback || (Method.have_callback cl.cc_methods) ) cl_list)) in
  P4helper.sig_items init_funs
