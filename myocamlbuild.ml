open Ocamlbuild_plugin
open Command

let () =
  dispatch (function
    | After_rules ->
      flag [ "c"; "use_websocket"; "compile" ] (S [A "-ccopt"; A "-Ilib"]);
      flag [ "c"; "use_websocket"; "ocamlmklib" ] (S [A "-lcrypto"; A "-lssl"]);
      flag [ "link"; "ocaml"; "link_websocket_stubs" ] (A "lib/libwebsocket_stubs.a");

      dep  [ "link"; "ocaml"; "link_websocket" ] ["lib/libwebsocket_stubs.a"];
      flag [ "ocaml"; "use_websocket"; "link"; "library"; "byte";   ]
        (S [A "-dllib"; A "-lwebsocket_stubs"; A "-cclib"; A "-lcrypto"; A "-cclib"; A "-lssl"; ]);
      flag [ "ocaml"; "use_websocket"; "link"; "library"; "native"; ]
        (S [A "-cclib"; A "-lwebsocket_stubs"; A "-cclib"; A "-lcrypto"; A "-cclib"; A "-lssl"; ]);

      flag ["link"; "ocaml"; "byte"] (A"-custom");
    | _ -> ()
  )
