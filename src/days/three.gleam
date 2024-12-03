import gleam/int
import gleam/list
import gleam/result
import gleam/string

type Mul =
  #(Int, Int)

fn parse_nums(str: String) {
  use #(expr, _) <- result.try(string.split_once(str, ")"))
  use #(left, right) <- result.try(string.split_once(expr, ","))
  use a <- result.try(int.parse(left))
  use b <- result.try(int.parse(right))

  Ok(#(a, b))
}

pub fn parse1(data: String) -> List(Mul) {
  string.split(data, "mul(") |> list.map(parse_nums) |> result.values()
}

pub fn part1(data: String) {
  data
  |> parse1()
  |> list.fold(0, fn(tot, mul) { tot + mul.0 * mul.1 })
}

fn parse2_internal(on: Bool, acc: List(Mul), data: String) {
  case data {
    "" -> acc
    _ -> {
      case on {
        True -> {
          let split = string.split_once(data, "don't()")
          case split {
            Ok(#(do, rest)) -> {
              parse2_internal(False, list.flatten([acc, parse1(do)]), rest)
            }
            _ -> parse2_internal(False, list.flatten([acc, parse1(data)]), "")
          }
        }
        False -> {
          let split = string.split_once(data, "do()")
          case split {
            Ok(#(_rest, do)) -> parse2_internal(True, acc, do)
            _ -> acc
          }
        }
      }
    }
  }
}

pub fn parse2(data: String) -> List(Mul) {
  parse2_internal(True, [], data)
}

pub fn part2(data: String) {
  data
  |> parse2()
  |> list.fold(0, fn(tot, mul) { tot + mul.0 * mul.1 })
}
