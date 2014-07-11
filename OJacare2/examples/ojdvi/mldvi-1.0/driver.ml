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
  type color = int
  type glyph
  val make_glyph : Glyph.t -> glyph
  val set_color : int -> unit
  val draw_glyph : glyph -> int -> int -> unit
  val fill_rect : int -> int -> int -> int -> unit
end ;;

module type DRIVER = sig
  type cooked_dvi
  val cook_dvi : Dvi.t -> cooked_dvi
  val render_page : cooked_dvi -> int -> float -> int -> int -> unit
  val unfreeze_fonts : cooked_dvi -> unit
  val unfreeze_glyphs : cooked_dvi -> float -> unit
end ;;

(*** Some utilities for specials ***)

let has_prefix pre str =
  let len = String.length pre in
  String.length str >= len &&
  String.sub str 0 len = pre ;;

let rec split_string s start =
  let len = String.length s
  and i = ref start in
  while !i < len && s.[!i] = ' ' do incr i done ;
  if !i >= len then [] else begin
    let i0 = !i in
    while !i < len && s.[!i] <> ' ' do incr i done ;
    let i1 = !i in
    String.sub s i0 (i1 - i0) :: split_string s i1
  end ;;

let named_colors = [
  "Black", 0x000000 ;
  "White", 0xffffff ;
  "Red", 0xff0000 ;
  "Green", 0x00ff00 ;
  "Blue", 0x0000ff ;
  "Cyan", 0x00ffff ;
  "Magenta", 0xff00ff ;
  "Yellow", 0xffff00
] ;;

let rgb r g b =
  (r lsl 16) + (g lsl 8) + b ;;

let cmyk c m y k =
  let r = 255 - c
  and g = 255 - m
  and b = 255 - y in
  (* k is ignored *)
  rgb r g b ;;

let parse_color_args = function
  | ["rgb"; rs; gs; bs] ->
      let r = int_of_float (255.0 *. float_of_string rs)
      and g = int_of_float (255.0 *. float_of_string gs)
      and b = int_of_float (255.0 *. float_of_string bs) in
      rgb r g b
  | ["cmyk"; cs; ms; ys; ks] ->
      let c = int_of_float (255.0 *. float_of_string cs)
      and m = int_of_float (255.0 *. float_of_string ms)
      and y = int_of_float (255.0 *. float_of_string ys)
      and k = int_of_float (255.0 *. float_of_string ks) in
      cmyk c m y k
  | ["gray"; gs] ->
      let g = int_of_float (255.0 *. float_of_string gs) in
      rgb g g g
  | [s] ->
      begin
        try List.assoc s named_colors
        with Not_found ->
          Format.eprintf "unknown color %s@." s ;
          0x000000
      end
  | _ -> 0x000000 ;;

(*****************)
(*  The Functor  *)
(*****************)

