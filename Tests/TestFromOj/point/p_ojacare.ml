type _jni_jPoint = Jni.obj;;
class type jPoint =
  object
    inherit JniHierarchy.top
    method _get_jni_jPoint : _jni_jPoint
    method set_x : int -> unit
    method get_x : unit -> int
    method set_y : jPoint -> unit
    method get_y : unit -> jPoint
      
    method moveto : int -> int -> unit
    method rmoveto : int -> int -> unit
    method toString : unit -> string
    method display : unit -> unit
    method distance : unit -> float
    method eq : jPoint -> bool
  end;;
let __jni_obj_of_jni_jPoint (java_obj : _jni_jPoint) =
  (Obj.magic : _jni_jPoint -> Jni.obj) java_obj;;
let __jni_jPoint_of_jni_obj =
  let clazz =
    try Jni.find_class "mypack/Point"
    with | _ -> failwith "Class not found : mypack.Point."
  in
    fun (java_obj : Jni.obj) ->
      if not (Jni.is_instance_of java_obj clazz)
      then failwith "``cast error'' : jPoint (mypack/Point)"
      else (Obj.magic java_obj : _jni_jPoint);;
let _alloc_jPoint =
  let clazz = Jni.find_class "mypack/Point"
  in fun () -> (Jni.alloc_object clazz : _jni_jPoint);;

class _capsule_jPoint =
  let clazz = Jni.find_class "mypack/Point"
  in
    let __mid_eq =
      try Jni.get_methodID clazz "eq" "(Lmypack/Point;)Z"
      with
      | _ ->
          failwith
            "Unknown method from IDL in class \"mypack.Point\" : \"boolean eq(mypack.Point)\"."
    in
      let __mid_distance =
        try Jni.get_methodID clazz "distance" "()D"
        with
        | _ ->
            failwith
              "Unknown method from IDL in class \"mypack.Point\" : \"double distance()\"."
      in
        let __mid_display =
          try Jni.get_methodID clazz "display" "()V"
          with
          | _ ->
              failwith
                "Unknown method from IDL in class \"mypack.Point\" : \"void display()\"."
        in
          let __mid_toString =
            try Jni.get_methodID clazz "toString" "()Ljava/lang/String;"
            with
            | _ ->
                failwith
                  "Unknown method from IDL in class \"mypack.Point\" : \"string toString()\"."
          in
            let __mid_rmoveto =
              try Jni.get_methodID clazz "rmoveto" "(II)V"
              with
              | _ ->
                  failwith
                    "Unknown method from IDL in class \"mypack.Point\" : \"void rmoveto(int,int)\"."
            in
              let __mid_moveto =
                try Jni.get_methodID clazz "moveto" "(II)V"
                with
                | _ ->
                    failwith
                      "Unknown method from IDL in class \"mypack.Point\" : \"void moveto(int,int)\"."
              in
                let __fid_y =
                  try Jni.get_fieldID clazz "y" "I"
                  with
                  | _ ->
                      failwith
                        "Unknown field from IDL in class \"mypack.Point\" : \"int y\"."
                in
                  let __fid_x =
                    try Jni.get_fieldID clazz "x" "I"
                    with
                    | _ ->
                        failwith
                          "Unknown field from IDL in class \"mypack.Point\" : \"int x\"."
                  in
                    fun (jni_ref : _jni_jPoint) ->
                      let _ =
                        if Jni.is_null jni_ref
                        then raise (JniHierarchy.Null_object "mypack/Point")
                        else ()
                      in
                        object (self)
                          method eq =
                            fun (_p0 : jPoint) ->
                              let _p0 = _p0#_get_jni_jPoint
                              in
                                Jni.call_boolean_method jni_ref __mid_eq
                                  [| Jni.Obj _p0 |]
                          method distance =
                            fun () ->
                              Jni.call_double_method jni_ref __mid_distance
                                [|  |]
                          method display =
                            fun () ->
                              Jni.call_void_method jni_ref __mid_display
                                [|  |]
                          method toString =
                            fun () ->
                              Jni.string_from_java
                                (Jni.call_object_method jni_ref
                                   __mid_toString [|  |])
                          method rmoveto =
                            fun _p0 _p1 ->
                              let _p1 = _p1 in
                              let _p0 = _p0
                              in
                                Jni.call_void_method jni_ref __mid_rmoveto
                                  [| Jni.Camlint _p0; Jni.Camlint _p1 |]
                          method moveto =
                            fun _p0 _p1 ->
                              let _p1 = _p1 in
                              let _p0 = _p0
                              in
                                Jni.call_void_method jni_ref __mid_moveto
                                  [| Jni.Camlint _p0; Jni.Camlint _p1 |]
                          method set_y =
                            fun (_p : jPoint) ->
                              let _p = _p
                              in Jni.set_camlint_field jni_ref __fid_y _p
                          method get_y =
                            fun () -> Jni.get_camlint_field jni_ref __fid_y
                          method set_x =
                            fun _p ->
                              let _p = _p
                              in Jni.set_camlint_field jni_ref __fid_x _p
                          method get_x =
                            fun () -> Jni.get_camlint_field jni_ref __fid_x
                          method _get_jni_jPoint = jni_ref
                          inherit JniHierarchy.top jni_ref
                        end;;
