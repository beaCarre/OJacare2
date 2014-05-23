(*	$Id: utilities.ml,v 1.1.1.1 2003/10/19 22:57:41 henry Exp $	*)

let interval m n = 
  let rec loop acc i =
    if i < m then acc else loop (i::acc) (pred i)
  in
  loop [] (pred n);;

let is_capitalized s =
  if String.length s = 0 then
    false
  else 
    match s.[0] with
      'A' .. 'Z' -> true
    | _ -> false


let rec split3 = function
    [] -> ([], [], [])
  | (x,y,z)::l ->
      let (rx, ry, rz) = split3 l in (x::rx, y::ry, z::rz)