module Make(Dev : DEVICE) = struct

  module DFont = Devfont.Make(Dev)
  let base_dpi = 600

  (*** Cooked fonts ***)

  type cooked_font = {
      name : string ;
      ratio : float ;
      mtable : (int * int) Table.t ;
      mutable gtables : (int * Dev.glyph Table.t) list
    }

  let dummy_mtable = Table.make (fun _ -> raise Not_found)
  let dummy_gtable = Table.make (fun _ -> raise Not_found)

  let cook_font fdef dvi_res =
    let name = fdef.Dvi.name
    and sf = fdef.Dvi.scale_factor
    and ds = fdef.Dvi.design_size in
    let ratio = float sf /. float ds in
    let mtable =
      try DFont.find_metrics name (dvi_res *. ratio)
      with Not_found -> dummy_mtable in
    { name = name ;
      ratio = ratio ;
      mtable = mtable ;
      gtables = [] }

  let get_gtable cfont sdpi =
    try List.assoc sdpi cfont.gtables
    with Not_found ->
      let dpi = ldexp (float sdpi) (-16) in
      let table =
	try DFont.find_glyphs cfont.name (dpi *. cfont.ratio)
	with Not_found -> dummy_gtable in
      cfont.gtables <- (sdpi, table) :: cfont.gtables ;
      table

  (*** Cooked DVI's ***)

  type cooked_dvi = {
      base_dvi : Dvi.t ;
      dvi_res : float ;
      font_table : cooked_font Table.t
    }

  let cook_dvi dvi =
    let dvi_res = 72.27 in
    let build n =
      cook_font (List.assoc n dvi.Dvi.font_map) dvi_res in
    { base_dvi = dvi ;
      dvi_res = dvi_res ;
      font_table = Table.make build }

  (*** The rendering state ***)

  type reg_set = {
      reg_h : int ;
      reg_v : int ;
      reg_w : int ;
      reg_x : int ;
      reg_y : int ;
      reg_z : int
    }

  type color = int

  type state = {
      cdvi : cooked_dvi ;
      sdpi : int ;
      conv : float ;
      x_origin : int ;
      y_origin : int ;
      (* Current font attributes *)
      mutable cur_mtable : (int * int) Table.t ;
      mutable cur_gtable : Dev.glyph Table.t ;
      (* Registers *)
      mutable h : int ;
      mutable v : int ;
      mutable w : int ;
      mutable x : int ;
      mutable y : int ;
      mutable z : int ;
      (* Register stack *)
      mutable stack : reg_set list ;
      (* Color & Color stack *)
      mutable color : color ;
      mutable color_stack : color list
    }

  (*** Rendering primitives ***)

  let push st =
    let rset =
      { reg_h = st.h ; reg_v = st.v ;
	reg_w = st.w ; reg_x = st.x ;
	reg_y = st.y ; reg_z = st.z } in
    st.stack <- rset :: st.stack

  let pop st =
    match st.stack with
    | [] -> ()
    | rset :: rest ->
	st.h <- rset.reg_h ;
	st.v <- rset.reg_v ;
	st.w <- rset.reg_w ;
	st.x <- rset.reg_x ;
	st.y <- rset.reg_y ;
	st.z <- rset.reg_z ;
	st.stack <- rest

  let color_push st col =
    st.color_stack <- st.color :: st.color_stack ;
    st.color <- col ;
    Dev.set_color col

  let color_pop st =
    match st.color_stack with
    | [] -> ()
    | col :: rest ->
	st.color <- col ;
	Dev.set_color col ;
	st.color_stack <- rest

  let fnt st n =
    let (mtable, gtable) =
      try
	let cfont = Table.get st.cdvi.font_table n in
	(cfont.mtable, get_gtable cfont st.sdpi)
      with Not_found -> (dummy_mtable, dummy_gtable) in
    st.cur_mtable <- mtable ;
    st.cur_gtable <- gtable

  let put st code =
    try
      let x = st.x_origin + int_of_float (st.conv *. float st.h)
      and y = st.y_origin + int_of_float (st.conv *. float st.v)
      and glyph = Table.get st.cur_gtable code in
      Dev.draw_glyph glyph x y
    with _ -> ()

  let set st code =
    put st code ;
    try
      let (dx, dy) = Table.get st.cur_mtable code in
      st.h <- st.h + dx ;
      st.v <- st.v + dy
    with _ -> ()

  let put_rule st a b =
    let x = st.x_origin + int_of_float (st.conv *. float st.h)
    and y = st.y_origin + int_of_float (st.conv *. float st.v)
    and w = int_of_float (ceil (st.conv *. float b))
    and h = int_of_float (ceil (st.conv *. float a)) in
    Dev.fill_rect x (y - h) w h

  let set_rule st a b =
    put_rule st a b ;
    st.h <- st.h + b

  (*** Specials ***)

  let color_special st s =
    match split_string s 0 with
    | "color" :: "push" :: args ->
        color_push st (parse_color_args args)
    | "color" :: "pop" :: [] ->
        color_pop st
    | _ -> ()

  let special st s =
    if has_prefix "color " s then
      color_special st s

  (*** Page rendering ***)

  let eval_command st = function
    | Dvi.C_set code -> set st code
    | Dvi.C_put code -> put st code
    | Dvi.C_set_rule(a, b) -> set_rule st a b
    | Dvi.C_put_rule(a, b) -> put_rule st a b
    | Dvi.C_push -> push st
    | Dvi.C_pop -> pop st
    | Dvi.C_right k -> st.h <- st.h + k
    | Dvi.C_w0 -> st.h <- st.h + st.w
    | Dvi.C_w k -> st.w <- k ; st.h <- st.h + st.w
    | Dvi.C_x0 -> st.h <- st.h + st.x
    | Dvi.C_x k -> st.x <- k ; st.h <- st.h + st.x
    | Dvi.C_down k -> st.v <- st.v + k
    | Dvi.C_y0 -> st.v <- st.v + st.y
    | Dvi.C_y k -> st.y <- k ; st.v <- st.v + st.y
    | Dvi.C_z0 -> st.v <- st.v + st.z
    | Dvi.C_z k -> st.z <- k ; st.v <- st.v + st.z
    | Dvi.C_fnt n -> fnt st n
    | Dvi.C_xxx s -> special st s
    | _ -> ()

  let render_page cdvi num dpi xorig yorig =
    if num < 0 || num >= Array.length cdvi.base_dvi.Dvi.pages then
      invalid_arg "Driver.render_page" ;
    let mag = float cdvi.base_dvi.Dvi.preamble.Dvi.pre_mag /. 1000.0
    and page = cdvi.base_dvi.Dvi.pages.(num) in
    let st =
      { cdvi = cdvi ;
	sdpi = int_of_float (mag *. ldexp dpi 16) ;
	conv = mag *. dpi /. cdvi.dvi_res /. 65536.0 ;
	x_origin = xorig ; y_origin = yorig ;
	cur_mtable = dummy_mtable ;
	cur_gtable = dummy_gtable ;
	h = 0 ; v = 0 ; w = 0 ; x = 0 ; y = 0 ; z = 0 ;
	stack = [] ; color = 0x000000 ; color_stack = [] } in
    Dev.set_color st.color ;
    Dvi.page_iter (eval_command st) page

  let unfreeze_font cdvi n =
    try
      let cfont = Table.get cdvi.font_table n in
      ignore (Table.get cfont.mtable (Char.code 'A'))
    with _ -> ()

  let unfreeze_fonts cdvi =
    List.iter (fun (n, _) -> unfreeze_font cdvi n)
      cdvi.base_dvi.Dvi.font_map

  let unfreeze_glyphs cdvi dpi =
    let mag = float cdvi.base_dvi.Dvi.preamble.Dvi.pre_mag /. 1000.0 in
    let sdpi = int_of_float (mag *. ldexp dpi 16)
    and mtable = ref dummy_mtable
    and gtable = ref dummy_gtable in
    let eval = function
      |	Dvi.C_fnt n ->
	  let (mt, gt) =
	    try
	      let cfont = Table.get cdvi.font_table n in
	      (cfont.mtable, get_gtable cfont sdpi)
	    with Not_found -> (dummy_mtable, dummy_gtable) in
	  mtable := mt ;
	  gtable := gt
      |	Dvi.C_set code ->
	  begin try ignore (Table.get !mtable code) with _ -> () end ;
	  begin try ignore (Table.get !gtable code) with _ -> () end
      |	_ -> () in
    for n = 0 to Array.length cdvi.base_dvi.Dvi.pages - 1 do
      mtable := dummy_mtable ;
      gtable := dummy_gtable ;
      Dvi.page_iter eval cdvi.base_dvi.Dvi.pages.(n)
    done ;

end ;;
