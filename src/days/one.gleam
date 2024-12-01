import gleam/dict
import gleam/int
import gleam/io
import gleam/list
import gleam/option
import gleam/string
import simplifile

type Parsed =
  #(List(Int), List(Int))

fn parse_line(line: String) {
  let assert Ok(#(l, r)) =
    line
    |> string.split_once("   ")

  let assert Ok(l) = int.parse(l)
  let assert Ok(r) = int.parse(r)

  #(l, r)
}

fn parse(data: String) -> Parsed {
  data
  |> string.split("\n")
  |> list.map(parse_line)
  |> list.unzip()
}

fn part1(data: Parsed) {
  let #(left, right) = data
  let left_sorted = left |> list.sort(int.compare)
  let right_sorted = right |> list.sort(int.compare)
  let solution =
    list.zip(left_sorted, right_sorted)
    |> list.fold(0, fn(a, b) { a + int.absolute_value(b.0 - b.1) })

  "part 1: " <> int.to_string(solution)
}

fn counter_increment(x: option.Option(Int)) {
  case x {
    option.Some(i) -> i + 1
    option.None -> 1
  }
}

fn count_instances_r(counter: dict.Dict(value, Int), values: List(value)) {
  case values {
    [] -> counter
    [x, ..xs] ->
      count_instances_r(dict.upsert(counter, x, counter_increment), xs)
  }
}

fn count_instances(xs: List(value)) {
  let counter = dict.new()
  count_instances_r(counter, xs)
}

fn part2(data: Parsed) {
  let #(left, right) = data

  let right_counter = count_instances(right)

  let solution =
    list.fold(left, 0, fn(tot, cur) {
      case dict.get(right_counter, cur) {
        Ok(i) -> tot + cur * i
        _ -> tot
      }
    })

  "part 2: " <> int.to_string(solution)
}

pub fn run() {
  io.println("\nday 1")
  let assert Ok(contents) = simplifile.read("./inputs/01.txt")
  let parsed = parse(contents)
  part1(parsed) |> io.println
  part2(parsed) |> io.println
}
