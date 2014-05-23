type _jni_jPoint;;
class type jPoint =
  object
    inherit JniHierarchy.top
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
val jPoint_of_top : JniHierarchy.top -> jPoint;;
val _instance_of_jPoint : JniHierarchy.top -> bool;;
val jArray_init_jPoint : int -> (int -> jPoint) -> jPoint JniArray.jArray;;
class point : int -> int -> jPoint;;
class default_point : unit -> jPoint;;

val mypack_jPoint__main : string JniArray.jArray -> unit;;
