 (*	$Id: field.ml,v 1.2 2004/03/11 21:35:13 henry Exp $	*)

open Idl
open Cidl
open Error

let convert_dynamic env_idl class_id field (acc,env_method) =
  if Modifiers.is_static field.f_modifiers then
    (acc,env_method)
  else 
    let set_id, get_id = Ident.make_field_method_id ~static:false class_id field in
    let rtyp = Type.convert env_idl (Annot.have_array field.f_annot) field.f_type in

    let acc, env_method = 
      match set_id with
      | None -> acc, env_method
      | Some set_id -> 
    	  let self_set = { cm_class = class_id;
			   cm_ident = set_id;
			   cm_desc = Cset rtyp } in
	  let env_method = Env_ident.add_method self_set env_method in
	  self_set::acc, env_method

    in
    let self_get = { cm_class = class_id;
		     cm_ident = get_id;
		     cm_desc = Cget rtyp } in
	  let env_method = Env_ident.add_method self_get env_method in
	  self_get::acc, env_method

let convert_static env_idl class_id field acc =
  if not (Ident.is_interface class_id) && not (Modifiers.is_static field.f_modifiers) then
    acc
  else
    
    let set_id, get_id = Ident.make_field_method_id ~static:true class_id field in
    let rtyp = Type.convert env_idl (Annot.have_array field.f_annot) field.f_type in

    if Modifiers.is_abstract field.f_modifiers then
      raise (Error (Efield_staticabstract field.f_location));
    
    let acc = 

      match set_id with
      | None -> acc
      | Some set_id ->{ cm_class = class_id;
			cm_ident = set_id;
			cm_desc = Cset rtyp } :: acc 
    in
    { cm_class = class_id;
      cm_ident = get_id;
      cm_desc = Cget rtyp } :: acc
				
				
				
