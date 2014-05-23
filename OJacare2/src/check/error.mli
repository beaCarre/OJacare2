(*	$Id: error.mli,v 1.2 2004/03/11 20:22:59 henry Exp $	*)

type t = 
  | Eclass_double_def of (string list * Idl.ident)
  | Eclass_unbound of Idl.qident
  | Eclass_super_unbound of Idl.qident
  | Eclass_implements_unbound of Idl.qident
  | Eclass_abstract of Idl.ident
  | Einterface_unbound of Idl.qident
  | Einterface_implements_unbound of Idl.qident
  | Emethod_capitalized of Idl.ident
  | Emethod_ml_overloading of string * Loc.t
  | Emethod_staticabstract of Loc.t
  | Einit_ml_overloading of Idl.ident
  | Efield_staticabstract of Loc.t

type w =
  | Wstatic_ml_overloading of Idl.ident
  | Winherited_method_hidding of string * Loc.t

exception Error of t
val explain : t -> Loc.t option
val warn : w -> unit
