type top = java'lang'Object java_instance;;
exception Null_object of string;;
type _jni_jModel = src'Model java_instance;;
type _jni_jView = src'View java_instance;;
type _jni_jController = src'Controller java_instance;;
class type jModel = object method _get_jni_jModel : _jni_jModel end
and jView = object method _get_jni_jView : _jni_jView end
and jController = object method _get_jni_jController : _jni_jController end;;
class _capsule_jModel (jni_ref : _jni_jModel) =
  let _ =
    if Java.is_null jni_ref then raise (Null_object "src/Model") else ()
  in object (self) method _get_jni_jModel = jni_ref end
and _capsule_jView (jni_ref : _jni_jView) =
  let _ = if Java.is_null jni_ref then raise (Null_object "src/View") else ()
  in object (self) method _get_jni_jView = jni_ref end
and _capsule_jController (jni_ref : _jni_jController) =
  let _ =
    if Java.is_null jni_ref then raise (Null_object "src/Controller") else ()
  in object (self) method _get_jni_jController = jni_ref end;;
let jModel_of_top (o : top) : jModel =
  new _capsule_jModel (Java.cast "src.Model" o);;
let jView_of_top (o : top) : jView =
  new _capsule_jView (Java.cast "src.View" o);;
let jController_of_top (o : top) : jController =
  new _capsule_jController (Java.cast "src.Controller" o);;
let _instance_of_jModel (o : top) = Java.instanceof "src.Model" o;;
let _instance_of_jView (o : top) = Java.instanceof "src.View" o;;
let _instance_of_jController (o : top) = Java.instanceof "src.Controller" o;;
class model () =
  let java_obj = Java.make "src.Model()" ()
  in object (self) inherit _capsule_jModel java_obj end;;
class view _p0 =
  let _p0 = _p0#_get_jni_jModel
  in let java_obj = Java.make "src.View(src.Model)" _p0
    in object (self) inherit _capsule_jView java_obj end;;
class controller _p0 _p1 =
  let _p1 = _p1#_get_jni_jView
  in let _p0 = _p0#_get_jni_jModel
    in let java_obj = Java.make "src.Controller(src.Model,src.View)" _p0 _p1
      in object (self) inherit _capsule_jController java_obj end;;


