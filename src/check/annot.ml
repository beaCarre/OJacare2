(*	$Id: annot.ml,v 1.1.1.1 2003/10/19 22:57:41 henry Exp $	*)

open Idl

let get_name annot_l = 
  let rec loop l =
    match l with
      a::l -> (match a.an_desc with 
	Iname s -> Some s
       | _ -> loop l  )
    | [] -> None
  in loop annot_l

let is_callback annot_l = 
  let rec loop l =
    match l with
      a::l -> (match a.an_desc with 
	Icallback -> true
       | _ -> loop l )
    | [] -> false
  in loop annot_l

let have_array annot_l = 
  let rec loop l =
    match l with
      a::l -> (match a.an_desc with 
	Icamlarray -> true
       | _ -> loop l  )
    | [] -> false
  in loop annot_l
