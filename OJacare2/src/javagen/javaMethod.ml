(*	$Id: javaMethod.ml,v 1.1.1.1 2003/10/19 22:57:41 henry Exp $	*)

open Cidl
open Format

let get_method_java_id_name name =
  "__mid_"^name

let output_call ppf typ =
  match typ with
    | Cboolean -> fprintf ppf "return cb.callBoolean"
    | Cchar -> fprintf ppf "return cb.callChar"
    | Cbyte -> fprintf ppf "return cb.callByte"
    | Cshort -> fprintf ppf "return cb.callShort"
    | Cint -> fprintf ppf "return cb.callInt"
    | Ccamlint -> fprintf ppf "return cb.callCamlint"
    | Clong -> fprintf ppf "return cb.callLong"
    | Cfloat -> fprintf ppf "return cb.callFloat"
    | Cdouble -> fprintf ppf "return cb.callDouble"
    | Cobject _ as typ -> fprintf ppf "return (%a) cb.callObject" JavaType.output typ
    | Cvoid -> fprintf ppf "cb.callVoid"
    | Ccallback _ -> invalid_arg "JavaMethod.output_call"

let output ppf m =
  let ml_name = Ident.get_method_ml_name m.cm_ident
  and java_name = Ident.get_method_java_name m.cm_ident
  and ml_stub_name = Ident.get_method_ml_stub_name m.cm_ident in

  match m.cm_desc with
    Cmethod (abstract, rtyp, args) ->

      let mid = get_method_java_id_name ml_name in
      
      let args = List.map2 (fun i t -> "_p"^string_of_int i, t) 
	  (Utilities.interval 0 (List.length args)) args 
      and rtype = rtyp in

      (* Récupération de l'id de méthode *)
      fprintf ppf "  private static long %s = Callback.getCamlMethodID(\"%s\");@." mid ml_stub_name;
      
      (* Entête de méthode *)
      fprintf ppf "  public %a %s(%a) {@." 
	JavaType.output rtype 
	java_name 
	JavaArgs.output args; 

      (* Préparation des arguments *) 
      fprintf ppf "    Object [] args = {%a};@." JavaArgs.output_convert args;
      
      (* Appel *)
      fprintf ppf "    %a(%s,args);@."
	output_call rtype
	mid;
      
      fprintf ppf "  }@.@."
  | _ -> ()
    
