type top = java'lang'Object java_instance;;
exception Null_object of string;;
type _jni_jImage = java'awt'Image java_instance;;
type _jni_ml_dvi = mypack'MlDvi java_instance;;
type _jni_jDviFrame = mypack'DviFrame java_instance;;
type _jni_jGrView = mypack'GrView java_instance;;
type _jni_jCamlEvent = mypack'CamlEvent java_instance;;
type _jni_jGrControler = mypack'GrControler java_instance;;
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
class _capsule_jImage (jni_ref : _jni_jImage) =
  let _ =
    if Java.is_null jni_ref then raise (Null_object "java/awt/Image") else ()
  in object (self) method _get_jni_jImage = jni_ref end
and _capsule_ml_dvi (jni_ref : _jni_ml_dvi) =
  let _ =
    if Java.is_null jni_ref then raise (Null_object "mypack/MlDvi") else ()
  in
    object (self)
      method run =
        fun _p0 (_p1 : jGrView) (_p2 : jGrControler) ->
          let _p2 = _p2#_get_jni_jGrControler in
          let _p1 = _p1#_get_jni_jGrView in
          let _p0 = JavaString.of_string _p0
          in
            Java.call
              "mypack.MlDvi.run(java.lang.String,mypack.GrView,mypack.GrControler):void"
              jni_ref _p0 _p1 _p2
      method _get_jni_ml_dvi = jni_ref
    end
and _capsule_jDviFrame (jni_ref : _jni_jDviFrame) =
  let _ =
    if Java.is_null jni_ref
    then raise (Null_object "mypack/DviFrame")
    else ()
  in object (self) method _get_jni_jDviFrame = jni_ref end
and _capsule_jGrView (jni_ref : _jni_jGrView) =
  let _ =
    if Java.is_null jni_ref then raise (Null_object "mypack/GrView") else ()
  in
    object (self)
      method makeImage =
        fun _p0 _p1 _p2 ->
          let _p2 = Int32.of_int _p2 in
          let _p1 = Int32.of_int _p1 in
          let _p0a = JavaIntArray.make (Int32.of_int (Array.length _p0)) in
	  for i=0 to (Array.length _p0)-1 do
	    JavaIntArray.set _p0a (Int32.of_int i) (Int32.of_int _p0.(i))
	  done
          ;
            (new _capsule_jImage
               (Java.call
                  "mypack.GrView.makeImage(int[],int,int):java.awt.Image"
                  jni_ref _p0a _p1 _p2) :
              jImage)
      method drawImage =
        fun (_p0 : jImage) _p1 _p2 ->
          let _p2 = Int32.of_int _p2 in
          let _p1 = Int32.of_int _p1 in
          let _p0 = _p0#_get_jni_jImage
          in
            Java.call "mypack.GrView.drawImage(java.awt.Image,int,int):void"
              jni_ref _p0 _p1 _p2
      method fillRect =
        fun _p0 _p1 _p2 _p3 ->
          let _p3 = Int32.of_int _p3 in
          let _p2 = Int32.of_int _p2 in
          let _p1 = Int32.of_int _p1 in
          let _p0 = Int32.of_int _p0
          in
            Java.call "mypack.GrView.fillRect(int,int,int,int):void" jni_ref
              _p0 _p1 _p2 _p3
      method setColor =
        fun _p0 ->
          let _p0 = Int32.of_int _p0
          in Java.call "mypack.GrView.setColor(int):void" jni_ref _p0
      method close = fun () -> Java.call "mypack.GrView.close():void" jni_ref
      method clear = fun () -> Java.call "mypack.GrView.clear():void" jni_ref
      method init =
        fun _p0 _p1 ->
          let _p1 = Int32.of_int _p1 in
          let _p0 = Int32.of_int _p0
          in Java.call "mypack.GrView.init(int,int):void" jni_ref _p0 _p1
      method set_heightV =
        fun _p ->
          let _p = Int32.of_int _p
          in Java.set "mypack.GrView.heightV:int" jni_ref _p
      method get_heightV =
        fun () -> Int32.to_int (Java.get "mypack.GrView.heightV:int" jni_ref)
      method set_widthV =
        fun _p ->
          let _p = Int32.of_int _p
          in Java.set "mypack.GrView.widthV:int" jni_ref _p
      method get_widthV =
        fun () -> Int32.to_int (Java.get "mypack.GrView.widthV:int" jni_ref)
      method _get_jni_jGrView = jni_ref
    end
