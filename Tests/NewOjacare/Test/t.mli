type top;;
type _jni_jTest;;
type _jni_jClassTest;;
class type jTest =
  object
    method display2 : unit -> unit
    method toString : unit ->java'lang'String java_instance
    method _get_jni_jTest : _jni_jTest
  end
class type jClassTest =
  object
    method _get_jni_jClassTest : _jni_jClassTest
    method toString : unit -> string
    method display : unit -> unit
  end;;
class classTest : jTest -> jClassTest;;
class stubTest : < display : unit; toString : java'lang'String java_instance >
 -> jTest;;


