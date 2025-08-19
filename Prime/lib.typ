#let num(n, digits: 3) = {
  if n == 0 {
    $0$
  } else {
    let exponent = calc.floor(calc.log(calc.abs(n)))
    let mantissa = calc.round(
      (n / calc.pow(10, exponent)), digits:digits
    )

    if calc.abs(exponent) <= 3 {
      let nr = calc.round(n, digits:(digits - exponent) )
      $nr$
    } else {
      $mantissa dot 10^exponent $
    }
  }
}
