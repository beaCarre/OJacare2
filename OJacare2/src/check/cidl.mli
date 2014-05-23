(*	$Id: cidl.mli,v 1.1.1.1 2003/10/19 22:57:41 henry Exp $	*)

type typ =
  | Cvoid
  | Cboolean (** boolean -> bool *)
  | Cchar (** char -> char *)
  | Cbyte (** byte -> int *)
  | Cshort (** short -> int *)
  | Ccamlint (** int -> int<31> *)
  | Cint (** int -> int32 *)
  | Clong (** long -> int64 *)
  | Cfloat (** float -> float *)
  | Cdouble (** double -> float *)
  | Ccallback of Ident.clazz
  | Cobject of object_type (** object -> ... *)
and object_type = 
  | Cname of Ident.clazz (** ... -> object *)
  | Cstring (** ... -> string *)
  | Cjavaarray of typ (** ... -> t jArray *) 
  | Carray of typ (** ... -> t array *) 
  | Ctop

type clazz = {
    cc_abstract: bool;
    cc_callback: bool;
    cc_ident: Ident.clazz;
    cc_extend: clazz option; (* None = top *)
    cc_implements: clazz list;
    cc_all_inherited: clazz list; (* tout jusque top ... (et avec les interfaces) sauf elle-même. *)

    cc_inits: init list;

    cc_methods: mmethod list; (* méthodes + champs *)
    cc_public_methods: mmethod list; (* méthodes déclarées + celles héritées *)
    cc_static_methods: mmethod list; 
  }

and mmethod_desc = 
  | Cmethod of bool * typ * typ list (* abstract, rtype, args *)
  | Cget of typ
  | Cset of typ

and mmethod = {
    cm_class: Ident.clazz;
    cm_ident: Ident.mmethod; 
    cm_desc: mmethod_desc;
  }
            
and init = {
    cmi_ident: Ident.mmethod;

    cmi_class: Ident.clazz;

    cmi_args: typ list;
  }

type file = clazz list
    
