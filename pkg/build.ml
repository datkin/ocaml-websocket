#!/usr/bin/env ocaml
#directory "pkg"
#use "topkg.ml"

let () =
  Pkg.describe "websocket" ~builder:`OCamlbuild [
    Pkg.lib "pkg/META";
    Pkg.lib ~exts:Exts.c_library "lib/libwebsocket_stubs";
    Pkg.lib ~exts:Exts.c_dll_library "lib/dllwebsocket_stubs";
    Pkg.lib ~exts:Exts.library "lib/websocket";
    Pkg.lib ~exts:Exts.module_library "lib/websocket_async";
  ]
