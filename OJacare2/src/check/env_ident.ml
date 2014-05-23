(*	$Id: env_ident.ml,v 1.4 2004/03/19 23:59:50 henry Exp $	*)

module OrderedClassIdent = 
  struct
    type t = Ident.clazz
    let compare = Ident.compare_clazz
  end
module ClassIdentEnv = Map.Make(OrderedClassIdent)

type t = (Cidl.clazz) ClassIdentEnv.t

let empty = ClassIdentEnv.empty

let add_interface env id clazz = 
  if not (Ident.is_interface id) then failwith "Env_ident.add_interface";
  ClassIdentEnv.add id clazz env

let find_interface env id = if not (Ident.is_interface id) then raise Not_found;
  ClassIdentEnv.find id env

let add_class env id interface = if Ident.is_interface id then failwith "Env_ident.add_class";
  ClassIdentEnv.add id interface env
let find_class env id = if Ident.is_interface id then raise Not_found;
  ClassIdentEnv.find id env

let add_from_list l env = List.fold_right (fun cl env -> ClassIdentEnv.add cl.Cidl.cc_ident cl env) l env
let env_to_list env = List.rev (ClassIdentEnv.fold (fun id clazz acc -> clazz :: acc) env [])

module OrderedMethodIdent = 
  struct
    type t = Ident.mmethod
    let compare = Ident.compare_method 
  end
module MethodIdentEnv = Map.Make(OrderedMethodIdent)

type 'a mmethod_env = 'a MethodIdentEnv.t

open Error
open Cidl

let empty_method_env = MethodIdentEnv.empty
    
let are_methods_compatible m1 m2 = 
 ( match m1.cm_desc, m2.cm_desc with
  | Cget t1 , Cget t2 | Cset t1 , Cset t2 ->  t1 = t2
  | Cmethod (_, rt1, args1), Cmethod (_, rt2, args2) -> rt1 = rt2 && args1 = args2
  | _, _ -> false)
    && Ident.get_method_java_name m1.cm_ident = Ident.get_method_java_name m2.cm_ident

let add_method mmethod env =
  let id = mmethod.cm_ident in
  let env = 
    if MethodIdentEnv.mem id env then 
      if not (are_methods_compatible (MethodIdentEnv.find id env) mmethod) then
	raise (Error (Emethod_ml_overloading (Ident.get_method_ml_name id , Ident.get_method_ml_name_location id)))
      else
	MethodIdentEnv.remove id env
    else env in
  MethodIdentEnv.add id mmethod env


let make_concrete mmethod = 
 { mmethod with 
   cm_desc = match mmethod.cm_desc with
   | Cmethod (_, rtyp, args) -> Cmethod(false, rtyp, args)
   | d -> d }

let add_inherited_method concrete mmethod env =
  let id = mmethod.cm_ident in
  let env = 
    if MethodIdentEnv.mem id env then 
      if not (are_methods_compatible (MethodIdentEnv.find id env) mmethod) then
	raise (Error (Emethod_ml_overloading (Ident.get_method_ml_name id, Ident.get_method_ml_name_location id)))
      else
	MethodIdentEnv.remove id env
    else env in    
  if concrete then
    MethodIdentEnv.add id (make_concrete mmethod) env
  else
    MethodIdentEnv.add id mmethod env
    
let create_method_env ?(concrete=false) interfaces super =
  let env = MethodIdentEnv.empty in
  let env = match super with
  | None -> env
  | Some super -> List.fold_right (add_inherited_method false) super.cc_public_methods env in
  let env = List.fold_left (fun env interface -> List.fold_right (add_inherited_method concrete) interface.cc_public_methods env) env interfaces in
env

let mmethod_env_to_list env = 
  List.rev (MethodIdentEnv.fold (fun id e acc -> e::acc) env [])
