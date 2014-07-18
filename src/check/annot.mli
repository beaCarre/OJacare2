(*	$Id: annot.mli,v 1.1.1.1 2003/10/19 22:57:41 henry Exp $	*)

val get_name : Idl.annotation list -> Idl.ident option
val is_callback : Idl.annotation list -> bool
val have_array : Idl.annotation list -> bool
