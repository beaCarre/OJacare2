(*	$Id: def.ml,v 1.4 2004/03/19 23:58:24 henry Exp $	*)

open Idl
open Cidl
open Error

let get_class_by_name env_idl env name =
  let id = 
    try Env_idl.find_class env_idl name with 
    | Not_found -> raise (Error (Eclass_unbound name)) in 
  try Env_ident.find_class env id with
  | Not_found -> raise (Error (Eclass_super_unbound name))

let get_interface_by_name env_idl env name = 
  let id = 
    try Env_idl.find_class env_idl name with 
    | Not_found -> raise (Error (Einterface_unbound name)) in 
  try Env_ident.find_interface env id with
  | Not_found -> raise (Error (Einterface_implements_unbound name))
	
let convert env_idl env def =
  (* Récupère l'identifiant de classe dans l'env. *)
  let id = Env_idl.find_class_simple env_idl def.d_name in

  (* Prise en compte des 'modifiers' *)
  let abstract = Modifiers.is_abstract def.d_modifiers || def.d_interface
  and callback = Annot.is_callback def.d_annot in
  
  (* Recherche de la classe dont on hérite et des interfaces implémentées *)
  let super = match def.d_super with
  | None -> None
  | Some name -> Some (get_class_by_name env_idl env name) in
  let interfaces = List.map (get_interface_by_name env_idl env) def.d_implements in

  (* Génération partie statique *)
  let inits = Init.convert env_idl id def.d_inits in
  let static_methods = Content.convert_static env_idl id def.d_contents in

  let all_inherited = match super with
  | None -> Env_ident.empty
  | Some cl -> Env_ident.add_from_list (cl::cl.cc_all_inherited) Env_ident.empty in
  let all_inherited = List.fold_left (fun env cl -> Env_ident.add_from_list cl.cc_all_inherited env) all_inherited interfaces in
  let all_inherited = List.fold_left (fun env cl -> Env_ident.add_interface env cl.cc_ident cl) all_inherited interfaces in
  let all_inherited = Env_ident.env_to_list all_inherited in

  (* Génération partie dynamique *)
  let env_method = Env_ident.create_method_env ~concrete:(not def.d_interface) interfaces super in
  let methods, public_methods = Content.convert_dynamic env_idl id env_method def.d_contents in

  if not abstract && Method.have_abstract public_methods then raise (Error.Error (Eclass_abstract def.d_name));

  if def.d_interface then
    let self = {
      cc_ident = id;
      cc_abstract = abstract;
      cc_callback = callback;
      cc_extend = None;
      cc_implements = interfaces;
      cc_all_inherited = all_inherited;
      cc_inits = [];
      cc_static_methods = static_methods;
      cc_methods = methods;
      cc_public_methods = public_methods;
    } in
    Env_ident.add_interface env id self
  else
    let self = 
      { 
	cc_abstract = abstract; cc_callback = callback;
	cc_ident = id;
	cc_extend = super; cc_implements = interfaces;
	cc_all_inherited = all_inherited;
	cc_inits = inits; cc_static_methods = static_methods;
	cc_methods = methods; cc_public_methods = public_methods;
      } in 
    Env_ident.add_class env id self




      
      
