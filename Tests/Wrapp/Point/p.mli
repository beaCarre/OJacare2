type top;;
type _jni_jPoint;;
type _jni_jColored;;
type _jni_jColoredPoint;;
type _jni_jCloud;;
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
  end
and jColored =
  object
    method _get_jni_jColored : _jni_jColored
    method getColor : unit -> string
    method setColor : string -> unit
  end
and jColoredPoint =
  object
    inherit jPoint
    inherit jColored
    method _get_jni_jColoredPoint : _jni_jColoredPoint
    method eq_colored_point : jColoredPoint -> bool
  end
and jCloud =
  object
    method _get_jni_jCloud : _jni_jCloud
    method addPoint : jPoint -> unit
    method toString : unit -> string
  end;;
class point : int -> int -> jPoint;;
class default_point : unit -> jPoint;;
class colored_point : int -> int -> string -> jColoredPoint;;
class default_colored_point : unit -> jColoredPoint;;
class empty_cloud : unit -> jCloud;;


