type top;;

type _jni_jPoint;;
type _jni_jColored;;
type _jni_jColoredPoint;;

class type jPoint =
object
  method _get_jni_jPoint : _jni_jPoint
  method set_x : int -> unit
  method get_x : unit -> int
  method set_y : int -> unit
  method get_y : unit -> int
  method moveto : int -> int -> unit
  method rmoveto : int -> int -> unit
  method toString : unit -> string
  method display : unit -> unit
  method distance : unit -> float
  method eq : jPoint -> bool
end;;

class type jColored =
object
  method _get_jni_jColored : _jni_jColored
  method getColor : unit -> string
  method setColor : string -> unit
end;;

class type jColoredPoint =
object
  inherit jPoint
  inherit jColored
  method _get_jni_jColoredPoint : _jni_jColoredPoint
  method eq_colored_point : jColoredPoint -> bool
end;;

val jPoint_of_top : top -> jPoint;; 
val jColored_of_top : top -> jColored;;
val jColoredPoint_of_top : top -> jColoredPoint;;

val _instance_of_jPoint : top -> bool;;
val _instance_of_jColored : top -> bool;;
val _instance_of_jColoredPoint : top -> bool;;

class point : int -> int -> jPoint;;
class default_point : unit -> jPoint;;

class colored_point : int -> int -> string -> jColoredPoint;;
class default_colored_point : unit -> jColoredPoint;;
