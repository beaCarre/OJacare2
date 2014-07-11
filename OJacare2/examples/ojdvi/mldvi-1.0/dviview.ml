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

(****************)
(*  Signatures  *)
(****************)

module type DEVICE = sig
  type glyph

  val make_glyph : Glyph.t -> glyph

  val open_dev : string -> unit
  val close_dev : unit -> unit
  val clear_dev : unit -> unit
  val set_bbox : (int * int * int * int) option -> unit

  type color = int

  val set_color : int -> unit
  val draw_glyph : glyph -> int -> int -> unit
  val fill_rect : int -> int -> int -> int -> unit

  type status = {
      mouse_x : int ;
      mouse_y : int ;
      button : bool ;
      keypressed : bool ;
      key : char
    }

  type event =
    | Button_down
    | Button_up
    | Key_pressed
    | Mouse_motion
    | Poll

  val wait_next_event : event list -> status
end ;;

module type DVIVIEW = sig
  type dimen =
    | Px of int
    | Pt of float
    | Pc of float
    | In of float
    | Bp of float
    | Cm of float
    | Mm of float
    | Dd of float
    | Cc of float
    | Sp of int

  val dimen_of_string : string -> dimen

  val set_geometry : string -> unit
  val set_crop : bool -> unit
  val set_hmargin : dimen -> unit
  val set_vmargin : dimen -> unit

  val main_loop : string -> unit
end ;;