and _capsule_jCamlEvent (jni_ref : _jni_jCamlEvent) =
  let _ =
    if Java.is_null jni_ref
    then raise (Null_object "mypack/CamlEvent")
    else ()
  in
    object (self)
      method get_key = fun () -> Java.get "mypack.CamlEvent.key:char" jni_ref
      method get_keypressed =
        fun () -> Java.get "mypack.CamlEvent.keypressed:boolean" jni_ref
      method get_button =
        fun () -> Java.get "mypack.CamlEvent.button:boolean" jni_ref
      method get_mouse_y =
        fun () ->
          Int32.to_int (Java.get "mypack.CamlEvent.mouse_y:int" jni_ref)
      method get_mouse_x =
        fun () ->
          Int32.to_int (Java.get "mypack.CamlEvent.mouse_x:int" jni_ref)
      method _get_jni_jCamlEvent = jni_ref
    end
and _capsule_jGrControler (jni_ref : _jni_jGrControler) =
  let _ =
    if Java.is_null jni_ref
    then raise (Null_object "mypack/GrControler")
    else ()
  in
    object (self)
      method pollNextEvent =
        fun _p0 ->
          let _p0 = Int32.of_int _p0
          in
            (new _capsule_jCamlEvent
               (Java.call
                  "mypack.GrControler.pollNextEvent(int):mypack.CamlEvent"
                  jni_ref _p0) :
              jCamlEvent)
      method waitBlockingNextEvent =
        fun _p0 ->
          let _p0 = Int32.of_int _p0
          in
            (new _capsule_jCamlEvent
               (Java.call
                  "mypack.GrControler.waitBlockingNextEvent(int):mypack.CamlEvent"
                  jni_ref _p0) :
              jCamlEvent)
      method _get_jni_jGrControler = jni_ref
    end;;
let jImage_of_top (o : top) : jImage =
  new _capsule_jImage (Java.cast "java.awt.Image" o);;
let ml_dvi_of_top (o : top) : ml_dvi =
  new _capsule_ml_dvi (Java.cast "mypack.MlDvi" o);;
let jDviFrame_of_top (o : top) : jDviFrame =
  new _capsule_jDviFrame (Java.cast "mypack.DviFrame" o);;
let jGrView_of_top (o : top) : jGrView =
  new _capsule_jGrView (Java.cast "mypack.GrView" o);;
let jCamlEvent_of_top (o : top) : jCamlEvent =
  new _capsule_jCamlEvent (Java.cast "mypack.CamlEvent" o);;
let jGrControler_of_top (o : top) : jGrControler =
  new _capsule_jGrControler (Java.cast "mypack.GrControler" o);;
let _instance_of_jImage (o : top) = Java.instanceof "java.awt.Image" o;;
let _instance_of_ml_dvi (o : top) = Java.instanceof "mypack.MlDvi" o;;
let _instance_of_jDviFrame (o : top) = Java.instanceof "mypack.DviFrame" o;;
let _instance_of_jGrView (o : top) = Java.instanceof "mypack.GrView" o;;
let _instance_of_jCamlEvent (o : top) =
  Java.instanceof "mypack.CamlEvent" o;;
let _instance_of_jGrControler (o : top) =
  Java.instanceof "mypack.GrControler" o;;


let mypack_jDviFrame__main =
    fun (_p0 : ml_dvi) ->
      let _p0 = _p0#_get_jni_ml_dvi
      in Java.call "mypack.DviFrame.main(mypack.MlDvi)" _p0;;

let mypack_jGrView__get_transp =
  fun () -> Int32.to_int (Java.get "mypack.GrView.transp:int" ()) ;;

let mypack_jCamlEvent__get_MOUSE_MOTION_MASK =
  fun () -> Int32.to_int (Java.get "mypack.CamlEvent.MOUSE_MOTION_MASK:int" () );;

let mypack_jCamlEvent__get_BUTTON_UP_MASK =
  fun () -> Int32.to_int (Java.get "mypack.CamlEvent.BUTTON_UP_MASK:int" () );;

let mypack_jCamlEvent__get_BUTTON_DOWN_MASK =
   fun () -> Int32.to_int (Java.get "mypack.CamlEvent.BUTTON_DOWN_MASK:int" ()  );;

let mypack_jCamlEvent__get_KEY_PRESSED_MASK =
   fun () -> Int32.to_int (Java.get "mypack.CamlEvent.KEY_PRESSED_MASK:int" () );;


let jni : mypack'MlDvi java_instance ref = ref Java.null

let mlDvi = Java.proxy "mypack.MlDvi" 
  (
  object
    method _get_jni_ml_dvi = !jni
    method run filename view controler =
      Javadev.set_view view;
      Javadev.set_controler controler;
      View.set_crop !crop_flag;
      View.set_hmargin !hmargin;
      View.set_vmargin !vmargin;
      View.set_geometry !geometry;
      View.main_loop filename 

  end);;
