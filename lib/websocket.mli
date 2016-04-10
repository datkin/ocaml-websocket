open Core.Std

val random_string : ?base64:bool -> ?g:'a -> int -> bytes
val b64_encoded_sha1sum : bytes -> bytes
val websocket_uuid : bytes

module Frame : sig
  module Bytes_orig = Bytes
  module Bytes = Bytes_orig
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
    content : bytes;
  } [@@deriving sexp]

  val create :
    ?opcode:Opcode.t ->
    ?extension:int -> ?final:bool -> ?content:bytes -> unit -> t
  val of_bytes :
    ?opcode:Opcode.t -> ?extension:int -> ?final:bool -> bytes -> t
  val close : int -> t
  val of_subbytes :
    ?opcode:Opcode.t ->
    ?extension:int -> ?final:bool -> bytes -> int -> int -> t
end

val xor : bytes -> bytes -> unit
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
    IO.ic * IO.oc -> unit -> [> `Error of bytes | `Ok of Frame.t ] IO.t
end
