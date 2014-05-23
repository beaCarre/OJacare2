open R;;

class rect_geo_graph p1 p2 = 
object
  inherit rect_geo p1 p2 as super_geo
  inherit rect_graph p1 p2 as super_graph
end;;

let p1 = new point 10 10;;
let p2 = new point 20 20;;

let rgg = new rect_geo_graph p1 p2;;

Printf.printf "aera=%d\n" (rgg#compute_area());;
Printf.printf "perimeter=%d\n" (rgg#compute_perimeter());;
Printf.printf "toString=%s\n" (rgg#toString());;
