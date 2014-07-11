(*
 * mldvi - A DVI previewer
 * Copyright (C) 2000  Alexandre Miquel
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 *
 * See the GNU Lesser General Public License version 2.1 for more
 * details (enclosed in the file LGPL).
 *)

open Format ;;

module Dev = Grdev ;;
module View = Dviview.Make(Dev) ;;

(*** Parsing command-line arguments ***)

let crop_flag = ref true ;;
let dviname = ref None ;;
let hmargin = ref (View.Cm 1.0) ;;
let vmargin = ref (View.Cm 1.0) ;;
let geometry = ref "864x864" ;;

let set_dim r s =
  r := View.dimen_of_string s ;;

let spec_list = [
  ("-geometry", Arg.String ((:=) geometry),
   "GEOM    sets the (maximum) geometry GEOM") ;
  ("-g", Arg.String ((:=) geometry),
   "GEOM           same as -geometry GEOM") ;
  ("-crop", Arg.Set crop_flag,
   "            crop the window to the best size (default)") ;
  ("-no-crop", Arg.Clear crop_flag,
   "         disable cropping") ;
  ("-hmargin", Arg.String (set_dim hmargin),
   "DIMEN    horizontal margin  (default: 1cm)") ;
  ("-vmargin", Arg.String (set_dim vmargin),
   "DIMEN    vertical margin    (default: 1cm)")
] ;;

let usage_msg =
  Printf.sprintf "usage: %s [OPTIONS] DVIFILE" Sys.argv.(0) ;;

let set_dviname s =
  match !dviname with
  | None -> dviname := Some s
  | Some _ -> () ;;

let standalone_main () =
  Arg.parse spec_list set_dviname usage_msg ;
  let filename = match !dviname with
  | None ->
      eprintf "%s@.Try %s -help for more information@."
	usage_msg Sys.argv.(0) ;
      exit 1
  | Some s -> s in
  View.set_crop !crop_flag ;
  View.set_hmargin !hmargin ;
  View.set_vmargin !vmargin ;
  View.set_geometry !geometry ;
  try View.main_loop filename ; exit 0
  with _ -> exit 1 ;;

let rec interactive_main () =
  Format.printf "Dvi file name: @?" ;
  let filename = input_line stdin in
  if Sys.file_exists filename then begin
    View.set_crop !crop_flag ;
    View.set_hmargin !hmargin ;
    View.set_vmargin !vmargin ;
    View.set_geometry !geometry ;
    View.main_loop filename
  end else begin
    Format.printf "File `%s' does not exists.@." filename ;
    Format.printf "Please make another choice.@." ;
    interactive_main ()
  end ;;

let main =
  if !Sys.interactive
  then interactive_main
  else standalone_main ;;

(main () : unit) ;;
