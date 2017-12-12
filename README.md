# with\_return - Early return inside expressions

`with_return` is a tiny library and matching OCaml syntax extension
implementing an early return mechanism using exceptions.

Thanks to octachron for the initial code living in the `With_return` module.

## Using ppx\_return

The bundled ppx syntax extension makes using this functionality syntactically
lighter.

```ocaml
let add_one_if_negative x =
  (* The name return is used by default *)
  [%with_return];
  if x >= 0 then return (Error "not negative");
  Ok (x + 1)
```

The name of the value used to return early can be customized if `return` would shadow local names.

```ocaml
let add_one_if_negative x =
   (* Now use ret instead of return *)
   let myret = [%with_return] in
   if x >= 0 then myret (Error "not negative");
   Ok (x + 1)
```
