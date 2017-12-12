(* Thanks to octochron for the code! *)

type 'a t = { return : 'b. 'a -> 'b } [@@ocaml.unboxed]

let with_return (type b) f =
  let exception Return of b in
  try f { return = (fun y -> raise (Return y)) } with Return y -> y
