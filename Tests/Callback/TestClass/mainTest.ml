open T


class impltest = 

object(self)
  inherit _stub_classTest () as super
  method toString2  () = "new_"^super#toString2()
end

let test = new impltest

let a = new a test
      
let _ =
  print_endline ".";
  test#display2(); 
  print_endline ".";
  print_endline (test#toString2());
  print_endline ".";
  print_endline ( a#toStringA());
  print_endline ".";
  a#displayA()
