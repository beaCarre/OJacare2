{(*	$Id: lexer.mll,v 1.1.1.1 2003/10/19 22:57:42 henry Exp $	*)

open Parser

let keywords = 
    [ "package",PACKAGE;

      "class",CLASS;
      "interface",INTERFACE;

      "extends",EXTENDS;
      "implements",IMPLEMENTS;

      "static",STATIC;
      "final",FINAL;
      "abstract",ABSTRACT;

      "name",NAME;
      "callback",CALLBACK;

      "void",VOID;
      "boolean",BOOLEAN;
      "byte",BYTE;
      "short",SHORT;
      "int",INT;
      "long",LONG;
      "float",FLOAT;
      "double",DOUBLE;
      "char",CHAR;
      "string",STRING;
      "top",TOP;
      "array",ARRAY;

    ]

  let tbl = Hashtbl.create 29
  let _ = List.iter (fun (name,key) -> Hashtbl.add tbl name key) keywords


let parse_ident id =
  try Hashtbl.find tbl id
  with
    Not_found -> IDENT id


}
let letter = [ 'a'-'z' 'A'-'Z' ]
let alpha = [ 'a'-'z' 'A'-'Z' '_' '\'' '0'-'9' ]
let ident = letter alpha *
    
rule token =
   parse
     | '\n' | '\t' | ' ' { token lexbuf }
     | '.' { DOT }
     | '[' { LBRACKET }
     | ']' { RBRACKET }
     | '{' { LBRACE }
     | '}' { RBRACE }
     | '(' { LPAREN }
     | ')' { RPAREN }
     | ',' { COMMA }
     | ';' { SEMI }
     | "<init>" { INIT }
     | "//" { comment_line lexbuf}
     | ident { parse_ident (Lexing.lexeme lexbuf) }
     | eof { EOF }

and comment_line = 
    parse
     | '\n' { token lexbuf }
     | _ { comment_line lexbuf }
