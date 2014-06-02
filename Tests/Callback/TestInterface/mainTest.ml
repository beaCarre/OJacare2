open T
  
class mltest =
  object(self)
    inherit _stub_jTest as super
    method toString2 () =
      "CAMLBLOP"
    method display2 () =
      print_endline ("self#toString :"^self#toString2())
  end

let test = new mltest 
  
let classtest= new classTest test
      
let _ =
  test#display2();
  print_endline ".";
  classtest#display3();
 