module Make(Dev : DEVICE) = struct

  module Drv = Driver.Make(Dev)

  exception Error of string

  type dimen =
    | Px of int
    | Pt of float
    | Pc of float
    | In of float
    | Bp of float
    | Cm of float
    | Mm of float
    | Dd of float
    | Cc of float
    | Sp of int

  let is_digit c = (c >= '0' && c <= '9')

  let dimen_of_string str =
    let len = String.length str in
    let i = ref 0 in
    while !i < len && is_digit str.[!i] do incr i done ;
    if !i < len && str.[!i] = '.' then begin
      incr i ;
      while !i < len && is_digit str.[!i] do incr i done
    end ;
    let (pref, suff) =
      (String.sub str 0 !i, String.sub str !i (len - !i)) in
    let f = float_of_string pref in
    match suff with
    | "" -> Px (int_of_float f)
    | "pt" -> Pt f
    | "pc" -> Pc f
    | "in" -> In f
    | "bp" -> Bp f
    | "cm" -> Cm f
    | "mm" -> Mm f
    | "dd" -> Dd f
    | "cc" -> Cc f
    | "sp" -> Sp (int_of_float f)
    | _ -> invalid_arg (Printf.sprintf "unknown unit `%s'" suff)

  let normalize = function
    | Px n -> Px n
    | Pt f -> In (Units.from_to Units.PT Units.IN f)
    | Pc f -> In (Units.from_to Units.PC Units.IN f)
    | In f -> In f
    | Bp f -> In (Units.from_to Units.BP Units.IN f)
    | Cm f -> In (Units.from_to Units.CM Units.IN f)
    | Mm f -> In (Units.from_to Units.MM Units.IN f)
    | Dd f -> In (Units.from_to Units.DD Units.IN f)
    | Cc f -> In (Units.from_to Units.CC Units.IN f)
    | Sp n -> In (Units.from_to Units.SP Units.IN (float n))

  (*** View attributes ***)

  (* things we can set before initialization *)

  type offset =
    | No_offset
    | Plus of int
    | Minus of int

  type geometry = {
      mutable width : int ;
      mutable height : int ;
      mutable xoffset : offset ;
      mutable yoffset : offset
    }

  type attr = {
      geom : geometry ;
      mutable crop : bool ;
      mutable hmargin : dimen ;
      mutable vmargin : dimen
    }

  let attr =
    { geom =
      { width = 0 ;
	height = 0 ;
	xoffset = No_offset ;
	yoffset = No_offset } ;
      crop = false ;
      hmargin = Px 0 ;
      vmargin = Px 0
    }

  let string_of_geometry geom =
    let w = geom.width
    and h = geom.height
    and xoff = geom.xoffset
    and yoff = geom.yoffset in
    match (xoff, yoff) with
    | (No_offset, No_offset) -> Printf.sprintf "%dx%d" w h
    | (Plus x, No_offset) -> Printf.sprintf "%dx%d+%d" w h x
    | (Minus x, No_offset) -> Printf.sprintf "%dx%d-%d" w h x
    | (No_offset, Plus y) -> Printf.sprintf "%dx%d++%d" w h y
    | (No_offset, Minus y) -> Printf.sprintf "%dx%d+-%d" w h y
    | (Plus x, Plus y) -> Printf.sprintf "%dx%d+%d+%d" w h x y
    | (Plus x, Minus y) -> Printf.sprintf "%dx%d+%d-%d" w h x y
    | (Minus x, Plus y) -> Printf.sprintf "%dx%d-%d+%d" w h x y
    | (Minus x, Minus y) -> Printf.sprintf "%dx%d-%d-%d" w h x y

  (*** The view state ***)

  type state = {
      (* DVI attributes *)
      filename : string ;
      mutable dvi : Dvi.t ;
      mutable cdvi : Drv.cooked_dvi ;
      mutable num_pages : int ;
      (* Page layout *)
      mutable base_dpi : float ;
      mutable dvi_width : int ;   (* in pixels *)
      mutable dvi_height : int ;  (* in pixels *)
      (* Window size *)
      mutable size_x : int ;
      mutable size_y : int ;
      (* Current parameters *)
      mutable orig_x : int ;
      mutable orig_y : int ;
      mutable ratio : float ;
      mutable page_no : int ;
      mutable last_modified : float ;
      mutable button : (int * int) option
    }

  let state = ref None

  (*** Setting the geometry ***)

  let set_geometry str =
    let len = String.length str
    and i = ref 0 in
    let parse_int () =
      if !i = len || not (is_digit str.[!i]) then
	invalid_arg "set_geometry" ;
      let start = !i in
      while !i < len && is_digit str.[!i] do incr i done ;
      let stop = !i in
      int_of_string (String.sub str start (stop - start)) in
    let parse_offset () =
      if !i = len || (str.[!i] <> '+' && str.[!i] <> '-') then
	No_offset
      else begin
	let sgn = str.[!i] in
	incr i ;
	if !i = len || not (is_digit str.[!i]) then
	  No_offset
	else
	  match sgn with
	  | '+' -> Plus (parse_int ())
	  | '-' -> Minus (parse_int ())
	  | _ -> assert false
      end in
    while !i < len && str.[!i] = ' ' do incr i done ;
    let width = parse_int () in
    if !i = len || (str.[!i] <> 'x' && str.[!i] <> 'X') then
      invalid_arg "set_geometry" ;
    incr i ;
    let height = parse_int () in
    let xoffset = parse_offset () in
    let yoffset = parse_offset () in
    attr.geom.width <- width ;
    attr.geom.height <- height ;
    attr.geom.xoffset <- xoffset ;
    attr.geom.yoffset <- yoffset

  (*** Setting other parameters ***)

  let set_crop b =
    attr.crop <- b

  let set_hmargin d =
    attr.hmargin <- normalize d

  let set_vmargin d =
    attr.vmargin <- normalize d

  (*** Initialization ***)

  let init filename =
    let dvi =
      try Dvi.load filename
      with
      |	Sys_error _ -> raise (Error ("cannot open `" ^ filename ^ "'"))
      |	Dvi.Error s -> raise (Error (filename ^ ": " ^ s))
      |	_ -> raise (Error ("error while loading `" ^ filename ^ "'")) in
    let cdvi = Drv.cook_dvi dvi
    and dvi_res = 72.27
    and mag = float dvi.Dvi.preamble.Dvi.pre_mag /. 1000.0 in
    let w_sp = dvi.Dvi.postamble.Dvi.post_width
    and h_sp = dvi.Dvi.postamble.Dvi.post_height in
    let w_in = mag *. ldexp (float w_sp /. dvi_res) (-16)
    and h_in = mag *. ldexp (float h_sp /. dvi_res) (-16) in
    let wdpi =
      match attr.hmargin with
      | Px n -> float (attr.geom.width - 2 * n) /. w_in
      | In f -> float attr.geom.width /. (w_in +. 2.0 *. f)
      | _ -> assert false
    and hdpi =
      match attr.vmargin with
      | Px n -> float (attr.geom.height - 2 * n) /. h_in
      | In f -> float attr.geom.height /. (h_in +. 2.0 *. f)
      | _ -> assert false in
    let base_dpi = min wdpi hdpi in
    let width = int_of_float (base_dpi *. w_in)
    and height = int_of_float (base_dpi *. h_in) in
    let (size_x, size_y) =
      if attr.crop then begin
	let sx = match attr.hmargin with
	| Px n -> width + 2 * n
	| In f -> width + int_of_float (base_dpi *. 2.0 *. f)
	| _ -> assert false
	and sy = match attr.vmargin with
	| Px n -> height + 2 * n
	| In f -> height + int_of_float (base_dpi *. 2.0 *. f)
	| _ -> assert false in
	(min attr.geom.width sx, min attr.geom.height sy)
      end else
	(attr.geom.width, attr.geom.height) in
    attr.geom.width <- size_x ;
    attr.geom.height <- size_y ;
    let orig_x = (size_x - width)/2
    and orig_y = (size_y - height)/2 in
    let last_modified =
      try (Unix.stat filename).Unix.st_mtime
      with _ -> 0.0 in
    { filename = filename ;
      dvi = dvi ;
      cdvi = cdvi ;
      num_pages = Array.length dvi.Dvi.pages ;
      base_dpi = base_dpi ;
      dvi_width = width ;
      dvi_height = height ;
      size_x = size_x ;
      size_y = size_y ;
      orig_x = orig_x ;
      orig_y = orig_y ;
      ratio = 1.0 ;
      page_no = 0 ;
      last_modified = last_modified ;
      button = None }

  let redraw st =
    Dev.clear_dev () ;
    Dev.set_color 0xcccccc ;
    Dev.fill_rect st.orig_x st.orig_y st.dvi_width 1 ;
    Dev.fill_rect st.orig_x st.orig_y 1 st.dvi_height ;
    Dev.fill_rect st.orig_x (st.orig_y + st.dvi_height) st.dvi_width 1 ;
    Dev.fill_rect (st.orig_x + st.dvi_width) st.orig_y 1 st.dvi_height ;
    Drv.render_page st.cdvi st.page_no
      (st.base_dpi *. st.ratio) st.orig_x st.orig_y

  let update_dvi_size st =
    let dvi_res = 72.27
    and mag = float st.dvi.Dvi.preamble.Dvi.pre_mag /. 1000.0
    and w_sp = st.dvi.Dvi.postamble.Dvi.post_width
    and h_sp = st.dvi.Dvi.postamble.Dvi.post_height in
    let w_in = mag *. ldexp (float w_sp /. dvi_res) (-16)
    and h_in = mag *. ldexp (float h_sp /. dvi_res) (-16) in
    st.dvi_width <- int_of_float (st.ratio *. w_in *. st.base_dpi) ;
    st.dvi_height <- int_of_float (st.ratio *. h_in *. st.base_dpi)

  let center st =
    st.ratio <- 1.0 ;
    update_dvi_size st ;
    st.orig_x <- (st.size_x - st.dvi_width)/2 ;
    st.orig_y <- (st.size_y - st.dvi_height)/2 ;
    redraw st

  let reload st =
    try
      let dvi = Dvi.load st.filename in
      let cdvi = Drv.cook_dvi dvi in
      let dvi_res = 72.27
      and mag = float dvi.Dvi.preamble.Dvi.pre_mag /. 1000.0 in
      let w_sp = dvi.Dvi.postamble.Dvi.post_width
      and h_sp = dvi.Dvi.postamble.Dvi.post_height in
      let w_in = mag *. ldexp (float w_sp /. dvi_res) (-16)
      and h_in = mag *. ldexp (float h_sp /. dvi_res) (-16) in
      let width = int_of_float (w_in *. st.base_dpi *. st.ratio)
      and height = int_of_float (h_in *. st.base_dpi *. st.ratio) in
      st.dvi <- dvi ;
      st.cdvi <- cdvi ;
      st.num_pages <- Array.length dvi.Dvi.pages ;
      st.page_no <- min st.page_no (st.num_pages - 1) ;
      update_dvi_size st ;
      redraw st
    with _ -> ()

  let reload_if_changed st =
    try
      let s = Unix.stat st.filename in
      if s.Unix.st_mtime > st.last_modified then begin
	st.last_modified <- s.Unix.st_mtime ;
	reload st
      end
    with _ -> ()

  let goto_page st n =
    let new_page_no = max 0 (min n (st.num_pages - 1)) in
    if st.page_no <> new_page_no then begin
      st.page_no <- new_page_no ;
      redraw st
    end

  let scale_by st factor =
    let new_ratio = factor *. st.ratio in
    if new_ratio >= 0.1 && new_ratio < 10.0 then begin
      st.ratio <- new_ratio ;
      let (cx, cy) = (st.size_x/2, st.size_y/2) in
      st.orig_x <- int_of_float (float (st.orig_x - cx) *. factor) + cx ;
      st.orig_y <- int_of_float (float (st.orig_y - cy) *. factor) + cy ;
      update_dvi_size st ;
      redraw st
    end

  let main_loop filename =
    let st = init filename in
    Dev.open_dev (Printf.sprintf " " ^ string_of_geometry attr.geom) ;
    redraw st ;
    let flags = [
      Dev.Button_down ;
      Dev.Button_up ;
      Dev.Key_pressed ;
      Dev.Mouse_motion
    ] in
    let num = ref 0 in
    try while true do
      let ev = Dev.wait_next_event flags in
      reload_if_changed st ;
      if ev.Dev.keypressed then begin
	match ev.Dev.key with
	| '0'..'9' as c -> num := !num * 10 + Char.code c - Char.code '0'
	| 'n' -> goto_page st (st.page_no + max 1 !num) ; num := 0
	| 'p' -> goto_page st (st.page_no - max 1 !num) ; num := 0
	| 'f' -> Drv.unfreeze_fonts st.cdvi
	| 'F' -> Drv.unfreeze_glyphs st.cdvi (st.base_dpi *. st.ratio)
	| 'r' -> reload st
	| 'c' -> center st
	| '<' -> scale_by st (1.0/.sqrt(2.0))
	| '>' -> scale_by st (sqrt(2.0))
	| 'g' -> if !num > 0 then goto_page st (!num - 1) ; num := 0
	| 'q' -> raise Exit
	| _ -> ()
      end ;
      let mx = ev.Dev.mouse_x
      and my = ev.Dev.mouse_y in
      if ev.Dev.button then begin
	match st.button with
	| None ->
	    st.button <- Some(mx, my)
	| Some(ox, oy) ->
	    st.orig_x <- st.orig_x + (mx - ox) ;
	    st.orig_y <- st.orig_y + (my - oy) ;
	    st.button <- Some(mx, my)
      end else begin
	match st.button with
	| None -> ()
	| Some(ox, oy) ->
	    st.orig_x <- st.orig_x + (mx - ox) ;
	    st.orig_y <- st.orig_y + (my - oy) ;
	    st.button <- None ;
	    redraw st
      end
    done with Exit -> Dev.close_dev ()

end ;;
