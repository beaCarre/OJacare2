type top = java'lang'Object java_instance;;
exception Null_object of string
type _jni_jPoint = mypack'Point java_instance
type _jni_jColored = mypack'Colored java_instance
type _jni_jColoredPoint = mypack'ColoredPoint java_instance
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
class type jColored =
object
  method _get_jni_jColored : _jni_jColored
  method getColor : unit -> string
  method setColor : string -> unit
end
class type jColoredPoint =
object
  inherit jPoint
  inherit jColored
  method _get_jni_jColoredPoint : _jni_jColoredPoint
  method eq_colored_point : jColoredPoint -> bool
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
    fun () -> Java.call "mypack.Point.distance():double" jni_ref
  method display =
    fun () -> Java.call "mypack.Point.display():void" jni_ref
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

class _capsule_jColored =
  fun (jni_ref : _jni_jColored) ->
    let _ =
      if Java.is_null jni_ref
      then raise (Null_object "mypack/Colored")
      else ()
    in
object (self)
  method getColor =
    fun () -> JavaString.to_string (Java.call "mypack.Colored.getColor():java.lang.String" jni_ref)
  method setColor =
    fun _p0 ->
      let _p0 = JavaString.of_string _p0 in
      (Java.call "mypack.Colored.setColor(java.lang.String):void" jni_ref _p0)
  method _get_jni_jColored = jni_ref
end;;

class _capsule_jColoredPoint =
  fun (jni_ref : _jni_jColoredPoint) ->
    let _ =
      if Java.is_null jni_ref
      then raise (Null_object "mypack/Colored")
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
  method getColor =
    fun () ->
      JavaString.to_string (Java.call "mypack.Colored.getColor():java.lang.String" jni_ref)
  method setColor =
    fun _p0 ->
      let _p0 = JavaString.of_string _p0 in
      (Java.call "mypack.Colored.setColor(java.lang.String):void" jni_ref _p0)
  method eq_colored_point =
    fun (_p0 : jColoredPoint) ->
      let _p0 = _p0#_get_jni_jColoredPoint in
      (Java.call "mypack.ColoredPoint.eq(mypack.ColoredPoint):boolean" jni_ref _p0)
  method _get_jni_jPoint = (jni_ref :> _jni_jPoint)
  method _get_jni_jColored = (jni_ref :> _jni_jColored)
  method _get_jni_jColoredPoint = jni_ref
end;;


let jPoint_of_top (o : top) : jPoint =
  new _capsule_jPoint (Java.cast "mypack.Point" o)

let jColored_of_top (o : top) : jColored =
  new _capsule_jColored (Java.cast "mypack.Colored" o)

let jColoredPoint_of_top (o : top) : jColoredPoint =
  new _capsule_jColoredPoint (Java.cast "mypack.ColoredPoint" o)

let _instance_of_jPoint (o : top) =
  Java.instanceof "mypack.Point" o

let _instance_of_jColored (o : top) =
  Java.instanceof "mypack.Colored" o

let _instance_of_jColoredPoint (o : top) =
  Java.instanceof "mypack.ColoredPoint" o
    
class point _p0 _p1 =
  let _p1 = Int32.of_int _p1 in
  let _p0 = Int32.of_int _p0 in
  let java_obj = Java.make "mypack.Point(int,int)" _p0 _p1
  in object (self) inherit _capsule_jPoint java_obj end

class default_point () =
  let java_obj = Java.make "mypack.Point()" ()
  in object (self) inherit _capsule_jPoint java_obj end

class colored_point _p0 _p1 _p2 =
  let _p1 = Int32.of_int _p1 in
  let _p0 = Int32.of_int _p0 in
  let _p2 = JavaString.of_string _p2 in
  let java_obj = 
    Java.make "mypack.ColoredPoint(int,int,java.lang.String)" _p0 _p1 _p2
  in object (self) inherit _capsule_jColoredPoint java_obj end

class default_colored_point () =
  let java_obj = Java.make "mypack.ColoredPoint()" ()
  in object (self) inherit _capsule_jColoredPoint java_obj end
