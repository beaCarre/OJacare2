(*	$Id: mlClass.ml,v 1.5 2004/07/19 11:22:50 henry Exp $	*)

open Cidl

open Camlp4.PreCast
let _loc = Loc.ghost

(** type top et exception ********************************)
let make_top () =
    let jinst = "java'lang'Object" in
    <:str_item< type top =java_instance $lid:jinst$ >>
let make_exc () =
    <:str_item< exception Null_object of string >>

(** type JNI **********************************************)
let make_jni_type cl_list =
  let make cl = 
    let jinst = Ident.get_class_java_oj_name cl.cc_ident in
    let name = Ident.get_class_ml_jni_type_name cl.cc_ident in
    <:str_item< type $lid:name$ =java_instance $lid:jinst$ >> in
  P4helper.str_items (List.map make cl_list)
(* pour le callback *)
let make_jni_CB_type cl_list =
  let make cl =   
    let jinst = Ident.get_class_java_oj_cb_name cl.cc_ident in
    let name = Ident.get_class_ml_jni_cb_type_name cl.cc_ident in
    <:str_item< type $lid:name$ =java_instance $lid:jinst$ >> in
  P4helper.str_items (List.map make (List.filter (fun cl -> (cl.cc_callback||Method.have_callback cl.cc_methods) && not (Ident.is_interface cl.cc_ident)) cl_list))
let make_jni_ICB_type cl_list =
  let make cl =   
    let jinst = Ident.get_class_java_oj_icb_name cl.cc_ident in
    let name = Ident.get_class_ml_jni_icb_type_name cl.cc_ident in
    <:str_item< type $lid:name$ =java_instance $lid:jinst$ >> in
  P4helper.str_items (List.map make (List.filter (fun cl -> (cl.cc_callback||Method.have_callback cl.cc_methods) && not (Ident.is_interface cl.cc_ident)) cl_list))
let make_jni_type_sig cl_list =
  let make cl = 
    let name = Ident.get_class_ml_jni_type_name cl.cc_ident in
    <:sig_item< type $lid:name$ (* abstract *) >> in
  P4helper.sig_items (List.map make cl_list)
  

(** class type ********************************************) (* OK *)
let make_class_type ~callback cl_list = 
  if callback then [] 
  else
    begin
      let make cl = 
	let name = Ident.get_class_ml_name cl.cc_ident in
	let jni_type_name = Ident.get_class_ml_jni_type_name cl.cc_ident
	and jni_accessor_name = Ident.get_class_ml_jni_accessor_method_name cl.cc_ident in
	let method_list = [] in
	
	(* méthode *)
	let method_list = 
	  List.rev_append (MlMethod.make_class_type ~callback:callback cl.cc_public_methods) method_list in 
	
	(* accesseur *)
	let method_list = 
	  <:class_sig_item< method $lid:jni_accessor_name$ : $lid:jni_type_name$ >> :: method_list in
	
        (* héritage *)
	let method_list = 
	  (List.map (fun interface -> <:class_sig_item< inherit $lid:Ident.get_class_ml_name interface.cc_ident$ >>) cl.cc_implements) @ method_list in
	let method_list = 
	  ( match cl.cc_extend with
	    None -> <:class_sig_item< >>
	  | Some super -> <:class_sig_item< inherit $lid:Ident.get_class_ml_name super.cc_ident$ >>) :: method_list
	in  
	name,callback,<:class_type< object $list:method_list$ end >>  
      in
      List.map make cl_list
    end

