/* Don't complain about the use of SHA1, which is deprecated on some platforms. */
#pragma GCC diagnostic ignored "-Wdeprecated-declarations" 

// $ gcc -c websocket_stubs.c -I/Users/datkin/.opam/4.02.3//lib/ocaml
// For linking: -lcrypto -lssl

#include <openssl/sha.h>
#include <caml/memory.h>
#include <caml/mlvalues.h>
#include <caml/alloc.h>
#include <caml/fail.h>

value caml_sha1(value v)
{
    CAMLparam1 (v);
    CAMLlocal1 (result);

    char* ibuf = String_val(v);
    //unsigned char obuf[20];
    result = caml_alloc_string(20);
    char* obuf = String_val(result);

    if (!SHA1((unsigned char*) ibuf, caml_string_length(v), (unsigned char*) obuf)) {
        caml_failwith("SHA1 failed");
    }

    CAMLreturn (result);
}
