(*   $Id: javadev.ml,v 1.1 2003/10/22 18:14:56 henry Exp $    *)

open JGraphics

type color = int ;;
let transp = mypack_jGrView__get_transp () ;;

let view = ref (None : jGrView option);;
let set_view v =
  view := Some v

let controler = ref (None : jGrControler option);;
let set_controler c =
  controler := Some c

(*** Private glyphs ***)

type cache =
  | No_cache
  | Cached of color * jImage ;;

type glyph = {
    width : int ;
    height : int ;
    hoffset : int ;
    voffset : int ;
    graymap : string ;
    mutable cache : cache ;
    mutable img_list : (color * jImage) list
  } ;;

let get_color_table =
  let htable = Hashtbl.create 257 in
  function col ->
    try Hashtbl.find htable col
    with Not_found ->
      let col' = col in
      let table = Array.make 256 transp
      and r0 = (col' lsr 16) land 0xff
      and g0 = (col' lsr 8) land 0xff
      and b0 = col' land 0xff in
      for i = 1 to 255 do
 	let k = (255 - i)*255 in
	let r = (k + i*r0)/255
	and g = (k + i*g0)/255
	and b = (k + i*b0)/255 in
	(* FIXME : gestion des couleurs : ici ont mets alpha, et pas ailleurs. *)
	table.(i) <- ((255 lsl 24) +(r lsl 16) + (g lsl 8) + b)
      done ;
      Hashtbl.add htable col table ;
      table ;;

let get_image g col =
  match g.cache with
  | Cached(c, img) when c = col -> img
  | _ ->
      match !view with
	None -> failwith "get_image"
      | Some canvas ->
	  let img =
	    try List.assoc col g.img_list
	    with Not_found ->
	      let gmap = g.graymap
	      and w = g.width
	      and h = g.height in
              (* We enforce [h <> 0] and [w <> 0] because
		 Caml graphics don't like zero-sized pixmaps. *)
	      let dst = Array.make ((max 1 w)*(max 1 h)) 0
	      and table = get_color_table col
	      and p = ref 0 in
	      for i = 0 to h - 1 do
		for j = 0 to w - 1 do
		  dst.(i*w+j) <- table.(Char.code gmap.[!p]);
		  incr p
		done
	      done ;
	      let img = canvas#makeImage dst w h in
	      g.img_list <- (col, img) :: g.img_list ;
	      img in
	  g.cache <- Cached(col, img) ;
	  img ;;

let make_glyph g =
  { width = g.Glyph.width ;
    height = g.Glyph.height ;
    hoffset = g.Glyph.hoffset ;
    voffset = g.Glyph.voffset ;
    graymap = g.Glyph.graymap ;
    cache = No_cache ;
    img_list = [] } ;;

(*** Device configuration ***)

let xmin = ref 0 ;;
let xmax = ref 0 ;;
let ymin = ref 0 ;;
let ymax = ref 0 ;;
    
let size_x = ref 0;;
let size_y = ref 0;;

let close_dev () =
  view := None;;

let open_dev geom =
  match !view with
  | None -> failwith "Javadev.open_dev: view not set" 
  | Some canvas -> 
      (try Scanf.sscanf geom " %dx%d" (fun width height -> canvas#init width height)
      with _ -> canvas#init 400 600);
      size_x := canvas#get_widthV ();
      size_y := canvas#get_heightV ();  
      xmin := 0 ; xmax := !size_x;
      ymin := 0 ; ymax := !size_y;
;;

let clear_dev () =  
  match !view with
  | None -> failwith "Javadev.clear_dev: view not set" 
  | Some canvas -> 
      canvas#clear ()
;;

let set_bbox bbox =
  match !view with 
  | None ->
      failwith "Javadev.set_bbox: view not set" 
  | Some _ ->
      match bbox with
      | None ->
	  xmin := 0 ; xmax := !size_x ;
	  ymin := 0 ; ymax := !size_y
      | Some(x0, y0, w, h) ->
	  xmin := x0 ; xmax := x0 + w ;
	  ymin := !size_y - (y0 + h) ; ymax := !size_y - y0 
;;

(*** Drawing ***)

let color = ref 0

let set_color col =
  match !view with 
  | None -> failwith "Javadev.set_color: view not set" 
  | Some canvas -> canvas#setColor col; color := col
;;    

let draw_glyph g x0 y0 =
  match !view with 
  | None -> failwith "Javadev.draw_glyph: view not set"
  | Some canvas -> 
      let w = g.width
      and h = g.height in
      let x = x0 - g.hoffset
      and y = !size_y - y0 + g.voffset - h in
      if x + w > !xmin && x < !xmax && y + h > !ymin && y < !ymax then 
	let img = get_image g !color in
	canvas#drawImage img x y
;; 
 
let fill_rect x0 y0 w h =
   match !view with 
   | None -> failwith "Javadev.fill_rect: view not set" 
   | Some canvas -> 
       let x = x0
       and y = !size_y - y0 - h in
       let x' = x + w
       and y' = y + h in
       (* clipping *)
       let x = max !xmin x
       and y = max !ymin y
       and x' = min x' !xmax
       and y' = min y' !ymax in
       let w = x' - x
       and h = y' - y in
       if w > 0 && h > 0 then 
	 canvas#fillRect x y w h 
;;
      
(* Events *)
   

type event =
  | Button_down
  | Button_up
  | Key_pressed
  | Mouse_motion
  | Poll ;;

type status = {
    mouse_x : int ;
    mouse_y : int ;
    button : bool ;
    keypressed : bool ;
    key : char
  } ;;

open Int32 ;;

let key_mask = mypack_jCamlEvent__get_KEY_PRESSED_MASK ();;
let mouse_motion_mask = mypack_jCamlEvent__get_MOUSE_MOTION_MASK ();;
let button_up_mask = mypack_jCamlEvent__get_BUTTON_UP_MASK ();;
let button_down_mask = mypack_jCamlEvent__get_BUTTON_DOWN_MASK ();;

let convert_mask evt = match evt with
| Button_down ->  button_down_mask
| Button_up -> button_up_mask
| Key_pressed -> key_mask
| Mouse_motion -> mouse_motion_mask
| Poll -> 0;;

let convert_event evt =
  {
    mouse_x = evt#get_mouse_x ();
    mouse_y = evt#get_mouse_y ();
    button = evt#get_button ();
    keypressed = evt#get_keypressed (); 
    key = char_of_int (evt#get_key ());
  } 

let wait_next_event kinds =
  match !controler with 
  | None -> failwith "Javadev.wait_next_event: controler not set" 
  | Some controler -> 
      let mask = List.fold_right (fun evt mask -> (convert_mask evt) lor mask) kinds 0 in
      convert_event 
	(if List.mem Poll kinds then
	  controler#pollNextEvent mask
	else
	  controler#waitBlockingNextEvent mask)
