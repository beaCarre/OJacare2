type top = java'lang'Object java_instance;;
exception Null_object of string;;
type _jni_jTest = mypack'Test java_instance;;
type _jni_jA = mypack'A java_instance;;
type _jni_jClassTest = mypack'ClassTest java_instance;;
type _jni_jCB_ClassTest = mypack'CB_ClassTest java_instance;;

class type jClassTest =
object
    method _get_jni_jClassTest : _jni_jClassTest
    method toString2 : unit -> string
    method display2 : unit -> unit
end
and jA =
  object
    method _get_jni_jA : _jni_jA
    method toStringA : unit -> string
    method displayA : unit -> unit
  end

class _souche_jClassTest  =
  let jni_ref_proxy = ref Java.null in 
  let jni_ref = ref Java.null  in
object (self)
  initializer  
    jni_ref_proxy :=
    Java.proxy "mypack.Test" (
      object
	method toString2 =
	    JavaString.of_string (self#toString2())
      end
    );
      jni_ref := Java.make "mypack.CB_ClassTest(mypack.Test)" (!jni_ref_proxy:_jni_jTest) ;
      if Java.is_null !jni_ref_proxy
    then raise (Null_object "mypack/Test")
    else
      if Java.is_null !jni_ref
      then raise (Null_object "mypack/ClassTest")
      else ()
  method toString2 = 
     fun () ->
       JavaString.to_string
       (Java.call "mypack.CB_ClassTest._stub_toString2():java.lang.String" (!jni_ref:_jni_jCB_ClassTest))
 method display2 =
    fun () ->
      Java.call "mypack.CB_ClassTest.display2():void" (!jni_ref:_jni_jCB_ClassTest)
 method _get_jni_jClassTest = (!jni_ref :> _jni_jClassTest) 
end


and _capsule_jClassTest (jni_ref : _jni_jClassTest) =
  let _ =
    if Java.is_null jni_ref
    then raise (Null_object "mypack/ClassTest")
    else ()
  in
    object (self)
      method display2 =
        fun () -> Java.call "mypack.ClassTest.display2():void" jni_ref
      method toString2 =
        fun () ->
          JavaString.to_string
            (Java.call "mypack.ClassTest.toString2():java.lang.String" jni_ref)
      method _get_jni_jClassTest = jni_ref
    end
and _capsule_jA (jni_ref : _jni_jA) =
  let _ =
    if Java.is_null jni_ref
    then raise (Null_object "mypack/A")
    else ()
  in
    object (self)
      method displayA =
        fun () -> Java.call "mypack.A.displayA():void" jni_ref
      method toStringA =
        fun () ->
          JavaString.to_string
            (Java.call "mypack.A.toStringA():java.lang.String" jni_ref)
      method _get_jni_jA = jni_ref

end;;


let jA_of_top (o : top) : jA =
  new _capsule_jA (Java.cast "mypack.A" o);;
let _instance_of_jClassTest (o : top) =
  Java.instanceof "mypack.ClassTest" o;;
let _instance_of_jA (o : top) =
  Java.instanceof "mypack.A" o;;

class _stub_classTest () =
  object (self) inherit _souche_jClassTest  end;;

class a _p0  =
  let _p0 = _p0#_get_jni_jClassTest
  in let java_obj = Java.make "mypack.A(mypack.ClassTest)" _p0
    in object (self) inherit _capsule_jA java_obj end;;

class classTest () =
  let java_obj = Java.make "mypack.ClassTest()" ()
    in object (self) inherit _capsule_jClassTest java_obj end;;
