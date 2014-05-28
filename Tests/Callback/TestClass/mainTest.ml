open T
  
let test = new _stub_classTest (
object(self)
  method toString2  () =
    "CAMLBLOP"
end)


let a = new a test
      
let _ =
  print_endline (test#toString2());

  test#display2(); 

  a#toStringA();
    
  a#displayA()
