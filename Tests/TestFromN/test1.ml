type top = java'lang'Object java_instance;;

type jPoint

class point (this : mypack'Point java_instance) = 
object (self)
  inherit top
  method this'java'lang'Object = (this:>java'lang'Object java_instance)
  method this'mypack'Point = this
  method displayP () = print_endline "point"
end

let p = new point (Java.make "java'lang'Object()" ())

class point_colore (this : mypack'Point java_instance) =
object (self)
  inherit point (this:> mypack'Point java_instance)
  method this'mypack'Point_colore = this
  method displayPC () = print_endline "pc"
end

let _ =
  let p_c = new pc (Java.make "java'lang'String(java.lang.String)" (JavaString.of_string "blop")) in
  p_c#display() ;
  p_c#displayP()
