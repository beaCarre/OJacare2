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

let kpsewhich_path = "kpsewhich" ;;
let temp_filename = Filename.temp_file "mldvi" "" ;;
at_exit (fun () -> try Sys.remove temp_filename with _ -> ()) ;;

let kpsewhich_font_path fontname dpi =
  let exit_status =
    Sys.command
      (Printf.sprintf "%s -dpi=%d -mktex=pk %s.pk > %s"
	 kpsewhich_path dpi fontname temp_filename) in
  if exit_status <> 0 then begin
    Format.eprintf "Error while executing %s@." kpsewhich_path ;
    raise Not_found
  end ;
  let ch =
    try open_in temp_filename
    with _ -> raise Not_found in
  let filename =
    try input_line ch
    with _ ->
      close_in ch ;
      raise Not_found in
  close_in ch ;
  if filename <> ""
  then filename
  else raise Not_found ;;

let msdos_font_path fontname dpi =
  let filename = Printf.sprintf "%s.%dpk" fontname dpi in
  try (Filename.concat (Sys.getenv "PKFONTS") filename)
  with _ -> filename ;;
  
let font_path =
  match Sys.os_type with
  | "Unix" -> kpsewhich_font_path
  | "Win32" -> msdos_font_path
  | _ -> raise Not_found ;;
