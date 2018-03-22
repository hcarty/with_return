open Migrate_parsetree
open OCaml_406.Ast
open Ast_mapper
open Parsetree

(**
   {[
     let contrived x =
       [%with_return];
       if x = 0 then return `zero;
       if x < 0 then return `greater;
       `lesser
   ]}
*)

let make_with_return e name =
  [%expr
    With_return.with_return (fun {With_return.return= [%p name]} -> [%e e])] [@metaloc
                                                                               e
                                                                               .pexp_loc]


let generate_with_return mapper e name =
  let e = mapper.expr mapper e in
  let generated = make_with_return e name in
  let pexp_loc =
    (* [loc_ghost] tells the compiler and other tools than this is
       generated code *)
    {generated.pexp_loc with Location.loc_ghost= true}
  in
  {generated with pexp_loc}


let with_return_mapper =
  { default_mapper with
    expr=
      (fun mapper expr ->
        match expr with
        | [%expr
            [%with_return] ;
            [%e ? e]] ->
            generate_with_return mapper e [%pat ? return]
        | [%expr
            let [%p ? name] = [%with_return] in
            [%e ? e]] ->
            generate_with_return mapper e name
        | _ -> default_mapper.expr mapper expr ) }


let () =
  Driver.register ~name:"ppx_return" Versions.ocaml_406
    (fun _config _cookies -> with_return_mapper )
