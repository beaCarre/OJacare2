(*	$Id: mlField.ml,v 1.2 2004/07/19 11:22:50 henry Exp $	*)

open Cidl
(*
let loc = (Lexing.dummy_pos , Lexing.dummy_pos);;

let id_prefix = "__fid_"

let make_class_type f_list =
  let make f = 
    let java_name = Ident.get_method_java_name f.cf_getname
    and typ = f.cf_type
    and ml_getname = Ident.get_method_ml_name f.cf_getname in
    
    let typget = <:ctyp< unit -> $MlType.ml_signature_of_type typ$ >> in
    let mget = <:class_sig_item< method $lid:ml_getname$ : $typget$ >> in

    match f.cf_setname with
      None -> [mget]
    | Some id -> 
	let ml_setname = Ident.get_method_ml_name id in
	let typset = <:ctyp< $MlType.ml_signature_of_type typ$ -> unit >> in
	[ <:class_sig_item< method $lid:ml_setname$ : $typset$ >> ; mget]

  in
  List.concat (List.map make (List.filter (fun f -> not f.cf_static) f_list))
 
let make_dyn clazz java_obj f_list =
  let make f = 
    let java_name = Ident.get_method_java_name f.cf_getname
    and typ = f.cf_type
    and ml_getname = Ident.get_method_ml_name f.cf_getname in

    let id = id_prefix^java_name in
    let sign = MlType.java_signature_of_type typ in
    let id_expr = <:expr< Jni.get_fieldID $lid:clazz$ $str:java_name$ $str:sign$ >> in

    let call_get_method = "Jni.get_"^(MlType.string_of_type typ)^"_field" in    
    let call_get = <:expr< $lid:call_get_method$ $lid:java_obj$ $lid:id$ >> in 
    let mgetbody = MlType.convert_from_java typ call_get in
    let mgetbody = MlGen.make_fun [] mgetbody in

    let mget =  <:class_str_item< method $lid:ml_getname$ = $mgetbody$ >> in

    let m_list = match f.cf_setname with
      None -> [mget]
    | Some set_id ->
	let ml_setname =  Ident.get_method_ml_name set_id 
	and call_set_method = "Jni.set_"^(MlType.string_of_type typ)^"_field"  
	and narg = "_p" in
	let call_set = <:expr< $lid:call_set_method$ $lid:java_obj$ $lid:id$ $lid:narg$ >> in
	
	let msetbody = MlGen.make_local_decl [narg,MlType.convert_to_java typ <:expr< $lid:narg$ >>] call_set in
	let msetbody = MlGen.make_fun [narg,typ] msetbody in
	let mset = <:class_str_item< method $lid:ml_setname$ = $msetbody$ >> in
	[mset;mget] in

    (* Retour *)
    (id,id_expr),m_list

  in
  let id_list, m_list = List.split (List.map make (List.filter (fun f -> not f.cf_static) f_list)) in
  id_list, List.concat m_list



(* Génère les fonctions correspondantes au méthodes 'static' *)
let make_static cl_list =
  let clazz = "clazz" in
  let make_cl cl =
    let classname = Ident.get_javafullclasspath cl.cc_name
    and name = Ident.get_mlname cl.cc_name  in
    let make f = 
      let ml_name = Ident.get_method_ml_name f.cf_getname
      and java_name =  Ident.get_method_java_name f.cf_getname
      and typ =  f.cf_type  in
      let sign = MlType.java_signature [] typ in
      
      (* label de l'id de la méthode *)
      let id = ml_name

      and ml_getname = name^"_"^ml_name in

      let id = id_prefix^java_name in
      let sign = MlType.java_signature_of_type typ in
      let id_expr = <:expr< Jni.get_static_fieldID $lid:clazz$ $str:java_name$ $str:sign$ >> in
      let class_expr =  <:expr< Jni.find_class $str:classname$ >> in

      let call_get_method = "Jni.get_static_"^(MlType.string_of_type typ)^"_field" in    
      let call_get = <:expr< $lid:call_get_method$ $lid:clazz$ $lid:id$ >> in 
      
      let mgetbody = MlType.convert_from_java typ call_get in
      let mgetbody = MlGen.make_fun [] mgetbody in
      let mgetbody = MlGen.make_local_decl [id,id_expr] mgetbody in
      let mgetbody = MlGen.make_local_decl [clazz,class_expr] mgetbody in

      let mget =  <:str_item< value $lid:ml_getname$ = $mgetbody$ >> in

      let m_list = match f.cf_setname with
	None -> [mget]
      | Some set_id ->
	  let ml_setname = ml_name^"_"^Ident.get_method_ml_name set_id 
	  and call_set_method = "Jni.set_static_"^(MlType.string_of_type typ)^"_field"  
	  and narg = "_p" in
	  let call_set = <:expr< $lid:call_set_method$ $lid:clazz$ $lid:id$ $lid:narg$ >> in
	  
	  let msetbody = MlGen.make_local_decl [narg,MlType.convert_to_java typ <:expr< $lid:narg$ >>] call_set in
	  let msetbody = MlGen.make_fun [narg,typ] msetbody in
	  let msetbody = MlGen.make_local_decl [id,id_expr] msetbody in
	  let msetbody = MlGen.make_local_decl [clazz,class_expr] msetbody in
	  let mset = <:str_item< value $lid:ml_setname$ = $msetbody$ >> in
	  [mset;mget] in

      (* Retour *)
      m_list


    in
    List.concat (List.map make (List.filter (fun f -> f.cf_static) cl.cc_fields))
  in
  <:str_item< declare $list:List.concat (List.map make_cl cl_list)$ end >>  
*)
