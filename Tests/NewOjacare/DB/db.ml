open Jdb

exception Unbound_field
exception Unbound_row

class type row = object
  method access : string -> string
  method update : string -> string -> unit
  method destroy : unit -> unit
end

type expr = row -> string 

let field s  = fun (r:row) -> r#access s  

let const (s:string) = 
  fun (r:row) -> s

let equals (e1:expr) (e2:expr) = 
  fun (r:row) ->
    if e1 r = e2 r then const "true" r
    else const "false" r

let concat  e1 e2 =
    fun (r:row) -> (e1 r)^(e2 r)

(*  *)
let rec contains_aux s1 s2 =
  let len1 = String.length s1 in 
  let len2 = String.length s2 in
  if len1 < len2 then "false"
  else
    match len2 with
	1 -> 
	  if s2.[0] = s1.[0] 
	  then "true" 
	  else contains_aux (String.sub s1 1 (len1 - 1)) s2
      | _ -> 
	if s2.[0] = s1.[0] 
	then if ( contains_aux (String.sub s1 1 (len1 -1 ))
		    (String.sub s2 1 (len2-1 )) = "true"
		    || contains_aux (String.sub s1 1 (len1 - 1)) s2 = "true") 
	  then "true" 
	  else "false"
	else  contains_aux (String.sub s1 1 (len1 - 1)) s2


let contains  e1 e2  = fun (r:row) ->
  let s1 = e1 r in 
  let s2 = e2 r in 
  contains_aux s1 s2


let bool_op op e1 e2  = fun (r:row) -> 
  let s1 = e1 r in 
  let s2 = e2 r in 
  let expr1 = if s1 = "false" then false else true in
  let expr2 = if s2 = "false" then false else true in
    string_of_bool (op expr1 expr2)


let string_op (f:string->string-> string) (e1:expr) (e2:expr) = fun (r:row) ->
  f (e1 r) (e2 r)


(* a concrete row *)
class c_row  fieldValueList  : row =
object
  val mutable fvlist = fieldValueList
  val mutable destroyed = false
  method access s = 
    if destroyed then
      raise Unbound_row
    else
      try 
	List.assoc s fvlist
      with 
	  Not_found -> print_string "err access\n"; raise Unbound_field
  method update s1 s2 =
    let rec aux = function
      | [] -> raise Unbound_field
      | (field,value)::tl -> 
	if field = s1 
	then (field,s2)::tl 
	else (field,value)::(aux tl)
    in
    if destroyed 
    then
      raise Unbound_row
    else
      fvlist <- aux fvlist
  method destroy () = destroyed <- true
end 

let filter_fvlist fieldlist fvlist=
  let rec filter_fvlist_aux fl fvl =
    match fl with
      [] -> []
    | field::tl -> 
      try 
	(filter_fvlist_aux tl (List.remove_assoc field fvl))
	@ [(field,(List.assoc field fvl))]
      with Not_found -> (filter_fvlist_aux tl fvl)@[(field,"")]
  in
  filter_fvlist_aux fieldlist fvlist


(*  *)
let newrow fields row =
  let rec newrow_aux fields row =
    match fields with
	[] -> []
      | hd::tl -> (hd,row#access hd)::(newrow_aux tl row)
  in
  newrow_aux fields row

  
(** The type of databases.
   Instanciating this classe creates an empty database,
   using the field names given as arguments. *)
class db (fields: string list) =
object (self)
  val mutable fields = fields
  val mutable listRows : row list  = []
  method all =
    listRows
  method select e = 
    match List.filter (fun r -> (e r) <> "false") self#all with
	[]-> raise Not_found
      | lr -> lr
  method select_one e = 
    match self#select e with
	[] -> raise Not_found
      | hd::tl -> hd
  method delete (r:row) = 
    r#destroy();
    listRows <- List.filter ((<>) r) self#all
  method describe =
    fields
  method insert fvlist = 
    let veriffield fvl=
      match fvl with
	  [] -> ()
	| (f,v)::tl -> try ignore (List.find ((=) f) self#describe)
	  with Not_found -> raise Unbound_field
    in
    veriffield fvlist;
    let fvlrow = filter_fvlist self#describe fvlist in
    let newrow = (new c_row fvlrow : row) in
    listRows <- self#all@[newrow];
    newrow
  method add_column nf (expr:expr) =
    if not(List.exists ((=) nf) fields) then
      let rec newrows_add_c rows =
	match rows with
	    [] -> []
	  | hd::tl ->
	    (new c_row ((newrow self#describe hd)@[(nf,expr hd)]):row)
	    ::newrows_add_c tl
      in
      begin
	listRows <- newrows_add_c self#all;
	fields <- fields@[nf] 
      end
  method remove_column f = 
    (match fields with
	[] -> ()
      | f::tl -> try ignore (List.find ((=) f) fields)
	with Not_found -> raise Unbound_field);
    let rec newrows_rem_c rows =
      match listRows with
	  [] -> []
	| hd::tl -> 
	  (new c_row (List.remove_assoc f (newrow fields hd)):row)
	  :: newrows_rem_c tl 
    in
    fields <- List.filter ((<>) f) fields;
    listRows <- newrows_rem_c listRows
end 


let read_csv filename = (* : string -> db *)
  let chan = open_in filename in
  let fields = Str.split (Str.regexp ",") (input_line chan) in
  let db = new db fields in
  let rec read_lines =
      (try
	 while true do
	   let line =
	     List.map 
	       (fun s -> String.sub s 1 (String.length s - 2))
	       (Str.split (Str.regexp ",")  (input_line chan)) in
	   let fvlist = List.combine fields line in
	   ignore (db#insert fvlist)
	 done
       with End_of_file -> close_in chan);
  in
  read_lines;
  db
let rec write_line line chan =
  match line with
      [] -> () 
    | hd::tl -> output_string  chan ("\"" ^hd^ "\"");
      if tl <> [] 
      then
	begin
	  output_string chan "," ;
	  write_line tl chan 
	end
      else
	output_string chan "\n"

(*
let write_csv filename (db:db) =
  let chan = open_out filename in
  let fields = db#describe in
  let rows = db#all in
  let rec values row fields =
    match fields with
	[]-> []
      | f::tl -> (row#access f)::(values row tl)
  in
  let rec write_rows rows =
    match rows with
	[] -> ()
      | r :: tl -> write_line (values r fields) chan ;
	write_rows tl
  in
  write_line fields chan;
  write_rows rows ;

  *)
let print_db title db =
  let fields = db#describe in
  let rows = db#all in
  let rec values row fields =
    match fields with
	[]-> []
      | f::tl -> (row#access f)::(values row tl)
  in
  let rec convert_rows rows =
    match rows with
	[] -> []
      | r :: tl ->  (Array.of_list (values r fields))::convert_rows tl
  in
  let fieldsArray = Array.of_list fields 
    
  in
  let rowsArray = Array.of_list (convert_rows rows)
  in 
  ignore (new frameDB title fieldsArray rowsArray)
