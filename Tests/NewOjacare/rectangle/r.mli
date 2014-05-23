type top;;
type _jni_jPoint;;
type _jni_jRectangleGr;;
type _jni_jRectangleGeo;;
class type jPoint = object method _get_jni_jPoint : _jni_jPoint end
and jRectangleGr =
  object
    method _get_jni_jRectangleGr : _jni_jRectangleGr
    method compute_perimeter : unit -> int
    method toString : unit -> string
  end
and jRectangleGeo =
  object
    method _get_jni_jRectangleGeo : _jni_jRectangleGeo
    method compute_area : unit -> int
    method toString : unit -> string
  end;;
class point : int -> int -> jPoint;;
class rect_graph : jPoint -> jPoint -> jRectangleGr;;
class rect_geo : jPoint -> jPoint -> jRectangleGeo;;


