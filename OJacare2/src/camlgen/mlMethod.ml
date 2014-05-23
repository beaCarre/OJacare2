(*	$Id: mlMethod.ml,v 1.5 2004/07/19 11:22:51 henry Exp $	*)

open Cidl

open Camlp4.PreCast
let _loc = Loc.ghost;;

let mid_prefix = "__mid_"
let fid_prefix = "__fid_"

(** Génère la liste des signatures des méthodes *)
let make_class_type ~callback:callback m_list =
  let make m = 
    match m.cm_desc with
    | Cmethod (abstract, rtype, args) ->   
	let typ = MlType.ml_signature args rtype in
        if abstract && callback then 
          (* car classe abstraite sans callback on ne genère pas de constructeur,
	     seul un _wrapper_ *)
	  <:class_sig_item< method virtual $lid:Ident.get_method_ml_name m.cm_ident$ : $typ$ >> 
	else 
	  <:class_sig_item< method $lid:Ident.get_method_ml_name m.cm_ident$ : $typ$ >> 
    | Cset typ -> 	
	let typ = MlType.ml_signature [typ] Cvoid in
	<:class_sig_item< method $lid:Ident.get_method_ml_name m.cm_ident$ : $typ$ >>
    | Cget typ ->
	let typ = MlType.ml_signature [] typ in
	<:class_sig_item< method $lid:Ident.get_method_ml_name m.cm_ident$ : $typ$ >>
 
  in
  List.map make m_list

