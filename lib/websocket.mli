val random_string : ?base64:bool -> ?g:'a -> int -> string
val b64_encoded_sha1sum : string -> string
val websocket_uuid : string

module Frame : sig
  module Opcode : sig
    type t =
        Continuation
      | Text
      | Binary
      | Close
      | Ping
      | Pong
      | Ctrl of int
      | Nonctrl of int
    [@@deriving sexp]
    val min : int
    val max : int
    val of_enum : int -> t option
    val to_enum : t -> int
    val is_ctrl : t -> bool
  end

  type t = {
    opcode : Opcode.t;
    extension : int;
    final : bool;
    content : string;
  } [@@deriving sexp]

  val create :
    ?opcode:Opcode.t ->
    ?extension:int -> ?final:bool -> ?content:string -> unit -> t
  val of_bytes :
    ?opcode:Opcode.t -> ?extension:int -> ?final:bool -> bytes -> t
  val close : int -> t
  val of_subbytes :
    ?opcode:Opcode.t ->
    ?extension:int -> ?final:bool -> bytes -> int -> int -> t
end

val xor : string -> bytes -> unit
val is_bit_set : int -> int -> bool
val set_bit : int -> int -> bool -> int
val int_value : int -> int -> int -> int
val upgrade_present : Cohttp.Header.t -> bool

module IO : functor (IO : Cohttp.S.IO) -> sig
  val read_uint16 : IO.ic -> int option IO.t
  val read_int64 : IO.ic -> int option IO.t
  val write_frame_to_buf :
    ?g:'a -> masked:bool -> Buffer.t -> Frame.t -> unit
  val make_read_frame :
    ?g:'a ->
    masked:bool ->
    IO.ic * IO.oc -> unit -> [> `Error of string | `Ok of Frame.t ] IO.t
end