(** capsule / souche *************************************) 
let make_wrapper ~callback cl_list =
  let java_obj = "jni_ref"   
  and java_proxy = "jni_ref_proxy" 
  and init_ref = "init_jni_ref" in
  let make cl =

    let abstract = callback in

    let jclazz = Ident.get_class_java_signature cl.cc_ident (* si 'callback' aussi, car les appel font du ping-pong *) 
    and class_name = 
      if callback then Ident.get_class_ml_stub_wrapper_name cl.cc_ident
      else Ident.get_class_ml_wrapper_name cl.cc_ident in

    (* construction de la liste des méthodes *)
    let class_decl = [] in
    let jni_ref = if callback then  <:expr< ! $lid:java_obj$ >> else <:expr< $lid:java_obj$ >> in
    let class_decl =
      List.fold_right (fun cl class_decl -> 
	<:class_str_item< method $lid:Ident.get_class_ml_jni_accessor_method_name cl.cc_ident$ = ( $jni_ref$ :> $lid:Ident.get_class_ml_jni_type_name cl.cc_ident$ ) >> 
			  :: class_decl)  cl.cc_all_inherited class_decl 
    in
    (* méthode accesseur Jni *)
    let class_decl = 
      if not callback then
	<:class_str_item< method $lid:Ident.get_class_ml_jni_accessor_method_name cl.cc_ident$ = $lid:java_obj$ >> :: class_decl 
      else 
    	<:class_str_item< method $lid:Ident.get_class_ml_jni_accessor_method_name cl.cc_ident$ = ( $jni_ref$ :> $lid:Ident.get_class_ml_jni_type_name cl.cc_ident$ ) >> :: class_decl 
    in
    
    (* méthodes IDL *)
    let method_ids, methods = 
      MlMethod.make_dyn cl.cc_ident java_obj ~callback:callback cl.cc_public_methods
    in
    let class_decl = List.rev_append methods class_decl in
    let proxy_decl = [] in
    let proxy_decl = List.rev_append(MlMethod.make_callback (List.filter (fun m -> ( Method.have_callback cl.cc_methods && Method.is_callback m) || Ident.is_callback cl.cc_ident )   cl.cc_public_methods)) proxy_decl in
    
    (* initializer :  proxy si 'callback' *)
    let class_decl = 
      if callback then(	
	let proxy_name =
	  if Ident.is_interface cl.cc_ident
	  then Ident.get_class_java_qualified_name cl.cc_ident
	  else Ident.get_class_java_icb_qualified_name cl.cc_ident
	in
	let java_cb_name = Ident.get_class_java_cb_qualified_name cl.cc_ident in
	let proxy = <:expr< object $list:proxy_decl$ end  >> in
	let initialize_decl =  <:expr<  
	  if Java.is_null ! $lid:java_obj$
	  then raise (Null_object $str:java_cb_name$) else ()  >> :: [] in
	let initialize_decl = if Ident.is_interface cl.cc_ident then initialize_decl else 
	    <:expr<  
	  if Java.is_null ! $lid:java_proxy$
	  then raise (Null_object $str:proxy_name$) else ()  >> :: initialize_decl in
	let initialize_decl =   if Ident.is_interface cl.cc_ident then initialize_decl else
	    let e1 = <:expr< ! $lid:java_proxy$ >> in
	    let e2 = <:expr< init_jni_ref $e1$ >> in
	    <:expr< $lid:java_obj$.val := $e2$ >> :: initialize_decl in
	let initialize_decl = 
	  if Ident.is_interface cl.cc_ident 
	  then <:expr< $lid:java_obj$.val := Java.proxy $str:proxy_name$ $proxy$ >> :: initialize_decl 
	  else  <:expr< $lid:java_proxy$.val := Java.proxy $str:proxy_name$ $proxy$ >> :: initialize_decl 
	in
	<:class_str_item< initializer do {$list:initialize_decl$} >> :: class_decl)
      else
	class_decl
    in

    (* corps de l'objet *)
    let class_body =
      <:class_expr< object (self) $list:class_decl$ end  >> in
    
    (* test si l'objet est nul ... *)
    let class_body =      
      if callback then
	if not (Ident.is_interface cl.cc_ident ) then 
	  <:class_expr< 
	    let $lid:java_proxy$ = ref Java.null 		        
	    in $class_body$ >>
	else class_body
      else
	<:class_expr< 
	  let _ = 
	    if Java.is_null $lid:java_obj$
	    then raise (Null_object $str:jclazz$) 
	    else () in $class_body$ >>  
    in
    let class_body =      
      if callback then  
	<:class_expr<
	  let $lid:java_obj$ = ref Java.null
	  in $class_body$ >>
      else class_body
    in

    (* fonction de création, à partir d'une référence
       ou fonction d'initialisation pour les souches *)
   let class_body = 
      if callback  then 
	if (Ident.is_interface cl.cc_ident) 
	then <:class_expr<  $class_body$  >>
	else <:class_expr< fun $lid:init_ref$ -> $class_body$  >>
      else
      <:class_expr< fun ($lid:java_obj$ : $lid:Ident.get_class_ml_jni_type_name cl.cc_ident$) -> $class_body$  >> in 
 
    (* Déclaration des id. de méthode et de champs (capturé dans l'env de la fonction de création) *)
   let class_body = MlGen.make_class_local_decl method_ids class_body in
    
    (* Retour de 'make' : nom, abstract, body*)
    class_name,abstract,class_body 
  
  in
  List.map make (List.filter (fun cl -> (not callback) || cl.cc_callback || (Method.have_callback cl.cc_methods) ) cl_list)




(** engendre les signatures des capsules en prévision de la gestion des "import", 
   mais ne doit pas être utlisé par un programmeur externe *)
let make_wrapper_sig cl_list =
  let make cl =  
    let class_name = Ident.get_class_ml_wrapper_name cl.cc_ident in
    <:sig_item< class $lid:class_name$ : [$lid:Ident.get_class_ml_jni_type_name cl.cc_ident$] -> $lid:Ident.get_class_ml_name cl.cc_ident$ >>
  in
  P4helper.sig_items (List.map make cl_list)

(** engendre les downcasts utilisateurs *)
let make_downcast cl_list =
  let obj ="o" in
  let make cl =
    let name = Ident.get_class_ml_name cl.cc_ident 
    and wname = Ident.get_class_ml_wrapper_name cl.cc_ident 
    and sname = Ident.get_class_ml_name cl.cc_ident 
    and java_name = Ident.get_class_java_qualified_name cl.cc_ident in
    (let body = 
      <:expr< (new $lid:wname$ (Java.cast $str:java_name$ $lid:obj$) : $lid:sname$) >> in
    let body = <:expr< fun ($lid:obj$ : top) -> $body$ >> in
    let fname = name^"_of_top" in
    <:str_item< value $lid:fname$ = $body$ >>)
    :: []
  in
  P4helper.str_items (List.concat (List.map make cl_list))

let make_downcast_sig cl_list =
  let make cl =
    let name = Ident.get_class_ml_name cl.cc_ident in
    (let fname = name^"_of_top" in
    <:sig_item< value $lid:fname$ : top -> $lid:name$ >>) 
    :: [] 
  in
  P4helper.sig_items (List.concat (List.map make cl_list))

(** engendre les instance_of utilisateurs *)
let make_instance_of cl_list =
  let obj ="o" in
  let make cl =
    let ml_name = Ident.get_class_ml_name cl.cc_ident
    and java_name = Ident.get_class_java_qualified_name cl.cc_ident in
    let body = 
      <:expr< Java.instanceof $str:java_name$ $lid:obj$ >> in
    let body = <:expr< fun ($lid:obj$ : top) -> $body$ >> in
    let name = "_instance_of_"^ml_name in
    [ <:str_item< value $lid:name$ = $body$ >> ]
  in
  P4helper.str_items (List.concat (List.map make cl_list))

let make_instance_of_sig cl_list =
  let make cl =
    let ml_name = Ident.get_class_ml_name cl.cc_ident in
    let name = "_instance_of_"^ml_name in
    [ <:sig_item< value $lid:name$ : top -> bool >> ]
  in
  P4helper.sig_items (List.concat (List.map make cl_list))


(** engendre les fonctions de création des tableaux d'objets *)
let make_array cl_list =
  let make cl acc =
    let name_new = Ident.get_class_ml_array_alloc_name cl.cc_ident
    and descr = Ident.get_class_ml_array_descr cl.cc_ident in
    let java_obj = <:expr< $lid:"java_obj"$ >> in
    let obj = <:expr< $lid:"obj"$ >> in
    let ref = <:expr< $lid:"r"$ >> in
    let body_new = <:expr<
      fun size -> 
	let java_obj = Java.make_array $str:descr$ (Int32.of_int $lid:"size"$) in 
         OjArray.wrap_reference_array $java_obj$
          (fun obj -> $obj$ # $lid: Ident.get_class_ml_jni_accessor_method_name cl.cc_ident $)
	  (fun r ->  new $lid: Ident.get_class_ml_wrapper_name cl.cc_ident $ $ref$) >> in
    <:str_item< value $lid:name_new$ = $body_new$ >> :: acc
  in
  P4helper.str_items (List.fold_right make cl_list [])


(** engendre les fonctions de désencapsulation des tableaux d'objets *)
let make_unwrap_array cl_list =
  let make cl acc =
    let name_unwrap = Ident.get_class_ml_array_unwrap_name cl.cc_ident
    and descr = Ident.get_class_ml_array_descr cl.cc_ident   in
    let body = <:expr<
      fun (a: OjArray.t $lid:Ident.get_class_ml_name cl. cc_ident$) -> 
        match OjArray.pack_reference_array a with
	[ OjArray.RefA ra -> 
         Java.cast $str:descr$ (JavaReferenceArray.to_object ra)]
       >> 
    in
    <:str_item< value $lid:name_unwrap$ = $body$ >>  :: acc
  in
  P4helper.str_items (List.fold_right make cl_list [])

let make_array_sig cl_list =
  let make cl =
    let name = Ident.get_class_ml_array_alloc_name cl.cc_ident in
    <:sig_item< value $lid:name$ : int ->
      OjArray.t $lid: Ident.get_class_ml_name cl.cc_ident$  >>
  in
  P4helper.sig_items (List.map make cl_list)

let make_unwrap_array_sig cl_list =
  let make cl =
    let name = Ident.get_class_ml_array_unwrap_name cl.cc_ident in
    <:sig_item< value $lid:name$ :  OjArray.t $lid: Ident.get_class_ml_name cl.cc_ident$ ->
     java_reference_array $lid: Ident.get_class_ml_jni_type_name cl.cc_ident$  >>
  in
  P4helper.sig_items (List.map make cl_list)
