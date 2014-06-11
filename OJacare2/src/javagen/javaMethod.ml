(*	$Id: javaMethod.ml,v 1.1.1.1 2003/10/19 22:57:41 henry Exp $	*)

open Cidl
open Format

let get_method_java_id_name name =
  "__mid_"^name

let output_call ppf typ =
  match typ with
    | Cboolean -> fprintf ppf "return "
    | Cchar -> fprintf ppf "return "
    | Cbyte -> fprintf ppf "return "
    | Cshort -> fprintf ppf "return "
    | Cint -> fprintf ppf "return "
    | Ccamlint -> fprintf ppf "return "
    | Clong -> fprintf ppf "return "
    | Cfloat -> fprintf ppf "return "
    | Cdouble -> fprintf ppf "return "
    | Cobject _ -> fprintf ppf "return "
    | Cvoid -> fprintf ppf ""
    | Ccallback _ -> invalid_arg "JavaMethod.output_call"

let output ppf m =
  let ml_name = Ident.get_method_ml_name m.cm_ident
  and java_name = Ident.get_method_java_name m.cm_ident
  and ml_stub_name = Ident.get_method_ml_stub_name m.cm_ident in

  match m.cm_desc with (* TODO CALLBACK*)
    Cmethod (abstract, callback, rtyp, args) ->

      let mid = get_method_java_id_name ml_name in
      
      let largs = List.map2 (fun i t -> "_p"^string_of_int i, t) 
	  (Utilities.interval 0 (List.length args)) args 
      and rtype = rtyp in
      let nargs = List.map (fun (i,t) -> i) largs in
     
      
      (* Entête de méthode oj (cb) *)
      fprintf ppf "  public %a %s(%a) {@." 
	JavaType.output rtype 
	("_oj_"^java_name) 
	JavaArgs.output largs; 
      (* Appel *)
      fprintf ppf "    %a super.%s(%a);@."
	output_call rtype java_name JavaArgs.output_call nargs;
      fprintf ppf "  }@.@."; 

      (* Entête de méthode (super) *)
      fprintf ppf "  public %a %s(%a) {@." 
	JavaType.output rtype java_name
	JavaArgs.output largs; 
      (* Appel *)
      fprintf ppf "    %a cb.%s(%a);@."
	output_call rtype java_name JavaArgs.output_call nargs;
      fprintf ppf "  }@.@."; 

  | _ -> ()
    
let output_signature ppf m =
  let ml_name = Ident.get_method_ml_name m.cm_ident
  and java_name = Ident.get_method_java_name m.cm_ident
  and ml_stub_name = Ident.get_method_ml_stub_name m.cm_ident in

  match m.cm_desc with
    Cmethod (abstract, callback, rtyp, args) ->
      
      let largs = List.map2 (fun i t -> "_p"^string_of_int i, t) 
	  (Utilities.interval 0 (List.length args)) args 
      and rtype = rtyp in
      
      (* Signature de méthode *)
      fprintf ppf "  public %a %s(%a) ;@." 
	JavaType.output rtype 
        java_name
	JavaArgs.output largs


  | _ -> ()
    
