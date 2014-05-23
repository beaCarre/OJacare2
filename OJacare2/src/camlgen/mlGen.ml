(*	$Id: mlGen.ml,v 1.2 2004/07/19 11:22:50 henry Exp $	*)

open Cidl

open Camlp4.PreCast

let _loc = Loc.ghost;;

(* Construction d'appel de fonction *)
let make_call f nargs =
  match nargs with
    [] -> <:expr< $f$ () >>
  | nargs -> List.fold_left
	(fun e narg -> <:expr< $e$ $narg$ >>)
	f nargs

(* Construction d'appel de fonction "super" *)
let make_inherit super nargs =
  let e =  match nargs with
    [] -> <:class_expr< $lid:super$ () >>
  | nargs ->
      List.fold_left
	(fun e narg -> <:class_expr< $e$ $lid:narg$ >>)
	<:class_expr< $lid:super$ >> nargs
  in
  <:class_str_item< inherit $e$ >>


(* Construction de fonction *)
let make_fun args body =
  match args with
    [] -> <:expr< fun () -> $body$ >>
  | args ->
      List.fold_right
	(fun (narg,targ) e -> match targ with
	| Cobject (Cname id) -> <:expr< fun ($lid:narg$ : $lid:Ident.get_class_ml_name id$) -> $e$>>
	| Cobject (Carray t) -> <:expr< fun ($lid:narg$ : array $MlType.ml_signature_of_type t$) -> $e$>>
	| Cobject (Cjavaarray t) -> <:expr< fun ($lid:narg$ : JniArray.jArray $MlType.ml_signature_of_type t$) -> $e$>>
	| Cobject Ctop -> <:expr< fun ($lid:narg$ : JniHierarchy.jTop) -> $e$>>
	| _ -> <:expr< fun $lid:narg$ -> $e$>>)
	args body

(* Construction de fonction de calback *)
let make_callback_fun args body =
  match args with
    [] -> <:expr< fun () -> $body$ >>
  | args ->
      List.fold_right
	(fun (narg,targ) e -> match targ with
	  Cobject (Cname id) -> <:expr< fun ($lid:narg$ : $lid:Ident.get_class_ml_jni_type_name id$) -> $e$>>
	| Cobject Ctop -> <:expr< fun ($lid:narg$ : JniHierarchy.obj) -> $e$>>
	| _ -> <:expr< fun $lid:narg$ -> $e$>>)
	args body

(* Construction de fonction de classe (constructeur) *)
let make_class_fun nargs body =
  match nargs with
    [] -> <:class_expr< fun () -> $body$ >>
  | nargs ->
      List.fold_right
	(fun narg e -> <:class_expr< fun $lid:narg$ -> $e$>>)
	nargs body 

let rec make_local_decl l body =
  match l  with
    [] -> body
  | (name,e)::l -> make_local_decl l <:expr< let $lid:name$ = $e$ in $body$ >>

let rec make_class_local_decl l body =
  match l  with
    [] -> body
  | (name,e)::l -> make_class_local_decl l <:class_expr< let $lid:name$ = $e$ in $body$ >>

open Ast

let make_rec_class_type clazz_list =
  let make (name,abstract,expr (* it is class_type actually *)) =
    if abstract then
      <:class_type< virtual $name$ = $expr$ >>
    else
      <:class_type< $lid:name$ = $expr$ >>
  in
  P4helper.class_types (List.map make clazz_list)

let make_rec_class_expr clazz_list =
  let make (name,abstract,expr) =
    if abstract then
      <:class_expr< virtual $name$ = $expr$ >>
    else
      <:class_expr< $lid:name$ = $expr$ >>
  in
  P4helper.class_exprs (List.map make clazz_list)