(** Génère les implantations de méthodes pour les capsule / souches *)
let make_dyn clazz java_obj ~callback m_list =
  let make m =
    let ml_name = Ident.get_method_ml_name m.cm_ident
    and java_name = Ident.get_method_java_name m.cm_ident 
    and java_class_name = Ident.get_class_java_qualified_name m.cm_class in
    match m.cm_desc with
    | Cmethod (abstract,rtyp,targs) -> 
	
	if abstract && callback then

	  let typ = MlType.ml_signature targs rtyp in
	  None,
	  <:class_str_item< method virtual $lid:ml_name$ : $typ$ >>
	else 
          (* label de l'id de la méthode *)
	  let id = mid_prefix^ml_name
				 
	  (* Jni : signature de la méthode et nom de la fonction d'appel *)
	  and sign = MlType.java_signature targs rtyp in

	  let call_method = MlType.get_call_method java_class_name java_name sign in 

          (* Listes les arguments : par noms puis par valeurs pour le tableau d'argument *)
	  let args = List.map2 (fun i t -> ("_p"^string_of_int i),t) 
	      (Utilities.interval 0 (List.length targs)) targs in
	  let jargs = List.map (fun (narg,targ) -> 
	    <:expr< (*$id:MlType.constructor_of_type targ$*) $lid:narg$  >>) args in

	  let nargs = List.map (fun (narg,targ) -> narg) args  in

          (* construction du corps de la méthode *) (* TODO long char *)
	  let body = 
	    if not callback then 
	      MlGen.make_call <:expr< Java.call $str:call_method$  >> (List.map P4helper.expr_lid (java_obj::nargs))
              (*<:expr< Java.call $str:call_method$ $lid:java_obj$ $list:nargs$ >> *)
	    else
	      MlGen.make_call <:expr< Java.call $str:call_method$ $lid:java_obj$ >> (List.map P4helper.expr_lid nargs)
	     (* <:expr< Java.call $str:call_method$ $lid:java_obj$ $lid:clazz$ $list:nargs$ >> *) in
	  let body = MlType.convert_from_java rtyp body in
	  let body = MlGen.make_local_decl (MlType.get_args_convertion MlType.convert_to_java args) body in
	  let body = MlGen.make_fun args body in
	  
          (* retourne les infos pour la recherche de l'id de méthode, et le corps de la méthode *)
	  None,
	  <:class_str_item< method $lid:ml_name$ = $body$ >>

    | Cset typ ->   (* TODO *)
	let call_method = MlType.get_accessors_method java_class_name java_name (MlType.java_signature_of_type typ) in
	let narg = "_p" in
	let call = <:expr< Java.set $str:call_method$ $lid:java_obj$ $lid:narg$ >> in
	
	let body = MlGen.make_local_decl [narg,MlType.convert_to_java typ <:expr< $lid:narg$ >>] call in
	let body = MlGen.make_fun [narg,typ] body in

	None, (* il y a toujours un get ... *)
	<:class_str_item< method $lid:ml_name$ = $body$ >> 
	  
    | Cget typ ->   (* TODO *)
      let call_method = MlType.get_accessors_method java_class_name java_name (MlType.java_signature_of_type typ) in
      let call = <:expr< Java.get $str:call_method$ $lid:java_obj$ >> in
      
	let body = MlType.convert_from_java typ call in 
	let body = MlGen.make_fun [] body in

	None,
	<:class_str_item< method $lid:ml_name$ = $body$ >> 

  in
  let mids, m = List.split (List.map make m_list) in
  List.fold_right (fun m acc -> match m with None -> acc | Some m -> m::acc) mids [] , m 
    
(** Génère les méthodes appelés par java *) (* B : cb donc pas pour le moment *)
let make_callback m_list =
  let make m acc = 
    match m.cm_desc with 
    | Cset _ | Cget _ -> acc
    | Cmethod (abstract,rtyp, targs) -> 
	let ml_name = Ident.get_method_ml_name m.cm_ident
	and java_name = Ident.get_method_java_name m.cm_ident
	and ml_stub_name = Ident.get_method_ml_stub_name m.cm_ident in
	
	(* Listes les arguments : par noms *)
	let nargs = List.map (fun i -> "_p"^string_of_int i) 
	    (Utilities.interval 0 (List.length targs)) in
	let args = List.combine nargs targs in
	
	(* construction du corps de la méthode 'stub' appelé par java *)   
	let stub_body = MlGen.make_call <:expr< self # $lid:ml_name$ >> (List.map P4helper.expr_lid nargs) in
	let stub_body = MlType.convert_to_java rtyp stub_body in
	let stub_body = MlGen.make_local_decl (MlType.get_args_convertion MlType.convert_from_java args) stub_body in 
	let stub_body = 
	  (* exceptionellemment car cette méthode n'est appelé que de Java, le passage de unit étant peu significatif *)
	  match targs with
	    [] -> stub_body 
	  | targs -> MlGen.make_callback_fun args stub_body 
	in
	<:class_str_item< method $lid:ml_stub_name$ = $stub_body$ >> :: acc
      
  in
  List.fold_right make m_list []

(** Génère les signatures méthodes appelés par java *) (* B : CB donc pas pour le moment *)
let make_callback_class_type m_list =
  let make m acc = 
    match m.cm_desc with 
    | Cset _ | Cget _ -> acc
    | Cmethod (abstract,rtyp, targs) -> 
	let ml_stub_name = Ident.get_method_ml_stub_name m.cm_ident in
	let sign = match targs with 
	| [] -> MlType.ml_jni_signature_of_type rtyp
	| targs -> MlType.ml_jni_signature targs rtyp in
	<:class_sig_item< method $lid:ml_stub_name$ : $sign$ >> :: acc
     
  in
  List.fold_right make m_list []

(** Génère les fonctions correspondantes au méthodes 'static' *)
let make_static cl_list =
  let clazz = "clazz" in
  let id = "id" in
  let make_cl cl =
    let class_name = Ident.get_class_java_signature cl.cc_ident in
    let class_expr =  <:expr< Jni.find_class $str:class_name$ >> in
    let make m = 
      let ml_name = Ident.get_method_ml_name m.cm_ident 
      and java_name =  Ident.get_method_java_name m.cm_ident 
      and java_class_name = Ident.get_class_java_qualified_name m.cm_class in
      match m.cm_desc with 

	| Cset typ ->	  
	  let call_method = MlType.get_accessors_method java_class_name java_name (MlType.java_signature_of_type typ) in
	  let narg = "_p" in
	  let call = <:expr< Java.set $str:call_method$ $lid:"()"$ $lid:narg$ >> in
	  
	  let body = MlGen.make_local_decl [narg,MlType.convert_to_java typ <:expr< $lid:narg$ >>] call in
	  let body = MlGen.make_fun [narg,typ] body in
	  <:str_item< $lid:ml_name$ = $body$ >> 











      | Cget typ -> 
	  let sign = MlType.java_signature_of_type typ in
	  let id_expr = <:expr< Jni.get_static_fieldID $lid:clazz$ $str:java_name$ $str:sign$ >> in
	  let err = "Unknown static field from IDL in class \\\""^
	    (Ident.get_class_java_qualified_name m.cm_class)^"\\\" : \\\""^
	    MlType.idl_signature_of_type typ ^ " " ^ java_name ^"\\\"." in
	  let safe_id_expr = 
	    <:expr<try $id_expr$ with _ -> failwith $str:err$>> in

	  let call_method_name = <:ident< Jni. $lid: "get_static_"^(MlType.string_of_type typ)^"_field"$ >> in    
	  let call = <:expr< $id:call_method_name$ $lid:clazz$ $lid:id$ >> in 
	  
	  let body = MlType.convert_from_java typ call in
	  let body = MlGen.make_fun [] body in
	  let body = MlGen.make_local_decl [id,safe_id_expr] body in
	  let body = MlGen.make_local_decl [clazz,class_expr] body in

	  <:str_item< value $lid:ml_name$ = $body$ >>
	  
      | Cmethod (abstract,rtyp,targs) -> 
	  let sign = MlType.java_signature targs rtyp in
	  let id_expr = <:expr< Jni.get_static_methodID $lid:clazz$ $str:java_name$ $str:sign$  >> in
	  let err = "Unknown static method from IDL in class \\\""^
	    (Ident.get_class_java_qualified_name m.cm_class)^"\\\" : \\\""^
	    MlType.idl_signature_of_type rtyp ^ " " ^ java_name ^ "("^
	    MlType.idl_signature targs^")\\\"." in
	  let safe_id_expr = 
	    <:expr<try $id_expr$ with _ -> failwith $str:err$>> in

	  (* Jni : signature de la méthode et nom de la fonction d'appel *)
	  let call_method = P4helper.jni ("call_static_"^(MlType.string_of_type rtyp)^"_method") in 
	  
	  (* Listes les arguments : par noms puis par valeurs pour le tableau d'argument *)
	  let nargs = List.map (fun i -> "_p"^string_of_int i) 
	      (Utilities.interval 0 (List.length targs)) in
	  let args = List.combine nargs targs in
	  let jargs = List.map (fun (narg,targ) -> 
	    <:expr< $id:MlType.constructor_of_type targ$ $lid:narg$  >>) args in
	  
	  (* construction du corps de la méthode *)
	  let body = <:expr< $id:call_method$ $lid:clazz$ $lid:id$ [| $list:jargs$ |] >> in
	  	  
	  let body = MlType.convert_from_java rtyp body in
	  let body = MlGen.make_local_decl (MlType.get_args_convertion MlType.convert_to_java args) body in
	  let body = MlGen.make_fun args body in
	  let body = MlGen.make_local_decl [id,safe_id_expr] body in
	  let body = MlGen.make_local_decl [clazz,class_expr] body in
	  
	  <:str_item< value $lid:ml_name$ = $body$ >>
    in
    List.map make cl.cc_static_methods
  in
  P4helper.str_items (List.concat (List.map make_cl cl_list))
  (* <:str_item< declare $list:List.concat (List.map make_cl cl_list)$ end >>   *)

(** Génère les sigantures des fonctions correspondantes au méthodes 'static' *)
let make_static_sig cl_list =
  let make_cl cl =
    let make m = 
      let ml_name = Ident.get_method_ml_name m.cm_ident in
      match m.cm_desc with 
      | Cset typ ->
	  let sign = MlType.ml_signature [typ] Cvoid in
	   <:sig_item< value $lid:ml_name$ : $sign$ >>

      | Cget typ -> 
	  let sign = MlType.ml_signature [] typ in
	  <:sig_item< value $lid:ml_name$ : $sign$ >>
	  
      | Cmethod (abstract,rtyp,targs) -> 
	  let sign = MlType.ml_signature targs rtyp in	  
	  <:sig_item< value $lid:ml_name$ : $sign$ >>
    in
    List.map make cl.cc_static_methods
  in
  P4helper.sig_items (List.concat (List.map make_cl cl_list))
