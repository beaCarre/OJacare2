(*	$Id: javaInit.ml,v 1.1.1.1 2003/10/19 22:57:41 henry Exp $	*)

open Cidl
open Format

let output ppf init =
  let java_name = Ident.get_class_java_stub_name init.cmi_class
  and targs = init.cmi_args in

  let nargs = List.map (fun i -> "_p"^string_of_int i) 
      (Utilities.interval 0 (List.length targs)) in
  let args = List.combine nargs targs in

  fprintf ppf "  public %s(%a) {@." java_name JavaArgs.output (("cb",Ccallback init.cmi_class)::args);

  fprintf ppf "     super(%a);@." JavaArgs.output_call nargs;
  fprintf ppf "     this.cb = cb;@.";

  fprintf ppf "  }@.@." 
