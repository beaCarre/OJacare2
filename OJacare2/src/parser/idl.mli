(*	$Id: idl.mli,v 1.1.1.1 2003/10/19 22:57:42 henry Exp $	*)

(** Arbre de syntaxe abstraite pour l'IDL *)

type ident = {
    id_location: Loc.t;
    id_desc: string 
  }

type qident = {
    qid_location: Loc.t;
    qid_package: string list;
    qid_name: ident;
  }

type type_desc = 
    Ivoid  
  | Iboolean
  | Ibyte
  | Ishort
  | Icamlint
  | Iint
  | Ilong
  | Ifloat
  | Idouble
  | Ichar
  | Istring
  | Itop
  | Iarray of typ
  | Iobject of qident
and typ = {
    t_location: Loc.t;
    t_desc: type_desc;
  }

type modifier_desc = Ifinal | Istatic | Iabstract
and modifier = {
    mo_location: Loc.t; 
    mo_desc: modifier_desc;
}

type ann_desc =
  | Iname of ident
  | Icallback
  | Icamlarray
and annotation = {
    an_location: Loc.t; 
    an_desc: ann_desc;
}

type arg = {
    arg_location: Loc.t; 
    arg_annot: annotation list;
    arg_type: typ
  }
      
type init = {
    i_location: Loc.t;
    i_annot: annotation list; 
    i_args: arg list;
  }
      
      
type field = {
    f_location: Loc.t;
    f_annot: annotation list; 
    f_modifiers: modifier list;
    f_name: ident;
    f_type: typ
  }
 
type mmethod = { 
    m_location: Loc.t;
    m_annot: annotation list;
    m_modifiers: modifier list;
    m_name: ident;
    m_return_type: typ;
    m_args: arg list
  }

type content = Method of mmethod | Field of field

type def = {
    d_location: Loc.t;
    d_super: qident option;
    d_implements: qident list;
    d_annot: annotation list;
    d_interface: bool;
    d_modifiers: modifier list;
    d_name: ident;
    d_inits: init list;
    d_contents: content list;
  }

type package = {
    p_name: string list;
    p_defs: def list;
  }
      
type file = package list
