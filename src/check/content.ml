(*	$Id: content.ml,v 1.1.1.1 2003/10/19 22:57:41 henry Exp $	*)

open Idl 

let convert_static env_idl class_id content_list =

  let convert = 
    let convert_field = Field.convert_static env_idl class_id
    and convert_method = Method.convert_static env_idl class_id in

    fun c ->
      match c with
      | Field f -> convert_field f
      | Method m -> convert_method m in
  
  List.fold_right convert content_list []

let convert_dynamic env_idl class_id env_method content_list =

  let convert = 
    let convert_field = Field.convert_dynamic env_idl class_id
    and convert_method = Method.convert_dynamic env_idl class_id in
    
    fun c -> match c with
    | Field f -> convert_field f
    | Method m -> convert_method m in

  let method_list, env_method = List.fold_right convert content_list ([],env_method) in
  method_list, Env_ident.mmethod_env_to_list env_method

