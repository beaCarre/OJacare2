type ml_kind =
  | IDalias (** le nom ml vient d'un alias *)
  | IDdefault (** le nom ml est construit à partir du nom Java *)

(* le type des identifiants de classe de l'IDL *)
type clazz = {
    ic_id: int;

    ic_interface: bool;

    ic_java_package: string list;
    ic_java_name: string;

    ic_ml_name: string;
    ic_ml_name_location: Loc.t;
    ic_ml_name_kind: ml_kind;
  }
      
let is_interface c = c.ic_interface      

let get_class_java_package c = List.rev c.ic_java_package
let get_class_java_package_name c = String.concat "." (get_class_java_package c)

let get_class_java_callback_package c = "callback" :: (get_class_java_package c)
let get_class_java_callback_package_name c = String.concat "." (get_class_java_callback_package c)

let get_class_java_name c = c.ic_java_name
let get_class_java_stub_name c = c.ic_java_name

let get_class_java_oj_name c =  String.concat "'" ((get_class_java_package c) @ [get_class_java_name c])
let get_class_java_jinst_name c = (get_class_java_oj_name c) ^" java_instance"
let get_class_java_qualified_name c = String.concat "." ((get_class_java_package c) @ [get_class_java_name c])
let get_class_java_qualified_stub_name c = String.concat "." ((get_class_java_callback_package c) @ [get_class_java_stub_name c])
let get_class_java_signature c = String.concat "/" ((get_class_java_package c) @ [get_class_java_name c])
let get_class_java_stub_signature c = String.concat "/" ((get_class_java_callback_package c) @ [get_class_java_stub_name c])
let get_class_ml_name c = c.ic_ml_name
let get_class_ml_stub_name c = "_stub_" ^ c.ic_ml_name
let get_class_ml_interface_init_name c = "_funinit_" ^ get_class_ml_stub_name c 
let get_class_ml_name_location c = c.ic_ml_name_location

let get_class_ml_jni_type_name c = "_jni_" ^ get_class_ml_name c
let get_class_ml_wrapper_name c = "_capsule_" ^ get_class_ml_name c
let get_class_ml_stub_wrapper_name c = "_souche_" ^ get_class_ml_name c

let get_class_ml_allocator_name c = "_alloc_" ^ get_class_ml_name c
let get_class_ml_stub_allocator_name c = "_alloc_" ^ get_class_ml_stub_name c
let get_class_ml_jni_accessor_method_name c = "_get_jni_" ^ get_class_ml_name c

let get_class_ml_array_alloc_name c = "_new_jArray_" ^ get_class_ml_name c
let get_class_ml_array_init_name c = "jArray_init_"  ^ get_class_ml_name c

let compare_clazz id1 id2 = 
  Pervasives.compare id1.ic_id id2.ic_id

type mmethod = {
    im_java_name: string;

    im_ml_id: int; (** entier unique pour une nom ml *)
    im_ml_name: string;
    im_ml_name_location:Loc.t;
    im_ml_name_kind: ml_kind;
  }
    
let get_method_java_name m = m.im_java_name
let get_method_ml_name m = m.im_ml_name
let get_method_ml_name_location m = m.im_ml_name_location
let get_method_ml_stub_name m = "_stub_" ^ get_method_ml_name m

let get_method_ml_init_name m = "_init_" ^ get_method_ml_name m
let get_method_ml_init_stub_name m = "_init_" ^ get_method_ml_stub_name m


let compare_method id1 id2 = 
  Pervasives.compare id1.im_ml_id id2.im_ml_id

open Idl
open Error

let make_class_ident = 
  let stamp = ref 0 in
  fun package def ->
    let id = !stamp in incr stamp;
    let java_name = def.d_name.id_desc
    and ml_name, ml_loc, ml_kind = 
      match Annot.get_name def.d_annot with
      | None -> "j"^def.d_name.id_desc, def.d_name.id_location, IDdefault (* param... *)
      | Some mlname -> mlname.id_desc, mlname.id_location, IDalias in
    { ic_id = id;
      ic_interface = def.d_interface;
      ic_java_package = package;
      ic_java_name = java_name;
      ic_ml_name = ml_name; 
      ic_ml_name_location = ml_loc;
      ic_ml_name_kind = ml_kind; }

module OrderedString = 
  struct
    type t = string
    let compare id1 id2 =  Pervasives.compare id1 id2
  end
module StringEnv = Map.Make(OrderedString)


let get_unique_id =
  let env = ref StringEnv.empty 
  and stamp = ref 0 in
  fun name ->
    try StringEnv.find name !env
    with
    | Not_found -> 
	let id = !stamp in incr stamp; 
	env := StringEnv.add name id !env;
	id
	  
let make_init_method_id class_id init =
  match Annot.get_name init.i_annot with
  | None -> 
      let ml_name = get_class_ml_name class_id
      and ml_loc = get_class_ml_name_location class_id in
      { im_java_name = "<init>";
	im_ml_id = get_unique_id ml_name;
	im_ml_name = ml_name;
	im_ml_name_location = ml_loc;
	im_ml_name_kind = IDdefault;
      }
  | Some name ->
      let ml_name = name.id_desc 
      and ml_loc = name.id_location in
      if Utilities.is_capitalized name.id_desc then
	raise (Error (Emethod_capitalized name));  (* à mettre dans la seconde étape *)
      { im_java_name = "<init>";
	im_ml_id = get_unique_id ml_name;
	im_ml_name = ml_name;
	im_ml_name_location = ml_loc;
	im_ml_name_kind = IDalias;
      }

let make_field_method_id ~static class_id field =
  let package = String.concat "_" ((get_class_java_package class_id) @ [get_class_ml_name class_id]) in
  let ml_set_name, ml_get_name, ml_loc, ml_kind = 
    match Annot.get_name field.f_annot with
    | None ->
	(if static then package^"__set_"^field.f_name.id_desc (* param ... *)
	else "set_"^field.f_name.id_desc(* param ... *)),
	(if static then package^"__get_"^field.f_name.id_desc (* param ... *)
	else "get_"^field.f_name.id_desc(* param ... *)),
	field.f_name.id_location, IDdefault
    | Some name -> "set_"^name.id_desc, "get_"^name.id_desc, name.id_location, IDalias in
  (if Modifiers.is_final field.f_modifiers then
    None
  else
    Some { im_java_name = field.f_name.id_desc;
	   im_ml_id = get_unique_id ml_set_name;
	   im_ml_name = ml_set_name;
	   im_ml_name_location = ml_loc;
	   im_ml_name_kind = ml_kind;
	 }),
  { im_java_name = field.f_name.id_desc;
    im_ml_id = get_unique_id ml_get_name;
    im_ml_name = ml_get_name;
    im_ml_name_location = ml_loc;
    im_ml_name_kind = ml_kind;
  }
    
let make_method_id ~static class_id mmethod =
  let package = String.concat "_" ((get_class_java_package class_id) @ [get_class_ml_name class_id]) in
  match Annot.get_name mmethod.m_annot with
  | None -> 
      let ml_name = 
	if static then package^"__"^mmethod.m_name.id_desc
	else 	  
	  if Utilities.is_capitalized mmethod.m_name.id_desc then
	    raise (Error (Emethod_capitalized mmethod.m_name))  (* à mettre dans la seconde étape *)
	  else
	    mmethod.m_name.id_desc in
      { im_java_name = mmethod.m_name.id_desc;
	im_ml_id = get_unique_id ml_name;
	im_ml_name = ml_name;
	im_ml_name_location = mmethod.m_name.id_location;
	im_ml_name_kind = IDdefault;
      }
  | Some name ->
      let ml_name = 
	if Utilities.is_capitalized name.id_desc then
	  raise (Error (Emethod_capitalized name))  (* à mettre dans la seconde étape *)
	else
	  name.id_desc in
      { im_java_name = mmethod.m_name.id_desc;
	im_ml_id = get_unique_id ml_name;
	im_ml_name = ml_name;
	im_ml_name_location = name.id_location;
	im_ml_name_kind = IDalias;
      }
