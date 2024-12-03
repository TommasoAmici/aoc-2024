import days/three
import gleam/int
import gleam/io
import gleeunit/should
import simplifile

pub fn parse1_test() {
  three.parse1(
    "xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))",
  )
  |> should.equal([#(2, 4), #(5, 5), #(11, 8), #(8, 5)])
}

pub fn parse2_test() {
  three.parse2(
    "xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))",
  )
  |> should.equal([#(2, 4), #(8, 5)])
}

pub fn run_test() {
  io.println_error("\nday 3")

  let assert Ok(contents) = simplifile.read("./inputs/03.txt")

  io.print_error("\tpart 1\t")
  let part1 = three.part1(contents)
  part1 |> should.equal(190_604_937)
  part1
  |> int.to_string()
  |> io.println_error()

  io.print_error("\tpart 2\t")
  let part2 = three.part2(contents)
  part2 |> should.equal(82_857_512)
  part2
  |> int.to_string()
  |> io.println_error()
}
