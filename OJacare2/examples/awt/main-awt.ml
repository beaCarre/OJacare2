(*	$Id: main-awt.ml,v 1.1.1.1 2004/03/20 01:40:28 henry Exp $	*)

open Awt;;

let frame = new frame("Greetings from O'Caml !!");;
let button = new button("Click me.");;

frame#add (button :> jComponent);;

class myListener =
  object

    inherit _stub_jActionListener ()

    val first = ref true

    method actionPerformed evt =
      let button = jButton_of_top (evt#getSource ()) in
      if !first then begin
	first := false;
	button#setLabel "and now drink me ? ";
	frame#pack ()
      end else begin
	frame#dispose ();
	print_string "Bye-Bye.";
	print_newline ()
      end
  end;;

button#addActionListener (new myListener :> jActionListener);;

frame#pack ();;
frame#show ();;


