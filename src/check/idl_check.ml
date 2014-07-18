(*	$Id: idl_check.ml,v 1.1.1.1 2003/10/19 22:57:41 henry Exp $	*)

open Idl
open Error
  
let check_package env_idl acc package =
  List.fold_left (Def.convert (package.p_name,env_idl)) acc package.p_defs 
    
let main filename file =
  try
    let env_idl = Env_idl.add_file file Env_idl.empty_clazz_env in
    let env = List.fold_left (check_package env_idl) Env_ident.empty file in
    Env_ident.env_to_list env
  with
    Error err -> 
      let loc = explain err in
      (match loc with
      | None -> ()
      | Some loc -> 
	  let inchan = open_in filename in
	  Loc.print_source inchan loc;
	  close_in inchan);
      exit 3
