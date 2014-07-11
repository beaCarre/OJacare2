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

type color = int ;;

(*** Private glyphs ***)

type cache =
  | No_cache
  | Cached of color * Graphics.image ;;

type glyph = {
    width : int ;
    height : int ;
    hoffset : int ;
    voffset : int ;
    graymap : string ;
    mutable cache : cache ;
    mutable img_list : (color * Graphics.image) list
  } ;;

let get_color_table =
  let htable = Hashtbl.create 257 in
  function col ->
    try Hashtbl.find htable col
    with Not_found ->
      let table = Array.make 256 Graphics.transp
      and r0 = (col lsr 16) land 0xff
      and g0 = (col lsr 8) land 0xff
      and b0 = col land 0xff in
      for i = 1 to 255 do
	let k = (255 - i)*255 in
	let r = (k + i*r0)/255
	and g = (k + i*g0)/255
	and b = (k + i*b0)/255 in
	table.(i) <- (r lsl 16) + (g lsl 8) + b
      done ;
      Hashtbl.add htable col table ;
      table ;;

let get_image g col =
  match g.cache with
  | Cached(c, img) when c = col -> img
  | _ ->
      let img =
	try List.assoc col g.img_list
	with Not_found ->
	  let gmap = g.graymap
	  and w = g.width
	  and h = g.height in
         (* We enforce [h <> 0] and [w <> 0] because
	    Caml graphics don't like zero-sized pixmaps. *)
	  let dst = Array.make_matrix (max 1 h) (max 1 w) Graphics.transp
	  and table = get_color_table col
	  and p = ref 0 in
	  for i = 0 to h - 1 do
	    for j = 0 to w - 1 do
	      dst.(i).(j) <- table.(Char.code gmap.[!p]) ;
	      incr p
	    done
	  done ;
	  let img = Graphics.make_image dst in
	  g.img_list <- (col, img) :: g.img_list ;
	  img in
      g.cache <- Cached(col, img) ;
      img ;;

let make_glyph g =
  { width = g.Glyph.width ;
    height = g.Glyph.height ;
    hoffset = g.Glyph.hoffset ;
    voffset = g.Glyph.voffset ;
    graymap = g.Glyph.graymap ;
    cache = No_cache ;
    img_list = [] } ;;

(*** Device configuration ***)

let opened = ref false ;;

let size_x = ref 0 ;;
let size_y = ref 0 ;;
let color = ref 0x000000 ;;

let xmin = ref 0 ;;
let xmax = ref 0 ;;
let ymin = ref 0 ;;
let ymax = ref 0 ;;

let open_dev geom =
  if !opened then
    Graphics.close_graph () ;
  Graphics.open_graph geom ;
  size_x := Graphics.size_x () ;
  size_y := Graphics.size_y () ;
  xmin := 0 ; xmax := !size_x ;
  ymin := 0 ; ymax := !size_y ;
  opened := true ;;

let close_dev () =
  if !opened then
    Graphics.close_graph () ;
  opened := false ;;

let clear_dev () =
  if not !opened then
    failwith "Grdev.clear_dev: no window" ;
  Graphics.clear_graph () ;;

let set_bbox bbox =
  if not !opened then
    failwith "Grdev.set_bbox: no window" ;
  match bbox with
  | None ->
      xmin := 0 ; xmax := !size_x ;
      ymin := 0 ; ymax := !size_y
  | Some(x0, y0, w, h) ->
      xmin := x0 ; xmax := x0 + w ;
      ymin := !size_y - (y0 + h) ; ymax := !size_y - y0 ;;

(*** Drawing ***)

let set_color col =
  if not !opened then
    failwith "Grdev.set_color: no window" ;
  color := col ;
  Graphics.set_color col ;;
  
let draw_glyph g x0 y0 =
  if not !opened then
    failwith "Grdev.draw_glyph: no window" ;
  let w = g.width
  and h = g.height in
  let x = x0 - g.hoffset
  and y = !size_y - y0 + g.voffset - h in
  if x + w > !xmin && x < !xmax && y + h > !ymin && y < !ymax then begin
    let img = get_image g !color in
    Graphics.draw_image img x y
  end ;; 

let fill_rect x0 y0 w h =
  if not !opened then
    failwith "Grdev.fill_rect: no window" ;
  let x = x0
  and y = !size_y - y0 - h in
  let x' = x + w
  and y' = y + h in
  (* clipping *)
  let x = max !xmin x
  and y = max !ymin y
  and x' = min x' !xmax
  and y' = min y' !ymax in
  let w = x' - x
  and h = y' - y in
  if w > 0 && h > 0 then
    Graphics.fill_rect x y w h ;;

(*** Events ***)

type status = Graphics.status = {
    mouse_x : int ;
    mouse_y : int ;
    button : bool ;
    keypressed : bool ;
    key : char
  } ;;

type event = Graphics.event =
  | Button_down
  | Button_up
  | Key_pressed
  | Mouse_motion
  | Poll ;;

let wait_next_event flags =
  let ev = Graphics.wait_next_event flags in
  { mouse_x = ev.Graphics.mouse_x ;
    mouse_y = !size_y - ev.Graphics.mouse_y ;
    button = ev.Graphics.button ;
    keypressed = ev.Graphics.keypressed ;
    key = ev.Graphics.key } ;;
