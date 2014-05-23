type top = java'lang'Object java_instance;;
exception Null_object of string;;
type _jni_jPoint = mypack'Point java_instance;;
type _jni_jRectangleGr = mypack'RectangleGr java_instance;;
type _jni_jRectangleGeo = mypack'RectangleGeo java_instance;;
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
class _capsule_jPoint (jni_ref : _jni_jPoint) =
  let _ =
    if Java.is_null jni_ref then raise (Null_object "mypack/Point") else ()
  in object (self) method _get_jni_jPoint = jni_ref end
and _capsule_jRectangleGr (jni_ref : _jni_jRectangleGr) =
  let _ =
    if Java.is_null jni_ref
    then raise (Null_object "mypack/RectangleGr")
    else ()
  in
    object (self)
      method toString =
        fun () ->
          JavaString.to_string
            (Java.call "mypack.RectangleGr.toString():java.lang.String"
               jni_ref)
      method compute_perimeter =
        fun () ->
          Int32.to_int
            (Java.call "mypack.RectangleGr.computePerimeter():int" jni_ref)
      method _get_jni_jRectangleGr = jni_ref
    end
and _capsule_jRectangleGeo (jni_ref : _jni_jRectangleGeo) =
  let _ =
    if Java.is_null jni_ref
    then raise (Null_object "mypack/RectangleGeo")
    else ()
  in
    object (self)
      method compute_area =
        fun () ->
          Int32.to_int
            (Java.call "mypack.RectangleGeo.computeArea():int" jni_ref)
      method toString =
        fun () ->
          JavaString.to_string
            (Java.call "mypack.RectangleGeo.toString():java.lang.String"
               jni_ref)
      method _get_jni_jRectangleGeo = jni_ref
    end;;
let jPoint_of_top (o : top) : jPoint =
  new _capsule_jPoint (Java.cast "mypack.Point" o);;
let jRectangleGr_of_top (o : top) : jRectangleGr =
  new _capsule_jRectangleGr (Java.cast "mypack.RectangleGr" o);;
let jRectangleGeo_of_top (o : top) : jRectangleGeo =
  new _capsule_jRectangleGeo (Java.cast "mypack.RectangleGeo" o);;
let _instance_of_jPoint (o : top) = Java.instanceof "mypack.Point" o;;
let _instance_of_jRectangleGr (o : top) =
  Java.instanceof "mypack.RectangleGr" o;;
let _instance_of_jRectangleGeo (o : top) =
  Java.instanceof "mypack.RectangleGeo" o;;
class point _p0 _p1 =
  let _p1 = Int32.of_int _p1
  in let _p0 = Int32.of_int _p0
    in let java_obj = Java.make "mypack.Point(int,int)" _p0 _p1
      in object (self) inherit _capsule_jPoint java_obj end;;
class rect_graph _p0 _p1 =
  let _p1 = _p1#_get_jni_jPoint
  in let _p0 = _p0#_get_jni_jPoint
    in
      let java_obj =
        Java.make "mypack.RectangleGr(mypack.Point,mypack.Point)" _p0 _p1
      in object (self) inherit _capsule_jRectangleGr java_obj end;;
class rect_geo _p0 _p1 =
  let _p1 = _p1#_get_jni_jPoint
  in let _p0 = _p0#_get_jni_jPoint
    in
      let java_obj =
        Java.make "mypack.RectangleGeo(mypack.Point,mypack.Point)" _p0 _p1
      in object (self) inherit _capsule_jRectangleGeo java_obj end;;


