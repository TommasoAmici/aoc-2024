import days/one
import gleam/int
import gleam/io
import simplifile

pub fn run_test() {
  io.println_error("\nday 1")

  let assert Ok(contents) = simplifile.read("./inputs/01.txt")
  let parsed = one.parse(contents)

  io.print_error("\tpart 1\t")
  one.part1(parsed)
  |> int.to_string()
  |> io.println_error()

  io.print_error("\tpart 2\t")
  one.part2(parsed)
  |> int.to_string()
  |> io.println_error()
}
