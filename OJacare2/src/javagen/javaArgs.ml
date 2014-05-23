(*	$Id: javaArgs.ml,v 1.1.1.1 2003/10/19 22:57:41 henry Exp $	*)

open Cidl
open Format

let output_convert ppf args =
  let rec loop ppf args = 
    match args with
    | [arg] -> fprintf ppf "%a" JavaType.output_convert_to_ml arg
    | arg::args -> fprintf ppf "%a, %a " JavaType.output_convert_to_ml arg loop args
    | [] -> ()
  in
  loop ppf args

let output_call ppf nargs =
  let rec loop ppf nargs = 
    match nargs with
    | [narg] -> fprintf ppf "%s" narg
    | narg::nargs -> fprintf ppf "%s, %a " narg loop nargs
    | [] -> ()
  in
  loop ppf nargs
 
    
let output ppf args =
  let rec loop ppf args = match args with 
  | [n,t] -> fprintf ppf "%a %s" JavaType.output t n
  | (n,t)::args -> fprintf ppf "%a %s, %a " JavaType.output t n loop args
  | [] -> ()
  in
  loop ppf args
