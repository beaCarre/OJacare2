open Camlp4.PreCast

let _loc = Loc.ghost;;

(* [declare .. end] is now gone in the revised syntax, so here are the equivalents *)
 
let str_items items = match List.rev items with
  | [] -> <:str_item< >>
  | last::items -> List.fold_left (fun st item -> <:str_item< $item$; $st$ >>) last items



let sig_items items = match List.rev items with
  | [] -> <:sig_item< >>
  | last::items -> List.fold_left (fun st item -> <:sig_item< $item$; $st$ >>) last items

let class_types items = match List.rev items with
  | [] -> <:class_type< >>
  | last::items -> List.fold_left (fun st item -> <:class_type< $item$ and $st$ >>) last items

let class_exprs items = match List.rev items with
  | [] -> <:class_expr< >>
  | last::items -> List.fold_left (fun st item -> <:class_expr< $item$ and $st$ >>) last items

(* $lid:...$ is more strict in the new camlp4 *)
let jni s = <:ident< Java. $lid:s$ >>
let expr_lid s = <:expr< $lid:s$ >>
