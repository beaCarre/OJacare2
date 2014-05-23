type top = java'lang'Object java_instance;;
exception Null_object of string;;
type _jni_jClassTest = mypack'ClassTest java_instance;;
class type jClassTest =
  object
    method _get_jni_jClassTest : _jni_jClassTest
    method toString : unit -> string
  end;;
class _capsule_jClassTest (jni_ref : _jni_jClassTest) =
  let _ =
    if Java.is_null jni_ref
    then raise (Null_object "mypack/ClassTest")
    else ()
  in
    object (self)
      method toString =
        fun () ->
          JavaString.to_string
            (Java.call "mypack.ClassTest.toString():java.lang.String" jni_ref)
      method _get_jni_jClassTest = jni_ref
    end;;
let jClassTest_of_top (o : top) : jClassTest =
  new _capsule_jClassTest (Java.cast "mypack.ClassTest" o);;
let _instance_of_jClassTest (o : top) =
  Java.instanceof "mypack.ClassTest" o;;
class classTest () =
  let java_obj = Java.make "mypack.ClassTest()" ()
  in object (self) inherit _capsule_jClassTest java_obj end;;


