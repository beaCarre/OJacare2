type top;;
type _jni_jModel;;
type _jni_jView;;
type _jni_jController;;
class type jModel = object method _get_jni_jModel : _jni_jModel end
and jView = object method _get_jni_jView : _jni_jView end
and jController = object method _get_jni_jController : _jni_jController end;;
class model : unit -> jModel;;
class view : jModel -> jView;;
class controller : jModel -> jView -> jController;;


