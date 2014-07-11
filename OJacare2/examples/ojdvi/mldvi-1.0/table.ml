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

type 'a status =
  | Unknown
  | Known of 'a
  | Error of exn ;;

type 'a t = {
    matrix : 'a status array array ;
    htable : (int, 'a status) Hashtbl.t ;
    build : int -> 'a
  } ;;

let make f =
  { matrix = Array.make 256 [| |] ;
    htable = Hashtbl.create 257 ;
    build = f } ;;

let get tbl n =
  if n >= 0x0000 && n <= 0xffff then begin
    let matrix = tbl.matrix
    and hi = n lsr 8
    and lo = n land 0xff in
    if matrix.(hi) = [| |] then
      matrix.(hi) <- Array.make 256 Unknown ;
    match matrix.(hi).(lo) with
    | Known v -> v
    | Error e -> raise e
    | Unknown ->
	try
	  let v = tbl.build n in
	  matrix.(hi).(lo) <- Known v ;
	  v
	with e ->
	  matrix.(hi).(lo) <- Error e ;
	  raise e
  end else begin
    let htable = tbl.htable in
    let st =
      try Hashtbl.find htable n
      with Not_found ->
	let st =
	  try Known (tbl.build n)
	  with e -> Error e in
	Hashtbl.add htable n st ;
	st in
    match st with
    | Unknown -> assert false
    | Known v -> v
    | Error e -> raise e
  end ;;
