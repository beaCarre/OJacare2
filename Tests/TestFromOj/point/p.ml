type top = java'lang'Object java_instance;;
exception Null_object of string
type _jni_jPoint = mypack'Point java_instance;;

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

class _capsule_jPoint =
  fun (jni_ref : _jni_jPoint) ->
    let _ =
      if Java.is_null jni_ref
      then raise (Null_object "mypack/Point")
      else ()
    in
object (self)
  method eq =
    fun (_p0 : jPoint) ->
      let _p0 = _p0#_get_jni_jPoint in
      Java.call "mypack.Point.eq(mypack.Point):boolean" jni_ref _p0
  method distance =
    fun () ->
      Java.call "mypack.Point.distance():double" jni_ref
  method display =
    fun () ->
      Java.call "mypack.Point.display():void" jni_ref
  method toString =
    fun () ->
      JavaString.to_string
	(Java.call "mypack.Point.toString():java.lang.String" jni_ref)
  method rmoveto =
    fun _p0 _p1 ->
      let _p1 = Int32.of_int _p1 in
      let _p0 = Int32.of_int _p0
      in Java.call "mypack.Point.rmoveto(int,int):void" jni_ref _p0 _p1
  method moveto =
    fun _p0 _p1 ->
      let _p1 = Int32.of_int _p1 in
      let _p0 = Int32.of_int _p0
      in Java.call "mypack.Point.moveto(int,int):void" jni_ref _p0 _p1
  method set_y =
    fun _p ->
      let _p = Int32.of_int _p
      in Java.set "mypack.Point.y:int" jni_ref _p
  method get_y =
    fun () -> Int32.to_int (Java.get "mypack.Point.y:int" jni_ref)
  method set_x =
    fun _p ->
      let _p = Int32.of_int _p
      in Java.set "mypack.Point.x:int" jni_ref _p
  method get_x =
    fun () -> Int32.to_int (Java.get "mypack.Point.x:int" jni_ref)
  method _get_jni_jPoint = jni_ref
end;;

let jPoint_of_top (o : top) : jPoint =
  new _capsule_jPoint (Java.cast "mypack.Point" o);;
let _instance_of_jPoint (o : top) =
  Java.instanceof "mypack.Point" o;;

class point _p0 _p1 =
  let _p1 = Int32.of_int _p1 in
  let _p0 = Int32.of_int _p0 in
  let java_obj = Java.make "mypack.Point(int,int)" _p0 _p1
  in object (self) inherit _capsule_jPoint java_obj end;;
class default_point () =
  let java_obj = Java.make "mypack.Point()" ()
  in object (self) inherit _capsule_jPoint java_obj end;;
