let _ = 
  let gauss_factor = 8 in
  let gauss = Array.init (2 * gauss_factor + 1) (fun i ->
    let m = gauss_factor in
    let z = 3. *. float_of_int (i - m) /. float_of_int gauss_factor in
    exp (z *. z *. -0.5) 
  ) in
  gauss
