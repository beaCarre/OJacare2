(*	$Id: modifiers.ml,v 1.2 2004/03/27 16:31:47 henry Exp $	*)

open Idl

let rec is_abstract l = match l with
  [] -> false
| e::l -> e.mo_desc = Iabstract or is_abstract l

let rec is_final l = match l with
  [] -> false
| e::l -> e.mo_desc = Ifinal or is_final l

let rec is_static l = match l with
  [] -> false
| e::l -> e.mo_desc = Istatic or is_static l
