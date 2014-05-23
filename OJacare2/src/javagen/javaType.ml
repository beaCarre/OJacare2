(*	$Id: javaType.ml,v 1.2 2004/03/09 00:49:21 henry Exp $	*)

open Cidl
open Format

let rec output ppf typ =
  match typ with
  | Cboolean -> fprintf ppf "boolean"
  | Cchar -> fprintf ppf "char"
  | Cbyte -> fprintf ppf "byte"
  | Cshort -> fprintf ppf "short"
  | Cint -> fprintf ppf "int"
  | Ccamlint -> fprintf ppf "int"
  | Clong -> fprintf ppf "long"
  | Cfloat -> fprintf ppf "float"
  | Cdouble -> fprintf ppf "double"
  | Cobject Ctop -> fprintf ppf "Object"
  | Cobject Cstring -> fprintf ppf "String"
  | Cobject (Cname id) -> fprintf ppf "%s" (Ident.get_class_java_qualified_name id)
  | Cobject (Cjavaarray typ) -> fprintf ppf "%a[]" output typ
  | Cobject (Carray typ) -> fprintf ppf "%a[]" output typ
  | Cvoid -> fprintf ppf "void"
  | Ccallback _ -> fprintf ppf "fr.inria.caml.camljava.Callback"
 
let output_convert_to_ml ppf (name,typ) =
  match typ with
  | Cboolean -> fprintf ppf "new fr.inria.caml.camljava.Boolean(%s)" name
  | Cchar -> fprintf ppf "new fr.inria.caml.camljava.Char(%s)" name
  | Cbyte -> fprintf ppf "new fr.inria.caml.camljava.Byte(%s)" name
  | Cshort -> fprintf ppf "new fr.inria.caml.camljava.Short(%s)" name
  | Cint -> fprintf ppf "new fr.inria.caml.camljava.Int(%s)" name
  | Ccamlint -> fprintf ppf "new fr.inria.caml.camljava.Camlint(%s)" name
  | Clong -> fprintf ppf "new fr.inria.caml.camljava.Long(%s)" name
  | Cfloat -> fprintf ppf "new fr.inria.caml.camljava.Float(%s)" name
  | Cdouble -> fprintf ppf "new fr.inria.caml.camljava.Double(%s)" name
  | Cobject _ -> fprintf ppf "%s" name
  | Cvoid -> invalid_arg "JavaType.output_convert_from_ml Cvoid"
  | Ccallback _ -> invalid_arg "JavaType.output_convert_from_ml Ccallback"
