open T

let _ =

  let  test =
    (
      object(self)
        inherit classTest() as super
	method toString =
	  JavaString.of_string ("blop"^super#toString)
	method display  =
	  print_endline ((self#toString()))
      end
      )
  in
  let java_obj = Java.proxy "mypack.Test" test in
  Java.call "mypack.Test.display()" java_obj
