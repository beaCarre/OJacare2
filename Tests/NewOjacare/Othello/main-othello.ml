open Othello

let _ =
let model = new model () in
let view = new view model in
new controller model view
