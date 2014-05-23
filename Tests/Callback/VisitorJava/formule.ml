open Visiteur


let string_of_formule f = 
  let rec output buf f =
    match f with
    | `Cst true ->       
	Buffer.add_string buf "true"
    | `Cst false ->       
      Buffer.add_string buf "false"
    | `Var nom ->
	Buffer.add_string buf nom
    | `Non sf ->
	Buffer.add_string buf "!(";
	output buf sf;
	Buffer.add_string buf ")"
    | `Et (fg,fd) -> 
	Buffer.add_string buf "(";
	output buf fg;
	Buffer.add_string buf " ^ "; 
	output buf fd;
	Buffer.add_string buf ")";
    | `Ou (fg,fd) ->
	Buffer.add_string buf "(";
	output buf fg;
	Buffer.add_string buf " v "; 
	output buf fd;
	Buffer.add_string buf ")" in
  let buf = Buffer.create 80 in 
  output buf f;
  Buffer.contents buf    
   
class formule f =
  object (self)
      inherit Visiteur._stub_jFormule ()
      method accepte v =
	match f with
	| `Cst b -> v#visite_cst b
	| `Var nom -> v#visite_var nom
	| `Non sf -> v#visite_non (new formule sf :> jFormule)
	| `Et (fg,fd) -> 
	    let fg = (new formule fg :> jFormule)
	    and fd = (new formule fd :> jFormule)in
	    v#visite_et fg fd
	| `Ou (fg,fd) -> 
	    let fg = (new formule fg :> jFormule)
	    and fd = (new formule fd :> jFormule) in
	    v#visite_ou fg fd
  end
and virtual visiteur =
  object 
    inherit Visiteur._stub_jVisiteur ()
(*  method virtual visite_cst: bool -> unit
    method virtual visite_var: string -> unit
    method virtual visite_non: jFormule -> unit
    method virtual visite_et: jFormule -> jFormule -> unit
    method virtual visite_ou: jFormule -> jFormule -> unit *)
  end

let f1 = `Ou (`Cst true, `Et (`Cst true, `Cst false))
let f2 = `Et (`Ou (`Non (`Var "a"), `Var "b"),
	       `Ou (`Var "a", `Non (`Var "b")))
let f3 = `Ou (`Et (`Non (`Var "a"), `Var "a"),
	      `Ou (`Non (`Var "a"), `Var "a"))
