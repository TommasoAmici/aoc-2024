import days/two
import gleam/int
import gleam/io
import gleeunit/should
import simplifile

/// 7 6 4 2 1: Safe without removing any level.
pub fn is_safe_with_dampener_0_test() {
  two.is_safe_with_dampener([7, 6, 4, 2, 1])
  |> should.be_true()
}

/// 1 2 7 8 9: Unsafe regardless of which level is removed.
pub fn is_safe_with_dampener_1_test() {
  two.is_safe_with_dampener([1, 2, 7, 8, 9])
  |> should.be_false()
}

/// 9 7 6 2 1: Unsafe regardless of which level is removed.
pub fn is_safe_with_dampener_2_test() {
  two.is_safe_with_dampener([9, 7, 6, 2, 1])
  |> should.be_false()
}

/// 1 3 2 4 5: Safe by removing the second level, 3.
pub fn is_safe_with_dampener_3_test() {
  two.is_safe_with_dampener([1, 3, 2, 4, 5])
  |> should.be_true()
}

/// 8 6 4 4 1: Safe by removing the third level, 4.
pub fn is_safe_with_dampener_4_test() {
  two.is_safe_with_dampener([8, 6, 4, 4, 1])
  |> should.be_true()
}

/// 1 3 6 7 9: Safe without removing any level.
pub fn is_safe_with_dampener_5_test() {
  two.is_safe_with_dampener([1, 3, 6, 7, 9])
  |> should.be_true()
}

/// Safe when dropping last item
pub fn is_safe_with_dampener_6_test() {
  two.is_safe_with_dampener([48, 51, 52, 53, 52])
  |> should.be_true()
}

pub fn is_safe_with_dampener_7_test() {
  two.is_safe_with_dampener([41, 43, 40, 37, 35])
  |> should.be_true()
}

pub fn is_safe_with_dampener_8_test() {
  two.is_safe_with_dampener([62, 66, 69, 70, 73, 75])
  |> should.be_true()
}

pub fn is_safe_with_dampener_9_test() {
  two.is_safe_with_dampener([81, 83, 82, 79, 77, 75, 74, 71])
  |> should.be_true()
}

pub fn is_safe_with_dampener_10_test() {
  two.is_safe_with_dampener([68, 71, 74, 76, 77, 74, 71]) |> should.be_false()
}

pub fn run_test() {
  io.println_error("\nday 2")

  let assert Ok(contents) = simplifile.read("./inputs/02.txt")
  let parsed = two.parse(contents)

  io.print_error("\tpart 1\t")
  two.part1(parsed)
  |> int.to_string()
  |> io.println_error()

  io.print_error("\tpart 2\t")
  two.part2(parsed)
  |> int.to_string()
  |> io.println_error()
}
