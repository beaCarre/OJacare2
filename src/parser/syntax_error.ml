(*	$Id: syntax_error.ml,v 1.1.1.1 2003/10/19 22:57:42 henry Exp $	*)

open Idl

type t =
  | Eclass_modifiers of Idl.modifier (** 'modifier' de classe incorrect *)
  | Einterface_modifiers of Idl.modifier (** 'modifier' d'interface incorrect *)
  | Efield_modifiers of Idl.modifier (** 'modifier' de champ de classe incorrect *)
  | Emethod_modifiers of Idl.modifier (** 'modifier' de m�thode de classe incorrect *)
  | Einterfacemethod_modifiers of Idl.modifier (** 'modifier' de m�thode d'interface incorrect *)
  | Einterfacefield_modifiers of Idl.modifier (** 'modifier' de champs d'interface incorrect *)
  | Enoinit of Idl.init (** pas de fonction d'initialisation dans une interface *)
  | Einit_no_alias of Loc.t (** une interface ne contient pas de constructeurs *)

exception Syntax_error of t

let print_modifier oc m =
  match m.mo_desc with
    Istatic -> Printf.fprintf oc "static"
  | Ifinal -> Printf.fprintf oc "final"
  | Iabstract ->Printf.fprintf oc "abstract"

let print_list print sep oc l =
    let rec aux oc l = 
      match l with
	[] -> ()
      | [t] ->  print oc t
      | t::l -> print oc t; output_string oc sep;aux oc l 
    in 
    aux oc l

let print_modifiers = print_list print_modifier ", "

let explain err =
  match err with 
    Efield_modifiers m ->
      Printf.eprintf "Un champ ne peut �tre d�clar� : \"%a\".\n" print_modifier m; Some m.mo_location
  | Emethod_modifiers m -> 
      Printf.eprintf "Une m�thode ne peut �tre d�clar�e : \"%a\".\n" print_modifier m; Some m.mo_location
  | Eclass_modifiers m -> 
      Printf.eprintf "Une classe ne peut �tre d�clar�e : \"%a\".\n" print_modifier m; Some m.mo_location
  | Einterface_modifiers m -> 
      Printf.eprintf "Une interface ne peut �tre d�clar�e : \"%a\".\n" print_modifier m; Some m.mo_location
  | Einterfacefield_modifiers m -> 
      Printf.eprintf "Un champ d'une interface ne peut �tre d�clar� : \"%a\".\n" print_modifier m; Some m.mo_location
  | Einterfacemethod_modifiers m -> 
      Printf.eprintf "Une methode d'une interface ne peut �tre d�clar�e : \"%a\".\n" print_modifier m; Some m.mo_location
  | Enoinit i ->
      Printf.eprintf "Une interface ne peut pas d�clar�e de fonction d'initialisation.\n"; Some i.i_location
  | Einit_no_alias i ->
      Printf.eprintf "Un initialiseur doit poseder un alias de nom.\n"; Some i
