(*	$Id: syntax_error.mli,v 1.1.1.1 2003/10/19 22:57:42 henry Exp $	*)

(** Gestion des erreurs de syntaxe *)

type t =
  | Eclass_modifiers of Idl.modifier (** mauvais modifiers pour une classe *)
  | Einterface_modifiers of Idl.modifier (** mauvais modifiers pour une insterface *)

  | Efield_modifiers of Idl.modifier (** mauvais modifiers pour un champs d'une classe *)
  | Emethod_modifiers of Idl.modifier (** mauvais modifiers pour une méthode d'une classe *)

  | Einterfacemethod_modifiers of Idl.modifier (** mauvais modifiers pour un champs d'une interface *)
  | Einterfacefield_modifiers of Idl.modifier (** mauvais modifiers pour un champs d'une interface *)

  | Enoinit of Idl.init (** une interface ne contient pas de constructeurs *)
  | Einit_no_alias of Loc.t (** une interface ne contient pas de constructeurs *)
(** Type des erreurs de syntaxe. *)

exception Syntax_error of t

val explain : t -> Loc.t option
