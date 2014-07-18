(*	$Id: type.ml,v 1.1.1.1 2003/10/19 22:57:41 henry Exp $	*)

open Idl
open Cidl
open Error


let rec convert env_idl camlarray t  =
  match t.t_desc with
    Ivoid -> Cvoid
  | Iboolean -> Cboolean
  | Ibyte -> Cbyte
  | Ishort -> Cshort
  | Icamlint -> Ccamlint
  | Iint -> Cint
  | Ilong -> Clong
  | Ifloat -> Cfloat
  | Idouble -> Cdouble
  | Ichar -> Cchar
  | Istring -> Cobject Cstring
  | Iarray t -> 
      if camlarray then
	Cobject (Carray (convert env_idl camlarray t))
      else
	Cobject (Cjavaarray (convert env_idl camlarray t))
  | Iobject name ->
      let id = 
	try Env_idl.find_class env_idl name
	with 
	| Not_found -> raise (Error (Eclass_unbound name))
      in Cobject (Cname id)
  | Itop -> Cobject Ctop
	
let convert_args env_idl args = 
  List.map (fun arg -> convert env_idl (Annot.have_array arg.arg_annot) arg.arg_type) args
  
