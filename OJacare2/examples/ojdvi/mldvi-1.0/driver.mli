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

module Make(Dev : DEVICE) : DRIVER ;;
