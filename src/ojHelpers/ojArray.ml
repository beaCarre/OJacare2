


type _ t = 
| Boolean_array : bool java_boolean_array -> bool t
| Byte_array : int java_byte_array -> int t
| Char_array : int java_char_array -> char t
| Double_array : float java_double_array -> float t
| Float_array : float java_float_array ->  float t
| Int_array : int32 java_int_array -> int t
| Long_array : int64 java_long_array -> int t
| Short_array : int java_short_array -> int t
| String_array : java'lang'String java_instance java_reference_array -> string t
| Reference_array : ('a java_reference_array * ((< .. > as 'b) -> 'a) * ('a -> 'b)) -> 'b t

type refA =
| RefA : 'a java_reference_array -> refA
	       
let pack_reference_array (Reference_array (r,_,_) : < .. > t) = RefA r
				 

let wrap_boolean_array a = 
  Boolean_array a
let wrap_byte_array a = 
  Byte_array a
let wrap_char_array a = 
  Char_array a
let wrap_double_array a = 
  Double_array a
let wrap_float_array a = 
  Float_array a
let wrap_int_array a = 
  Int_array a
let wrap_long_array a = 
  Long_array a
let wrap_short_array a = 
  Short_array a
let wrap_string_array a = 
  String_array a
let wrap_reference_array a unwrap wrap = 
  Reference_array (a, unwrap, wrap)


let unwrap_boolean_array (a: bool t) =
  match a with 
  | Boolean_array r -> r
let unwrap_byte_array (a: int t) =
  match a with 
  | Byte_array r -> r
  | Short_array _ -> invalid_arg "unwrap_byte_array : short array !"
  | Int_array _ -> invalid_arg "unwrap_byte_array : int array !" 
  | Long_array _ -> invalid_arg "unwrap_byte_array : long array !"
let unwrap_char_array (a: char t) =
  match a with 
  | Char_array r -> r
let unwrap_double_array (a: float t) =
  match a with 
  | Double_array r -> r 
  | Float_array _ -> invalid_arg "unwrap_double_array : float array !"
let unwrap_float_array (a: float t) =
  match a with 
  | Float_array r -> r 
  | Double_array _ -> invalid_arg "unwrap_float_array : double array !"
let unwrap_int_array (a: int t) =
  match a with 
  | Int_array r -> r  
  | Byte_array _ -> invalid_arg "unwrap_int_array : byte array !" 
  | Short_array _ -> invalid_arg "unwrap_int_array : short array !" 
  | Long_array _ -> invalid_arg "unwrap_int_array : long array !"
let unwrap_long_array (a: int t) =
  match a with 
  | Long_array r -> r
  | Byte_array _ -> invalid_arg "unwrap_long_array : byte array !"
  | Short_array _ -> invalid_arg "unwrap_long_array : short array !" 
  | Int_array _ -> invalid_arg "unwrap_long_array : int array !"
let unwrap_short_array (a: int t)=
  match a with 
  | Short_array r -> r
  | Byte_array _ -> invalid_arg "unwrap_short_array : byte array !" 
  | Int_array _ -> invalid_arg "unwrap_short_array : int array !" 
  | Long_array _ -> invalid_arg "unwrap_short_array : long array !"
let unwrap_string_array (a: string t)=
  match a with 
  | String_array r -> r

let _new_boolean_array size =
  let java_obj = Java.make_array "boolean[]" (Int32.of_int size) in 
  wrap_boolean_array java_obj
let _new_byte_array size =
  let java_obj = Java.make_array "byte[]" (Int32.of_int size) in 
  wrap_byte_array java_obj
let _new_char_array size =
  let java_obj = Java.make_array "char[]" (Int32.of_int size) in 
  wrap_char_array java_obj
let _new_double_array size =
  let java_obj = Java.make_array "double[]" (Int32.of_int size) in 
  wrap_double_array java_obj
let _new_float_array size =
  let java_obj = Java.make_array "float[]" (Int32.of_int size) in 
  wrap_float_array java_obj
let _new_int_array size =
  let java_obj = Java.make_array "int[]" (Int32.of_int size) in 
  wrap_int_array java_obj
let _new_long_array size =
  let java_obj = Java.make_array "long[]" (Int32.of_int size) in 
  wrap_long_array java_obj
let _new_short_array size =
  let java_obj = Java.make_array "short[]" (Int32.of_int size) in 
  wrap_short_array java_obj
let _new_string_array size =
  let java_obj = Java.make_array "java.lang.String[]" (Int32.of_int size) in 
  wrap_string_array java_obj

let get : type e. e t -> int -> e = fun a i ->
  match a with
  | Boolean_array a -> JavaBooleanArray.get a (Int32.of_int i)
  | Byte_array a -> JavaByteArray.get a (Int32.of_int i)
  | Char_array a -> Char.chr (JavaCharArray.get a (Int32.of_int i))
  | Double_array a -> JavaDoubleArray.get a (Int32.of_int i)
  | Float_array a -> JavaFloatArray.get a (Int32.of_int i)
  | Int_array a -> Int32.to_int (JavaIntArray.get a (Int32.of_int i))
  | Long_array a -> Int64.to_int (JavaLongArray.get a (Int32.of_int i))
  | Short_array a -> JavaShortArray.get a (Int32.of_int i)
  | String_array a -> JavaString.to_string (JavaReferenceArray.get a (Int32.of_int i))
  | Reference_array (a, unwrap, wrap) -> wrap (JavaReferenceArray.get a (Int32.of_int i))

let length : type e . e t -> int = fun a ->
  match a with
  | Boolean_array a -> Int32.to_int (JavaBooleanArray.length a)
  | Byte_array a -> Int32.to_int (JavaByteArray.length a)
  | Char_array a -> Int32.to_int (JavaCharArray.length a)
  | Double_array a -> Int32.to_int (JavaDoubleArray.length a)
  | Float_array a -> Int32.to_int (JavaFloatArray.length a)
  | Int_array a -> Int32.to_int (JavaIntArray.length a)
  | Long_array a -> Int32.to_int (JavaLongArray.length a)
  | Short_array a -> Int32.to_int (JavaShortArray.length a) 
  | String_array a ->Int32.to_int (JavaReferenceArray.length a)
  | Reference_array (a, _, _) -> Int32.to_int (JavaReferenceArray.length a)


let set : type e . e t -> int -> e -> unit = fun a i x ->
  match a with
  | Boolean_array a -> JavaBooleanArray.set a (Int32.of_int i) x
  | Byte_array a -> JavaByteArray.set a (Int32.of_int i) x
  | Char_array a -> JavaCharArray.set a (Int32.of_int i) (Char.code x)
  | Double_array a -> JavaDoubleArray.set a (Int32.of_int i) x
  | Float_array a -> JavaFloatArray.set a (Int32.of_int i) x
  | Int_array a -> JavaIntArray.set a (Int32.of_int i) (Int32.of_int x)
  | Long_array a -> JavaLongArray.set a (Int32.of_int i) (Int64.of_int x)
  | Short_array a -> JavaShortArray.set a (Int32.of_int i) x
  | String_array a -> JavaReferenceArray.set a (Int32.of_int i) (JavaString.of_string x)
  | Reference_array (a, unwrap, wrap) -> JavaReferenceArray.set a (Int32.of_int i) (unwrap x)

