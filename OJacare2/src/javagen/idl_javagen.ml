(*	$Id: idl_javagen.ml,v 1.1.1.1 2003/10/19 22:57:41 henry Exp $	*)

open Cidl
open Format

let create_stub_files file =
  List.iter (fun clazz -> if clazz.cc_callback then JavaClass.create_stub_file clazz) file
