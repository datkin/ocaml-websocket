#!/usr/bin/env ocaml
#directory "pkg"
#use "topkg.ml"

let () =
  Pkg.describe "websocket" ~builder:`OCamlbuild [
    Pkg.lib "pkg/META";
    Pkg.lib ~exts:Exts.library "lib/websocket";
    Pkg.lib ~exts:Exts.module_library "lib/websocket_async";
  ]
