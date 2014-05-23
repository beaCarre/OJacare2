type top;;
type _jni_jImage;;
type _jni_ml_dvi;;
type _jni_jDviFrame;;
type _jni_jGrView;;
type _jni_jCamlEvent;;
type _jni_jGrControler;;
class type jImage = object method _get_jni_jImage : _jni_jImage end
and ml_dvi =
  object
    method _get_jni_ml_dvi : _jni_ml_dvi
    method run : string -> jGrView -> jGrControler -> unit
  end
and jDviFrame = object method _get_jni_jDviFrame : _jni_jDviFrame end
and jGrView =
  object
    method _get_jni_jGrView : _jni_jGrView
    method set_widthV : int -> unit
    method get_widthV : unit -> int
    method set_heightV : int -> unit
    method get_heightV : unit -> int
    method init : int -> int -> unit
    method clear : unit -> unit
    method close : unit -> unit
    method setColor : int -> unit
    method fillRect : int -> int -> int -> int -> unit
    method drawImage : jImage -> int -> int -> unit
    method makeImage : int array -> int -> int -> jImage
  end
and jCamlEvent =
  object
    method _get_jni_jCamlEvent : _jni_jCamlEvent
    method get_mouse_x : unit -> int
    method get_mouse_y : unit -> int
    method get_button : unit -> bool
    method get_keypressed : unit -> bool
    method get_key : unit -> int
  end
and jGrControler =
  object
    method _get_jni_jGrControler : _jni_jGrControler
    method waitBlockingNextEvent : int -> jCamlEvent
    method pollNextEvent : int -> jCamlEvent
  end;;


val mypack_jDviFrame__main : ml_dvi -> unit;;
val mypack_jGrView__get_transp : unit -> int;;
val mypack_jCamlEvent__get_MOUSE_MOTION_MASK : unit -> int;;
val mypack_jCamlEvent__get_BUTTON_UP_MASK : unit -> int;;
val mypack_jCamlEvent__get_BUTTON_DOWN_MASK : unit -> int;;
val mypack_jCamlEvent__get_KEY_PRESSED_MASK : unit -> int;;
