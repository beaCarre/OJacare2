(** jniArray : manipulation de tableau Java *)

class type ['a] jArray =
  object
    method _get_jniobj : Jni.obj
    method get : int -> 'a
    method set : int -> 'a -> unit
  end
(** type des tableau java encapsulé *)

val init_boolean_jArray : int -> (int -> bool) -> bool jArray
val init_byte_jArray : int -> (int -> int) -> int jArray
val init_char_jArray : int -> (int -> int) -> int jArray
val init_short_jArray : int -> (int -> int) -> int jArray
val init_int_jArray : int -> (int -> int) -> int jArray
val init_long_jArray : int -> (int -> int64) -> int64 jArray
val init_float_jArray : int -> (int -> float) -> float jArray
val init_double_jArray : int -> (int -> float) -> float jArray
val init_string_jArray : int -> (int -> string) -> string jArray
val init_top_jArray :
  int -> (int -> JniHierarchy.top) -> JniHierarchy.top jArray
(** fonctions d'initialisations *)


(** class capsule à l'usage du générateur de code ... *)
class ['a, 'b] _Array :
  (Jni.obj -> int -> 'a) ->
  (Jni.obj -> int -> 'a -> unit) ->
  ('a -> 'b) ->
  ('b -> 'a) ->
  Jni.obj ->
  object
    method _get_jniobj : Jni.obj
    method get : int -> 'b
    method set : int -> 'b -> unit
  end


(** fonction d'allocation à l'usage du générateur de code *)
val _new_boolean_jArray : int -> bool jArray
val _new_byte_jArray : int -> int jArray
val _new_char_jArray : int -> int jArray
val _new_short_jArray : int -> int jArray
val _new_int_jArray : int -> int jArray
val _new_long_jArray : int -> int64 jArray
val _new_float_jArray : int -> float jArray
val _new_double_jArray : int -> float jArray
val _new_string_jArray : int -> string jArray
val _new_top_jArray : int -> JniHierarchy.top jArray
