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
    | Cmethod (abstract, mcallback, rtype, args) ->   
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
    and java_class_name = Ident.get_class_java_qualified_name m.cm_class 
    and java_cb_class_name = Ident.get_class_java_cb_qualified_name clazz in
    match m.cm_desc with
    | Cmethod (abstract,mcallback,rtyp,targs) -> 
	if callback && abstract && Ident.is_interface m.cm_class then
	  let typ = MlType.ml_signature targs rtyp in
	  None,
	  <:class_str_item< method virtual $lid:ml_name$ : $typ$ >>
	else 
	  let sign = MlType.java_signature targs rtyp in
	  let call_method = 
	    MlType.get_call_method  
	      (if callback && (mcallback|| Ident.is_callback clazz)
	       then java_cb_class_name
	       else java_class_name )
	      (if  callback && (mcallback || Ident.is_callback clazz)
	       then ("_oj_"^java_name) 
	       else java_name) 
	      sign in 
	  let args = List.map2 (fun i t -> ("_p"^string_of_int i),t) 
	      (Utilities.interval 0 (List.length targs)) targs in
	  let nargs = List.map (fun (narg,targ) -> narg) args  in

          (* construction du corps de la méthode *)
	  let body = 
	    if not callback then 
	      MlGen.make_call <:expr< Java.call $str:call_method$  >> (List.map P4helper.expr_lid (java_obj::nargs))
	    else
	      MlGen.make_call2 <:expr< Java.call $str:call_method$  ! $lid:java_obj$  >> (List.map P4helper.expr_lid nargs) in
	  let body = MlType.convert_from_java rtyp body in
	  let body = MlGen.make_local_decl (MlType.get_args_convertion MlType.convert_to_java args) body in
	  let body = MlGen.make_fun args body in
	  
	  None,
	  <:class_str_item< method $lid:ml_name$ = $body$ >>
    
    | Cset typ ->  
	let call_method = MlType.get_accessors_method java_class_name java_name (MlType.java_signature_of_type typ) in
	let narg = "_p" in
	let call = 
	  if callback 
	  then <:expr< Java.set $str:call_method$ ! $lid:java_obj$ $lid:narg$ >>
	  else<:expr< Java.set $str:call_method$  $lid:java_obj$ $lid:narg$ >>   
	in
	let body = MlGen.make_local_decl [narg,MlType.convert_to_java typ <:expr< $lid:narg$ >>] call in
	let body = MlGen.make_fun [narg,typ] body in

	None, (* il y a toujours un get ... *)
	<:class_str_item< method $lid:ml_name$ = $body$ >> 
	  
    | Cget typ ->  
      let call_method = MlType.get_accessors_method java_class_name java_name (MlType.java_signature_of_type typ) in
      let call = 
	if callback 
	then <:expr< Java.get $str:call_method$ ! $lid:java_obj$ >> 
	else <:expr< Java.get $str:call_method$ $lid:java_obj$ >> 
      in
      
	let body = MlType.convert_from_java typ call in 
	let body = MlGen.make_fun [] body in

	None,
	<:class_str_item< method $lid:ml_name$ = $body$ >> 

  in
  let mids, m = List.split (List.map make m_list) in
  List.fold_right (fun m acc -> match m with None -> acc | Some m -> m::acc) mids [] , m 



(** Génère le nom des méthodes attendues pour le proxy *)
let get_proxy_id list_sign_m meth = 
  let java_name = Ident.get_method_java_name meth.cm_ident in
  let java_sign = match meth.cm_desc with 
    | Cmethod (_,_,rtyp,args) -> java_name^MlType.java_signature args rtyp
    | Cget _ | Cset _ ->  invalid_arg "proxy_id"
  in
  let cpt = ref 1 in
  let list = List.filter (fun (m,sign) -> (Ident.get_method_java_name m.cm_ident)=java_name) list_sign_m in
  let rec get_id mlist =
    match mlist with 
      [] ->  "not_found"
    | (mc,sign)::tl -> 
      match mc.cm_desc with 
	Cmethod (_,_,rtyp,args) -> 
	  if sign=java_sign
	  then   (if !cpt = 1 then java_name else (java_name^"_"^(string_of_int !cpt))) 
	  else (  incr cpt ; get_id tl)
      | Cget _ | Cset _ -> invalid_arg "proxy_id"
  in get_id list
  
