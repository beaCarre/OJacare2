
class type ['a] jArray =
   object
     inherit JniHierarchy.jTop  
     method set : int -> 'a -> unit
     method get : int -> 'a
   end

let id = fun x -> x

(*********** Capsule ***************)
class ['jni,'jCaml] _Array  
    (jni_get: Jni.obj -> int -> 'jni)
    (jni_set: Jni.obj -> int -> 'jni -> unit)
    (from_java: 'jni -> 'jCaml) 
    (to_java: 'jCaml -> 'jni) 
    (java_obj  :Jni.obj) =
  object
    inherit JniHierarchy.top java_obj
    method set i (obj:'jCaml) = 
(* try  *)
      jni_set java_obj i (to_java obj) 
(* with Jni.Exception e -> invalid_arg "_Array#set" *)
    method get i = 
(* try *)
      from_java (jni_get java_obj i)
(* with Jni.Exception e -> invalid_arg "_Array#get" *)
  end
    

(*********** Allocations ************)
let _new_boolean_jArray size =
  let java_obj = Jni.new_boolean_array size in 
  (new _Array Jni.get_boolean_array_element Jni.set_boolean_array_element id id java_obj : bool jArray)

let _new_byte_jArray size =
  let java_obj = Jni.new_byte_array size in 
  (new _Array Jni.get_byte_array_element Jni.set_byte_array_element id id java_obj : int jArray)

let _new_char_jArray size =
  let java_obj = Jni.new_char_array size in 
  (new _Array Jni.get_char_array_element Jni.set_char_array_element id id java_obj : int jArray)

let _new_short_jArray size =
  let java_obj = Jni.new_short_array size in 
  (new _Array Jni.get_short_array_element Jni.set_short_array_element id id java_obj : int jArray)

(* int pour 'Jni.camlint' *)
let _new_int_jArray size =
  let java_obj = Jni.new_int_array size in 
  (new _Array Jni.get_camlint_array_element Jni.set_camlint_array_element id id java_obj : int jArray)

let _new_long_jArray size =
  let java_obj = Jni.new_long_array size in 
  (new _Array Jni.get_long_array_element Jni.set_long_array_element id id java_obj : int64 jArray)

let _new_float_jArray size =
  let java_obj = Jni.new_float_array size in 
  (new _Array Jni.get_float_array_element Jni.set_float_array_element id id java_obj : float jArray)
    
let _new_double_jArray size =
  let java_obj = Jni.new_double_array size in 
  (new _Array Jni.get_double_array_element Jni.set_double_array_element id id java_obj : float jArray)

let _new_string_jArray size =
  let java_obj = Jni.new_object_array size (Jni.find_class "java/lang/String") in 
  (new _Array Jni.get_object_array_element Jni.set_object_array_element Jni.string_from_java Jni.string_to_java java_obj
     : string jArray)

let _new_top_jArray size =
  let java_obj = Jni.new_object_array size (Jni.find_class "java/lang/Object") in 
  (new _Array 
     Jni.get_object_array_element 
     Jni.set_object_array_element
     (fun jniobj -> new JniHierarchy.top jniobj) 
     (fun obj -> obj#_get_jniobj)
     java_obj : JniHierarchy.top jArray)

(****** Fonctions de construction *********)

let init_boolean_jArray size f =
  let a = _new_boolean_jArray size in
  for i = 0 to pred size do
    a#set i (f i)
  done;
  a
    
let init_byte_jArray size f =
  let a = _new_byte_jArray size in
  for i = 0 to pred size do
    a#set i (f i)
  done;
  a
 
let init_char_jArray size f =
  let a = _new_char_jArray size in
  for i = 0 to pred size do
    a#set i (f i)
  done;
  a
 
let init_short_jArray size f =
  let a = _new_short_jArray size in
  for i = 0 to pred size do
    a#set i (f i)
  done;
  a
 
let init_int_jArray size f =
  let a = _new_int_jArray size in
  for i = 0 to pred size do
    a#set i (f i)
  done;
  a
 
let init_long_jArray size f =
  let a = _new_long_jArray size in
  for i = 0 to pred size do
    a#set i (f i)
  done;
  a
 
let init_float_jArray size f =
  let a = _new_float_jArray size in
  for i = 0 to pred size do
    a#set i (f i)
  done;
  a
 
let init_double_jArray size f =
  let a = _new_double_jArray size in
  for i = 0 to pred size do
    a#set i (f i)
  done;
  a

let init_string_jArray size f =
  let a = _new_string_jArray size in
  for i = 0 to pred size do
    a#set i (f i)
  done;
  a

let init_top_jArray size f =
  let a = _new_top_jArray size in
  for i = 0 to pred size do
    a#set i (f i)
  done;
  a
