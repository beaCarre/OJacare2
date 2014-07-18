(*	$Id: filesystem.ml,v 1.1.1.1 2003/10/19 22:57:41 henry Exp $	*)

let filename dir name =
  let rec loop acc l = match l with
    [] -> acc
  | n::l -> loop (Filename.concat acc n) l
  in
  Filename.concat (loop Filename.current_dir_name dir) name

let safe_open_out dir name =
  let rec loop acc l = match l with
    [] -> acc
  | n::l -> 
      let acc = Filename.concat acc n in
      (try Unix.mkdir acc 0o755 with 
      | Unix.Unix_error (Unix.EEXIST,_,_) -> ());
      loop acc l
  in
  let filename = Filename.concat (loop Filename.current_dir_name dir) name in
  open_out filename
