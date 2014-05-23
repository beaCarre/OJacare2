(* TODO: exceptions, arrays *)

class obj (this : java'lang'Object java_instance) = object (self)
  method this'java'lang'Object = this
  method hashCode = Java.call "java.lang.Object.hashCode()" self#this'java'lang'Object
  method toString = new str (Java.call "java.lang.Object.toString()" self#this'java'lang'Object)
end
and str (this : java'lang'String java_instance) = object (self)
  inherit obj (this :> java'lang'Object java_instance)
  method this'java'lang'String = this
  method length = Java.call "java.lang.String.length()" self#this'java'lang'String
end

let new_obj () = new obj (Java.make "java.lang.Object()" ())

let new_str () = new str (Java.make "java.lang.String()" ())

let print_hash o =
  Printf.printf "hashCode: %ld\n" o#hashCode

let () =
  print_hash (new_obj ());
  print_hash (new_str ())

class num (this : java'lang'Number java_instance) = object (self)
  inherit obj (this :> java'lang'Object java_instance)
  method this'java'lang'Number = this
  method intValue = Java.call "java.lang.Number.intValue()" self#this'java'lang'Number
end

class itg (this : java'lang'Integer java_instance) = object (self)
  inherit num (this :> java'lang'Number java_instance)
  method this'java'lang'Integer = this
  method compareTo (x : itg) =
    Java.call "java.lang.Integer.compareTo(java.lang.Integer)" self#this'java'lang'Integer x#this'java'lang'Integer
end
let new_itg x = new itg (Java.make "java.lang.Integer(int)" x)

class flt (this : java'lang'Float java_instance) = object (self)
  inherit num (this :> java'lang'Number java_instance)
  method this'java'lang'Float = this
end
let new_flt x = new flt (Java.make "java.lang.Float(float)" x)

let print_as_int (n : num) =
  Printf.printf "value: %ld (hash=%ld)\n" n#intValue n#hashCode

let ocaml_string_of_java_string js =
  JavaString.to_string js#this'java'lang'String

let print_num (n : num) =
  let s = n#toString in
  Printf.printf "%s (length=%ld)\n"
    (ocaml_string_of_java_string s)
    s#length

let () =
  let l = [ (new_itg 1l :> num); (new_flt 3.14 :> num) ] in
  List.iter print_as_int l;
  List.iter print_num l

let () =
  let l = [ new_itg (-2l); new_itg (-1l); new_itg 0l; new_itg 5l ] in
  let z = new_itg 0l in
  List.iter
    (fun x ->
      Printf.printf "comparing %S and %S\t->\t%ld\n"
	(ocaml_string_of_java_string z#toString)
	(ocaml_string_of_java_string x#toString)
	(z#compareTo x))
    l
