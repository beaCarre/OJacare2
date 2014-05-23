(*	$Id: idl_parser.ml,v 1.1.1.1 2003/10/19 22:57:42 henry Exp $	*)

open Syntax_error

let from_file name =
  try
    let inchan = open_in name in
    let lexbuf = Lexing.from_channel inchan in
    try
      let ast = Parser.idl_file Lexer.token lexbuf in
      close_in inchan; ast
    with
    | Syntax_error err ->
	print_string "Erreur de syntaxe."; print_newline ();
	let loc = explain err in
	(match loc with
	| None -> ()
	| Some loc -> Loc.print_source inchan loc
	);
	close_in inchan;
	exit 2
    | Parsing.Parse_error -> 
	print_string "Erreur de syntaxe."; print_newline ();
	let loc = Loc.Loc (Lexing.lexeme_start lexbuf, Lexing.lexeme_end lexbuf) in
	Loc.print_source inchan loc;
	exit 2

  with
  | Sys_error str -> output_string stderr str; output_char stderr '\n'; exit 1;
