(*	$Id: loc.ml,v 1.1.1.1 2003/10/19 22:57:42 henry Exp $	*)

(* index du caractere de debut et de fin *)
type t = Loc of int * int 
 
let get () =
  Loc (Parsing.symbol_start (), Parsing.symbol_end ())

let rec print_source in_channel (Loc(deb, fin)) =
  let lg = in_channel_length in_channel in
  let rec cherche deb_line pos num_line =
    let lig = input_line in_channel in
    let end_line = deb_line + String.length lig in
    if end_line >= pos then (num_line,deb_line)
    else cherche (end_line+1) pos (num_line+1)
  in
  let num_line,deb_line = (seek_in in_channel 0; cherche 0 deb 1) in
  seek_in in_channel deb_line;
  let line = input_line in_channel in 
  let line_length = String.length line in
  let space_string = String.make (deb-deb_line)  ' '
  and here_string = String.make ((min fin (deb_line+line_length))-deb) '^' in
  Printf.printf "%3d: %s\n" num_line line;
  Printf.printf "     %s%s\n" space_string here_string
       
