(* Top *)
class type jTop =
object
  method _get_jniobj : Jni.obj
end

class top (java_obj:Jni.obj) =
object
    method _get_jniobj = java_obj
end

exception Null_object of string
