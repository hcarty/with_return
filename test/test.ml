let f x =
  [%with_return];
  if x < 0 then return `negative;
  if x > 0 then return `positive;
  `zero

let g x =
  [%with_return];
  let ret = [%with_return] in
  let ret2 = [%with_return] in
  if x < 0 then ret `negative;
  if x > 0 then ret2 `positive;
  return `zero

let () =
  assert (f ~-3 = `negative);
  assert (f 2 = `positive);
  assert (f 0 = `zero);
  assert (g ~-3 = `negative);
  assert (g 2 = `positive);
  assert (g 0 = `zero);
  print_endline "ok"
