(*	$Id: ojacare.ml,v 1.2 2004/03/27 16:37:53 henry Exp $	*)

let main () =
  if Array.length Sys.argv < 2 then begin
    Printf.eprintf "Usage: %s file.idl\n" Sys.argv.(0);
    exit 1
  end;

  let file = Sys.argv.(1) in
  if not (Filename.check_suffix file ".idl") then begin
    Printf.eprintf "Je ne sais pas quoi faire du fichier : %s.\n" file;
    Printf.eprintf "Usage: %s file.idl\n" Sys.argv.(0);
    exit 1
  end;
    
  let p_file  = Idl_parser.from_file file in
  let c_file = Idl_check.main file p_file in
  Idl_javagen.create_stub_files c_file;
  let out = Unix.openfile ((Filename.chop_suffix file ".idl") ^ ".ml") [Unix.O_WRONLY;Unix.O_CREAT;Unix.O_TRUNC] 0o644 in
  Unix.dup2 out Unix.stdout;
  Idl_camlgen.output c_file;
  Unix.close out;
  let out = Unix.openfile ((Filename.chop_suffix file ".idl") ^ ".mli") [Unix.O_WRONLY;Unix.O_CREAT;Unix.O_TRUNC] 0o644 in
  Unix.dup2 out Unix.stdout;
  Idl_camlgen.output_sig c_file;
  Unix.close out

let _ = main ()
