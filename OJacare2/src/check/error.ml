(*	$Id: error.ml,v 1.2 2004/03/11 20:22:59 henry Exp $	*)

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

let string_of_qname qname =
  String.concat "." (List.rev (qname.Idl.qid_name.Idl.id_desc :: qname.Idl.qid_package))

let explain err =
  match err with 
  | Eclass_double_def (package,name) -> 
      Printf.eprintf "La classe \"%s\" a déjà été définie.\n"  (String.concat "." (List.rev (name.Idl.id_desc :: package)));
      Some name.Idl.id_location
  | Eclass_unbound qname -> 
      Printf.eprintf "La classe \"%s\" n'est pas définie.\n" (string_of_qname qname);
      Some qname.Idl.qid_location
  | Eclass_super_unbound qname -> 
      Printf.eprintf "La classe \"%s\" doit être définie avant celle qui en héritent.\n" (string_of_qname qname);
      Some qname.Idl.qid_location
  | Eclass_implements_unbound qname -> 
      Printf.eprintf "L'interface \"%s\" doit être définie avant les classes qui l'implémentent.\n" (string_of_qname qname);
      Some qname.Idl.qid_location
  | Eclass_abstract name ->
      Printf.eprintf "La classe \"%s\" doit être définie abstraite car l'une de ces méthodes est abstraite.\n" name.Idl.id_desc;
      Some name.Idl.id_location
  | Einterface_unbound qname -> 
      Printf.eprintf "L'interface \"%s\" n'est pas définie.\n" (string_of_qname qname);
      Some qname.Idl.qid_location
  | Einterface_implements_unbound qname -> 
      Printf.eprintf "L'interface \"%s\" doit être définie avant celle qui l'implémentent.\n" (string_of_qname qname);
      Some qname.Idl.qid_location
  | Emethod_capitalized name -> 
      Printf.eprintf "Une méthode OCaml ne peut pas commencer par une majuscule : \"%s\".\n" name.Idl.id_desc;
      Printf.eprintf "-> Peut-être devriez-vous utiliser un (autre) alias de nom ?\n";
      Some name.Idl.id_location
  | Emethod_ml_overloading (name,loc) -> 
      Printf.eprintf "Une méthode OCaml ne peut pas être surchargé : \"%s\".\n" name;
      Some loc
  | Einit_ml_overloading name -> 
      Printf.eprintf "Une méthode d'initialisation ne peut pas être surchargé : \"%s\".\n" name.Idl.id_desc;
      Printf.eprintf "-> Peut-être devriez-vous utiliser un (autre) alias de nom ?\n";
      Some name.Idl.id_location
  | Emethod_staticabstract loc -> 
      Printf.eprintf "Une méthode ne peut pas être déclaré à la fois statique et abstraite.\n";
      Printf.eprintf "-> En effet cet idl ne défini pas l'héritage des méthodes statiques.\n";
      Some loc
  | Efield_staticabstract loc -> 
      Printf.eprintf "Un champs ne peut pas être déclaré à la fois statique et abstraite.\n";
      Printf.eprintf "-> En effet cet idl ne défini pas l'héritage des champs statiques.\n";
      Some loc

let explain_warn w = match w with
    | Wstatic_ml_overloading name ->
      Printf.eprintf "Attention, vous définissez deux méthodes static portant le même nom : %s.\n"  name.Idl.id_desc; 
      Printf.eprintf "-> Peut-être devriez-vous utiliser un (autre) alias de nom ?\n"
    | Winherited_method_hidding (name,loc) ->
      Printf.eprintf "Attention, vous masquez une méthode héritée : %s.\n" name	
let warn err =
  explain_warn err
