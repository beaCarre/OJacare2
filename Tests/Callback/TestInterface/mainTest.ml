open T
  
let test = new _stub_jTest  
  (
  object(self)
    method toString2 () =
      "CAMLBLOP"
    method display2 () =
      print_endline (self#toString2())
  end)
  
let classtest= new classTest test
      
let _ =
  test#display2();
  classtest#display3();
 
