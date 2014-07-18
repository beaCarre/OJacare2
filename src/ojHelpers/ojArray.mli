
(** type abstrait 'a t d'encapsulation des tableaux ocamljava *)

type 'a t 

(** type abstrait 'a t d'encapsulation des tableaux ocamljava *)

val get: 'a t -> int -> 'a
val set: 'a t -> int -> 'a -> unit
val length: 'a t -> int

(** Fonctions d'empaquetage des tableaux de reference ocamljava *)

type refA = 
| RefA : 'b java_reference_array -> refA

val pack_reference_array: < .. > t -> refA

(** Fonctions d'encapsulation des tableaux ocamljava *)

val wrap_boolean_array: bool java_boolean_array -> bool t
val wrap_char_array: int java_char_array -> char t
val wrap_byte_array: int java_byte_array -> int t
val wrap_double_array: float java_double_array -> float t
val wrap_float_array: float java_float_array -> float t
val wrap_int_array: int32 java_int_array -> int t
val wrap_long_array: int64 java_long_array -> int t
val wrap_short_array: int java_short_array -> int t
val wrap_string_array: java'lang'String java_instance java_reference_array -> string t
val wrap_reference_array: 'a java_reference_array -> ((< .. > as 'b) -> 'a) -> ('a -> 'b) -> 'b t

(** Fonctions d'encapsulation des tableaux de type 'a t *)

val unwrap_boolean_array: bool t -> bool java_boolean_array
val unwrap_char_array: char t -> int java_char_array
val unwrap_byte_array: int t -> int java_byte_array
val unwrap_double_array: float t -> float java_double_array
val unwrap_float_array: float t -> float java_float_array
val unwrap_int_array: int t -> int32 java_int_array
val unwrap_long_array: int t -> int64 java_long_array  
val unwrap_short_array: int t -> int java_short_array
val unwrap_string_array: string t -> java'lang'String java_instance java_reference_array

(** Fonctions de création de tableaux de type 'a t *)

val _new_boolean_array: int -> bool t
val _new_byte_array: int -> int t
val _new_char_array: int -> char t
val _new_double_array: int -> float t
val _new_float_array: int -> float t
val _new_int_array: int -> int t
val _new_long_array: int -> int t
val _new_short_array: int -> int t
val _new_string_array: int -> string t
