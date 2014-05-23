(*	$Id: init.ml,v 1.1.1.1 2003/10/19 22:57:41 henry Exp $	*)

open Idl
open Cidl
open Error

let convert_init env_idl class_id init =

  let method_id = Ident.make_init_method_id class_id init in
  let args = Type.convert_args env_idl init.i_args in

  { cmi_ident = method_id;
    cmi_class = class_id;
    cmi_args = args;
  } 

let convert env_idl class_id init_list =
  List.map (convert_init env_idl class_id) init_list