(** Génère le nom des méthodes attendues pour le proxy *)
let get_list_proxy_id m_list = 
    List.sort 
      (fun (m,sign) -> (fun (m2,sign2) -> String.compare sign sign2 ))
      (List.map (fun m -> 
	match m.cm_desc with 
	  Cmethod (_,_,rtyp,args) -> 
	    (m,((Ident.get_method_java_name m.cm_ident)^(MlType.java_signature args rtyp)))
	| Cget _ | Cset _ -> (m,"invalid_argument get_list_proxy_id ")
       )
	 m_list)   
	  
(** Génère les méthodes appelés par java pour le proxy*)
let make_callback m_list =
  let list_id = get_list_proxy_id 
    (List.filter (fun m -> match m.cm_desc with 
      Cmethod _ -> true
    | Cget _ | Cset _ -> false)	m_list) in
  let make m acc = 
    match m.cm_desc with 
    | Cset _ | Cget _ -> acc
    | Cmethod (abstract,callback,rtyp, targs) -> 
	let ml_name = Ident.get_method_ml_name m.cm_ident
	and ml_stub_name = get_proxy_id list_id m in
	
	(* Listes les arguments *)
	let nargs = List.map (fun i -> "_p"^string_of_int i) 
	    (Utilities.interval 0 (List.length targs)) in
	let args = List.combine nargs targs in
	
	(* construction du corps de la méthode 'proxy' appelée par java *)   
	let stub_body = MlGen.make_call <:expr< self # $lid:ml_name$ >> (List.map P4helper.expr_lid nargs) in
	let stub_body = MlType.convert_to_java rtyp stub_body in
	let stub_body = MlGen.make_local_decl (MlType.get_args_convertion MlType.convert_from_java args) stub_body in 
	let stub_body = 
	  match targs with
	    [] -> stub_body 
	  | targs -> MlGen.make_callback_fun args stub_body 
	in
	<:class_str_item< method $lid:ml_stub_name$ = $stub_body$ >> :: acc
  in
  List.fold_right make m_list []

(** Génère les signatures méthodes appelés par java *) 
let make_callback_class_type m_list =
  let make m acc = 
    match m.cm_desc with 
    | Cset _ | Cget _ -> acc
    | Cmethod (abstract,mcallback,rtyp, targs) -> 
	let ml_stub_name = Ident.get_method_ml_stub_name m.cm_ident in
	let sign = match targs with 
	| [] -> MlType.ml_jni_signature_of_type rtyp
	| targs -> MlType.ml_jni_signature targs rtyp in
	<:class_sig_item< method $lid:ml_stub_name$ : $sign$ >> :: acc
     
  in
  List.fold_right make m_list []

(** Génère les fonctions correspondantes au méthodes 'static' *)
let make_static cl_list =
  let make_cl cl =
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
 	let call_method = MlType.get_accessors_method java_class_name java_name (MlType.java_signature_of_type typ) in
	let call = <:expr< Java.get $str:call_method$ $lid:"()"$ >> in 
	let body = MlType.convert_from_java typ call in
	  let body = MlGen.make_fun [] body in
	  <:str_item< value $lid:ml_name$ = $body$ >>
	  
      | Cmethod (abstract,callback,rtyp,targs) -> 
	  let sign = MlType.java_signature targs rtyp in
	  (*  signature de la méthode et nom de la fonction d'appel *)
	  let call_method =  MlType.get_call_method
	    java_class_name java_name sign in 
	  (* Listes les arguments : par noms puis par valeurs pour le tableau d'argument *)
	  let nargs = List.map (fun i -> "_p"^string_of_int i) 
	      (Utilities.interval 0 (List.length targs)) in
	  let args = List.combine nargs targs in
	  (* construction du corps de la méthode *)
	  let body = MlGen.make_call <:expr< Java.call $str:call_method$ >> (List.map P4helper.expr_lid nargs) in	  
	  let body = MlType.convert_from_java rtyp body in
	  let body = MlGen.make_local_decl (MlType.get_args_convertion MlType.convert_to_java args) body in
	  let body = MlGen.make_fun args body in
	  <:str_item< value $lid:ml_name$ = $body$ >>
    in
    List.map make cl.cc_static_methods
  in
  P4helper.str_items (List.concat (List.map make_cl cl_list))

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
      | Cmethod (abstract,callback,rtyp,targs) -> 
	  let sign = MlType.ml_signature targs rtyp in	  
	  <:sig_item< value $lid:ml_name$ : $sign$ >>
    in
    List.map make cl.cc_static_methods
  in
  P4helper.sig_items (List.concat (List.map make_cl cl_list))
