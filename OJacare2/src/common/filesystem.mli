(*	$Id: filesystem.mli,v 1.1.1.1 2003/10/19 22:57:41 henry Exp $	*)

val safe_open_out: string list -> string -> out_channel
(** {safe_open_out dir name} ouvre le fichier {name} dans le dossier {dir}, en créant la hiérarchie si nécessaire *)
