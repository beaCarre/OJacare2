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

module Make(Dev : DEVICE) : DVIVIEW ;;
