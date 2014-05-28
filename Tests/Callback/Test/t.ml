type top = java'lang'Object java_instance;;
exception Null_object of string;;
type _jni_jTest = mypack'Test java_instance;;
type _jni_jClassTest = mypack'ClassTest java_instance;;
class type jTest =
  object
    method display2 : unit -> unit
    method toString2 : unit -> java'lang'String java_instance
    method _get_jni_jTest : _jni_jTest
end
and jClassTest =
  object
    method _get_jni_jClassTest : _jni_jClassTest
    method toString : unit -> string
    method display : unit -> unit
  end;;
class _souche_jTest (jni_ref : _jni_jTest) =
  let _ =
    if Java.is_null jni_ref
    then  raise (Null_object "mypack/Test")
    else ()
  in 
object (self)
  method toString2 =
    fun () ->
      (Java.call "mypack.Test.toString2():java.lang.String" jni_ref)
  method display2 =
    fun () ->
      Java.call "mypack.Test.display2():void" jni_ref
  method _get_jni_jTest = jni_ref
end
and _capsule_jClassTest (jni_ref : _jni_jClassTest) =
  let _ =
    if Java.is_null jni_ref
    then raise (Null_object "mypack/ClassTest")
    else ()
  in
    object (self)
      method display =
        fun () -> Java.call "mypack.ClassTest.display():void" jni_ref
      method toString =
        fun () ->
          JavaString.to_string
            (Java.call "mypack.ClassTest.toString():java.lang.String" jni_ref)
      method _get_jni_jClassTest = jni_ref

end;;
let jTest_of_top (o : top) : jTest =
  new _souche_jTest (Java.cast "mypack.Test" o);;
let jClassTest_of_top (o : top) : jClassTest =
  new _capsule_jClassTest (Java.cast "mypack.ClassTest" o);;
let _instance_of_jTest (o : top) =
  Java.instanceof "mypack.Test" o;;
let _instance_of_jClassTest (o : top) =
  Java.instanceof "mypack.ClassTest" o;;

class proxyTest caml_obj =
  let java_obj = Java.proxy "mypack.Test" caml_obj
  in object (self) inherit _souche_jTest java_obj end;;

class classTest _p0  =
  let _p0 = _p0#_get_jni_jTest
  in let java_obj = Java.make "mypack.ClassTest(mypack.Test)" _p0
    in object (self) inherit _capsule_jClassTest java_obj end;;

