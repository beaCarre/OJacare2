type top;;
type _jni_jFrameDB;;
class type jFrameDB =
  object method _get_jni_jFrameDB : _jni_jFrameDB end;;
class frameDB : string -> string array -> string array array -> jFrameDB;;


