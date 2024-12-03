import days/three
import gleam/int
import gleam/io
import gleeunit/should
import simplifile

pub fn run_test() {
  io.println_error("\nday 3")

  let assert Ok(contents) = simplifile.read("./inputs/03.txt")

  io.print_error("\tpart 1\t")
  let part1 = three.part1(contents)
  part1
  |> int.to_string()
  |> io.println_error()
  part1 |> should.equal(190_604_937)

  io.print_error("\tpart 2\t")
  let part2 = three.part2(contents)
  part2
  |> int.to_string()
  |> io.println_error()
  part2 |> should.equal(82_857_512)
}
