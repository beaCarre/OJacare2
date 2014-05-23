class point (x,y) =
object 
  val mutable x = x
  val mutable y = y
  method get_x = x
  method get_y = y
  method set_x nx = x <- nx
  method set_y ny = y <- ny    
  method to_string () = "( " ^ (string_of_int x) ^ 
                           ", " ^ (string_of_int y) ^ ")"
end
  
  
class colored_point (x,y) c =
object
  inherit point (x,y)
  val mutable c = c
  method get_color = c
  method set_color nc = c <- nc
  method to_string () = "( " ^ (string_of_int x) ^ 
    ", " ^ (string_of_int y) ^ ")" ^
                           " [" ^ c ^ "] "
end 
