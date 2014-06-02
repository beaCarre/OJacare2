type top = java'lang'Object java_instance;;
exception Null_object of string;;
type _jni_jTest = mypack'Test java_instance;;
type _jni_jClassTest = mypack'ClassTest java_instance;;


class type jTest =
object
    method display2 : unit -> unit
    method toString2 : unit -> string
    method _get_jni_jTest : _jni_jTest
end
and jClassTest =
  object
    method _get_jni_jClassTest : _jni_jClassTest
    method toString3 : unit -> string
    method display3 : unit -> unit
  end;;

class virtual _souche_jTest  =
  let jni_ref = ref Java.null in
object (self) 
  initializer
    jni_ref := 
    Java.proxy "mypack.Test"
      (
      object
	method toString2 =
	  JavaString.of_string (self#toString2())
	method display2 =
          self#display2()
      end
      ) 
  method virtual toString2 : unit -> string
  method virtual display2 : unit -> unit
  method _get_jni_jTest = (!jni_ref:_jni_jTest)
end


and _capsule_jClassTest (jni_ref : _jni_jClassTest) =
  let _ =
    if Java.is_null jni_ref
    then raise (Null_object "mypack/ClassTest")
    else ()
  in
    object (self)
      method display3 =
        fun () -> Java.call "mypack.ClassTest.display3():void" jni_ref
      method toString3 =
        fun () ->
          JavaString.to_string
            (Java.call "mypack.ClassTest.toString3():java.lang.String" jni_ref)
      method _get_jni_jClassTest = jni_ref

end;;

let jClassTest_of_top (o : top) : jClassTest =
  new _capsule_jClassTest (Java.cast "mypack.ClassTest" o);;
let _instance_of_jTest (o : top) =
  Java.instanceof "mypack.Test" o;;
let _instance_of_jClassTest (o : top) =
  Java.instanceof "mypack.ClassTest" o;;

class virtual _stub_jTest = 
object (self)
  inherit _souche_jTest 
end

class classTest _p0  =
  let _p0 = _p0#_get_jni_jTest
  in let java_obj = Java.make "mypack.ClassTest(mypack.Test)" _p0
    in object (self) inherit _capsule_jClassTest java_obj end;;

