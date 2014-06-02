type top;;
type _jni_jTest;;
type _jni_jClassTest;;

class type jTest =
object
  method _get_jni_jTest : _jni_jTest
    method display2 : unit -> unit
    method toString2 : unit -> string
end
class type jClassTest =
  object
    method _get_jni_jClassTest : _jni_jClassTest
    method toString3 : unit -> string
    method display3 : unit -> unit
  end;;

class virtual _stub_jTest : 
object
  method _get_jni_jTest : _jni_jTest
    method virtual display2 : unit -> unit
    method virtual toString2 : unit -> string
end

class classTest : jTest -> jClassTest;;




