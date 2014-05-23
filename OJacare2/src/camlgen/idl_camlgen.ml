(*	$Id: idl_camlgen.ml,v 1.2 2004/07/19 11:22:50 henry Exp $	*)

open Cidl

open Camlp4.PreCast
let _loc = Loc.ghost

let make_sig c_file = 
 
  let sig_list = [] in
  
  (** type top *)
  let sig_list = <:sig_item< type top >> :: sig_list in

  (** Type jni abstrait *)
  let sig_list = (MlClass.make_jni_type_sig c_file) :: sig_list in

  (** Class type *)
  let class_type = MlClass.make_class_type ~callback:false c_file in
  let sig_list = match class_type with 
  | [] -> sig_list 
  | list -> <:sig_item< class type $MlGen.make_rec_class_type class_type$ >> :: sig_list in

  let class_type = MlClass.make_class_type ~callback:true c_file in
  let sig_list = match class_type with 
  | [] -> sig_list 
  | list -> <:sig_item< class type $MlGen.make_rec_class_type class_type$ >> :: sig_list in
  (*
  (** downcast 'utilisateur' *)
  let sig_list = (MlClass.make_downcast_sig c_file) :: sig_list in
  let sig_list = (MlClass.make_instance_of_sig c_file) :: sig_list in
  
  (** Tableaux *)
  let sig_list = (MlClass.make_array_sig c_file) :: sig_list in
  *)
  (** classe de construction ("utilisateur") *)
  let sig_list = (MlInit.make_class_sig ~callback:false c_file) :: sig_list in
  let sig_list = (MlInit.make_class_sig ~callback:true c_file) :: sig_list in
  
  (** fonctions / méhodes static *)
  let sig_list = (MlMethod.make_static_sig c_file) :: sig_list in
(*    
   (** cast JNI, exporté pour préparé la fonction 'import' *)
   let sig_list = (MlClass.make_jniupcast_sig c_file) :: sig_list in
   let sig_list = (MlClass.make_jnidowncast_sig c_file):: sig_list in 
  
  (** capsule, exporté pour préparé la fonction 'import' *)
  let sig_list = (MlClass.make_wrapper_sig c_file) :: sig_list in
*)
  List.rev sig_list
    
let make c_file =
  
  let str_list = [] in
  
  (** type top et exception *)
  let str_list = (MlClass.make_top ()) :: str_list in
  let str_list = (MlClass.make_exc ()) :: str_list in

  (** Type jni *)
  let str_list = (MlClass.make_jni_type c_file) :: str_list in

  (** Class type *)
  let class_type = MlClass.make_class_type ~callback:false c_file in
  let str_list = match class_type with 
  | [] -> str_list 
  | list -> <:str_item< class type $MlGen.make_rec_class_type class_type$ >> :: str_list in

  let class_type = MlClass.make_class_type ~callback:true c_file in
  let str_list = match class_type with 
  | [] -> str_list 
  | list -> <:str_item< class type $MlGen.make_rec_class_type class_type$ >> :: str_list in
(*
  (** cast JNI *)
  let str_list = (MlClass.make_jniupcast c_file) :: str_list in
  let str_list = (MlClass.make_jnidowncast c_file):: str_list in 

  (** fonction d'allocations *)
  let str_list = (MlClass.make_alloc c_file) :: str_list in
  let str_list = (MlClass.make_alloc_stub c_file) :: str_list in
*)
  (** capsule/souche *)
  let wrapper = [] in
  let wrapper = List.append (MlClass.make_wrapper ~callback:true c_file) wrapper in
  let wrapper = List.append (MlClass.make_wrapper ~callback:false c_file) wrapper in
  let str_list = match wrapper with 
    | [] -> str_list 
    | _ ->
        let list = MlGen.make_rec_class_expr wrapper in
        <:str_item< class $list$ >> :: str_list
  in

  (** downcast 'utilisateur' *)
  let str_list = (MlClass.make_downcast c_file) :: str_list in
  let str_list = (MlClass.make_instance_of c_file) :: str_list in

  (** Tableaux *)
  (*let str_list = (MlClass.make_array c_file) :: str_list in*)

  (** fonction d'initialisation *)
 (* let str_list = (MlInit.make_fun ~callback:false c_file) :: str_list in
  let str_list = (MlInit.make_fun ~callback:true c_file) :: str_list in
 *)
  (** classe de construction *)
  let str_list = (MlInit.make_class ~callback:false c_file) :: str_list in
  let str_list = (MlInit.make_class ~callback:true c_file) :: str_list in

  (** fonctions / méhodes static *)
  let str_list = (MlMethod.make_static c_file) :: str_list in

  List.rev str_list

let output c_file =
  let ast_list = make c_file in
  List.iter (fun ast -> Printers.OCaml.print_implem ast) ast_list (* CR jfuruse: no need of priting one by one *)

let output_sig c_file =
  let ast_list = make_sig c_file in
  List.iter (fun ast -> Printers.OCaml.print_interf ast) ast_list (* CR jfuruse: no need of priting one by one *)
