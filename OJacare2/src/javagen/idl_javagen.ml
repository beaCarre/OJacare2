(*	$Id: idl_javagen.ml,v 1.1.1.1 2003/10/19 22:57:41 henry Exp $	*)

open Cidl
open Format
open Ident


let create_stub_files file =
  List.iter (fun clazz -> if (clazz.cc_callback || (Method.have_callback clazz.cc_public_methods)) && not(is_interface clazz.cc_ident) then
      begin
	JavaClass.create_stub_file clazz ;
	JavaInterface.create_stub_file clazz
      end
  ) file

    
