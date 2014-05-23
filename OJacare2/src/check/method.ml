(*	$Id: method.ml,v 1.3 2004/03/11 21:35:13 henry Exp $	*)

open Idl 
open Cidl
open Error

let convert_dynamic env_idl class_id mmethod (acc,env_method) =
  if Modifiers.is_static mmethod.m_modifiers then
    (acc,env_method)
  else 

    let abstract = Ident.is_interface class_id || Modifiers.is_abstract mmethod.m_modifiers 
    and rtyp = Type.convert env_idl (Annot.have_array mmethod.m_annot) mmethod.m_return_type
    and args = Type.convert_args env_idl mmethod.m_args in

    let id = Ident.make_method_id ~static:false class_id mmethod in
    
    let self = {
      cm_class = class_id;
      cm_ident = id;
      cm_desc = Cmethod (abstract, rtyp, args);
    } in
    let env_method = Env_ident.add_method self env_method in
    self::acc, env_method

let convert_static env_idl class_id mmethod acc =
  if not (Modifiers.is_static mmethod.m_modifiers) then
    acc
  else
    
    let rtyp = Type.convert env_idl (Annot.have_array mmethod.m_annot) mmethod.m_return_type
    and args = Type.convert_args env_idl mmethod.m_args in
   
    if Modifiers.is_abstract mmethod.m_modifiers then
      raise (Error (Emethod_staticabstract mmethod.m_location));
    
    let id = Ident.make_method_id ~static:true class_id mmethod in
    
    { cm_class = class_id;
      cm_ident = id;
      cm_desc = Cmethod (false, rtyp, args)
    } :: acc
  
let is_abstract m = match m.cm_desc with
  | Cmethod (b,_,_) -> b
  | _ -> false
    
let have_abstract mmethod_list =
  List.exists is_abstract mmethod_list
