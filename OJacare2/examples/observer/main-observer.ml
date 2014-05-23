open Observer

class ml_observer name = 
   object (self)

     inherit _stub_jObserver ()

     method update s =
       let s = jConcreteSubject_of_top (s :> JniHierarchy.top) in
       let data = s#getState () in
       Printf.printf "ml_observer %s (%s) -> x = %d ; y = %f"
	 name (s#toString ()) (data#get_x ()) (data#get_y ());
       print_newline () (* flush *)

   end

class ml_main = 
  object
    inherit _stub_jMlMain ()
    method createObserver name = ((new ml_observer name) :> jObserver)
  end

let _ = 
  let argv = 
    JniArray.init_string_jArray (Array.length Sys.argv) (fun i -> Sys.argv.(i)) 
  and mlMain = ((new ml_main) :> jMlMain)
  in
  mypack_jJavaMain__main argv mlMain
