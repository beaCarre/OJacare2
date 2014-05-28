type top;;
type _jni_jTest;;
type _jni_jClassTest;;
class type _raw_jTest = 
object
  method display2 : unit -> unit
  method toString2 : unit -> string
end
class type jTest =
object
  method _get_jni_jTest : _jni_jTest
  method _stub_display2 : unit -> unit
    method _stub_toString2 : unit -> java'lang'String java_instance
    method display2 : unit -> unit
    method toString2 : unit -> string
end
class type jClassTest =
  object
    method _get_jni_jClassTest : _jni_jClassTest
    method toString3 : unit -> string
    method display3 : unit -> unit
  end;;

class _stub_jTest : _raw_jTest -> jTest

class classTest : jTest -> jClassTest;;




