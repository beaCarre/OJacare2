(*	$Id: modifiers.mli,v 1.1.1.1 2003/10/19 22:57:41 henry Exp $	*)

val is_abstract : Idl.modifier list -> bool
val is_final : Idl.modifier list -> bool
val is_static : Idl.modifier list -> bool
