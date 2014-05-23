type top = java'lang'Object java_instance;;
exception Null_object of string;;
type _jni_jFrameDB = mypack'FrameDB java_instance;;
class type jFrameDB =
  object method _get_jni_jFrameDB : _jni_jFrameDB end;;
class _capsule_jFrameDB (jni_ref : _jni_jFrameDB) =
  let _ =
    if Java.is_null jni_ref
    then raise (Null_object "mypack/FrameDB")
    else ()
  in object (self) method _get_jni_jFrameDB = jni_ref end;;
let jFrameDB_of_top (o : top) : jFrameDB =
  new _capsule_jFrameDB (Java.cast "mypack.FrameDB" o);;
let _instance_of_jFrameDB (o : top) =
  Java.instanceof "mypack.FrameDB" o;;

let getJarray _p1  =
  let _p1a = Java.make_array "java.lang.String[]" (Int32.of_int (Array.length _p1)) in
  for i=0 to ((Array.length _p1)-1) do
    JavaReferenceArray.set _p1a (Int32.of_int i) (JavaString.of_string _p1.(i))
  done;
  _p1a
let get_array_array _p2 =
  let _p2a =
    Java.make_array "java.lang.String[][]" (Int32.of_int( Array.length _p2))  (Int32.of_int( Array.length _p2.(0))) in
  for i=0 to ((Array.length _p2)-1) do
    for j=0 to (Array.length _p2.(0))-1 do
      JavaReferenceArray.set (JavaReferenceArray.get _p2a (Int32.of_int i)) (Int32.of_int j) (JavaString.of_string _p2.(i).(j))
    done
  done;
  _p2a

class frameDB _p0 _p1 _p2 =
  let _p2a =  get_array_array _p2 in
  let _p1a = getJarray _p1 in
  
  let _p0 = JavaString.of_string _p0
      in
        let java_obj =
          Java.make
            "mypack.FrameDB(java.lang.String,java.lang.String[],java.lang.String[][])"
            _p0 _p1a _p2a
        in object (self) inherit _capsule_jFrameDB java_obj end;;


