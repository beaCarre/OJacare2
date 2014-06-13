(*	$Id: javaClass.ml,v 1.2 2003/10/22 17:54:11 henry Exp $	*)

open Cidl
open Format

let output ppf clazz = 
  let package = Ident.get_class_java_callback_package_name clazz.cc_ident
  and java_stubname = Ident.get_class_java_stub_name clazz.cc_ident
  and java_name = Ident.get_class_java_qualified_name clazz.cc_ident
  in
  let java_cb_name = ("CB_"^java_stubname)
  and java_icb_name = ("ICB_"^java_stubname)
  in

  fprintf ppf "package %s;@." package;

 (* if Ident.is_interface clazz.cc_ident then
    fprintf ppf "public class %s implements %s {@.@." java_stubname java_name
  else*) begin
    let abstract = clazz.cc_abstract in
    fprintf ppf "%sclass %s extends %s {@.@." (if abstract then "public abstract " else "public ") java_cb_name java_name
  end;

(* fprintf ppf "  protected void finalize() throws Throwable {@.";
   fprintf ppf "    System.out.println(\"finalize : %s \");@." java_stubname; 
   fprintf ppf "  }@."; *)

  fprintf ppf "  private %s cb;@." java_icb_name;

 (* if Ident.is_interface clazz.cc_ident then begin
    fprintf ppf "  public %s(%a) {@." (Ident.get_class_java_name clazz.cc_ident) JavaArgs.output [("cb",Ccallback clazz.cc_ident)];

    fprintf ppf "     this.cb = cb;@.";

    fprintf ppf "  }@.@."
  end else*)
    
    List.iter (JavaInit.output ppf) clazz.cc_inits;
  List.iter (JavaMethod.output ppf) clazz.cc_public_methods;

  fprintf ppf "}@."

let create_stub_file clazz = 
  let package = Ident.get_class_java_callback_package clazz.cc_ident
  and name = Ident.get_class_java_stub_name clazz.cc_ident in
  let outchan = Filesystem.safe_open_out package ("CB_"^name^".java") in
  let ppf = formatter_of_out_channel outchan in
  output ppf clazz;
  fprintf ppf "@.";
  close_out outchan
