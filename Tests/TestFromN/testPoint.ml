open Package'java'lang

class abstractpoint (this : java'lang'Object java_instance) = 
object (self)
  method this_object = this
  method this = self
end
 
class point (x : int) (y : int) (this : java'lang'Object java_instance) =
object (self)
  inherit abstractpoint (this) as super
  val mutable x = x
  val mutable y = y
  method get_x = Java.call "get" super
end 

let p = new point 1 2 (Java.make "java'lang'Object()" ())

let () = print_endline ("pouet"^ (string_of_int p#get_sum))
