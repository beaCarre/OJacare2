(*	$Id: env_idl.ml,v 1.1.1.1 2003/10/19 22:57:41 henry Exp $	*)



module OrderedClassIdl = 
  struct
    type t = string list * Idl.ident 
    let compare id1 id2 = 
      match Pervasives.compare (fst id1) (fst id2) with
	0 -> Pervasives.compare (snd id1).Idl.id_desc (snd id2).Idl.id_desc
      | i -> i
  end
module ClassIdlEnv = Map.Make(OrderedClassIdl)

type clazz_env = Ident.clazz ClassIdlEnv.t
let empty_clazz_env = ClassIdlEnv.empty

let find_class_simple (current_package,env_class) name = 
	  ClassIdlEnv.find (current_package,name) env_class

let find_class (current_package,env_class) name = 
  match current_package, name.Idl.qid_package with
  | package,[]
  | _,package -> 
	  ClassIdlEnv.find (package,name.Idl.qid_name) env_class

open Idl
open Error

let add = ClassIdlEnv.add
let mem = ClassIdlEnv.mem

let add_def package env def =
  let idl_name = package, def.d_name in
  if mem idl_name env then
    raise (Error (Eclass_double_def idl_name));
  add idl_name (Ident.make_class_ident package def)env

let add_package env package =
  List.fold_left (add_def package.p_name) env package.p_defs 

let add_file file env = 
  List.fold_left add_package env file 