let jPoint_of_top (o : JniHierarchy.top) : jPoint =
  new _capsule_jPoint (__jni_jPoint_of_jni_obj o#_get_jniobj);;
let _instance_of_jPoint =
  let clazz = Jni.find_class "mypack/Point"
  in fun (o : JniHierarchy.top) -> Jni.is_instance_of o#_get_jniobj clazz;;
let _new_jArray_jPoint size =
  let java_obj = Jni.new_object_array size (Jni.find_class "mypack/Point")
  in
    new JniArray._Array Jni.get_object_array_element Jni.
      set_object_array_element (fun jniobj -> new _capsule_jPoint jniobj)
      (fun obj -> obj#_get_jni_jPoint) java_obj;;
let jArray_init_jPoint size f =
  let a = _new_jArray_jPoint size
  in (for i = 0 to pred size do a#set i (f i) done; a);;
let _init_point =
  let clazz = Jni.find_class "mypack/Point" in
  let id =
    try Jni.get_methodID clazz "<init>" "(II)V"
    with
    | _ ->
        failwith
          "Unknown constructor from IDL in class \"mypack.Point\" : \"Point(int,int)\"."
  in
    fun (java_obj : _jni_jPoint) _p0 _p1 ->
      let _p1 = _p1 in
      let _p0 = _p0
      in
        Jni.call_nonvirtual_void_method java_obj clazz id
          [| Jni.Camlint _p0; Jni.Camlint _p1 |];;
let _init_default_point =
  let clazz = Jni.find_class "mypack/Point" in
  let id =
    try Jni.get_methodID clazz "<init>" "()V"
    with
    | _ ->
        failwith
          "Unknown constructor from IDL in class \"mypack.Point\" : \"Point()\"."
  in
    fun (java_obj : _jni_jPoint) ->
      Jni.call_nonvirtual_void_method java_obj clazz id [|  |];;

class point _p0 _p1 =
  let java_obj = _alloc_jPoint ()
  in let _ = _init_point java_obj _p0 _p1
    in object (self) inherit _capsule_jPoint java_obj end;;
class default_point () =
  let java_obj = _alloc_jPoint ()
  in let _ = _init_default_point java_obj
    in object (self) inherit _capsule_jPoint java_obj end;;

let mypack_jPoint__main =
  let clazz = Jni.find_class "mypack/Point" in
  let id =
    try Jni.get_static_methodID clazz "main" "([Ljava/lang/String;)V"
    with
    | _ ->
        failwith
          "Unknown static method from IDL in class \"mypack.Point\" : \"void main(string[])\"."
  in
    fun (_p0 : string JniArray.jArray) ->
      let _p0 = _p0#_get_jniobj
      in Jni.call_static_void_method clazz id [| Jni.Obj _p0 |];;
