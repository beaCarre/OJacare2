type top;;
type _jni_jClassTest;;
type _jni_jA;;
type _jni_jTest;;

class type jClassTest =
object
    method _get_jni_jClassTest : _jni_jClassTest
    method toString2 : unit -> string
    method display2 : unit -> unit
  end;;

class type jA =
  object
    method _get_jni_jA : _jni_jA
    method toStringA : unit -> string
    method displayA : unit -> unit
  end;;
class type _raw_jTest =
  object
    method toString2 : unit -> string
  end;;

class classTest : unit -> jClassTest;;
class a : jClassTest -> jA;;

class _stub_classTest : _raw_jTest -> jClassTest;;


