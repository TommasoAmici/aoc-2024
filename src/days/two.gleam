import gleam/int
import gleam/list
import gleam/result
import gleam/string

type Level =
  Int

type Report =
  List(Level)

pub type Parsed =
  List(Report)

fn parse_line(line: String) {
  let assert Ok(levels) =
    line
    |> string.split(" ")
    |> list.map(int.parse)
    |> result.all()

  levels
}

pub fn parse(data: String) -> Parsed {
  data
  |> string.split("\n")
  |> list.map(parse_line)
}

fn is_safe_seq(curr: Level, prev: Level, increasing increasing: Bool) {
  case increasing {
    True -> curr > prev && curr - prev <= 3
    False -> curr < prev && prev - curr <= 3
  }
}

fn is_safe_recurse(report: Report, prev: Level, increasing: Bool) {
  case report {
    [] -> True
    [r, ..rs] -> {
      let safe = is_safe_seq(r, prev, increasing)
      case safe {
        False -> False
        True -> is_safe_recurse(rs, r, increasing)
      }
    }
  }
}

/// The levels are either all increasing or all decreasing.
///
/// Any two adjacent levels differ by at least one and at most three.
fn is_safe(report: Report) -> Bool {
  let assert [fst, snd, ..rest] = report
  let increasing = fst < snd
  is_safe_recurse([snd, ..rest], fst, increasing)
}

pub fn part1(data: Parsed) {
  data |> list.count(is_safe)
}

fn is_safe_with_dampener_recurse(
  prev: Report,
  report: Report,
  increasing increasing: Bool,
  dampened dampened: Bool,
) -> Bool {
  case prev, report, dampened {
    _, [], _ -> True
    [], [_], _ -> True
    // last element without any dampening can be ignored
    [_, ..], [_], False -> True
    [p, ..], [curr], True -> is_safe_seq(curr, p, increasing)
    [], [curr, next, ..rest], True -> {
      let increasing = next > curr
      is_safe_with_dampener_recurse(
        [curr],
        [next, ..rest],
        increasing,
        dampened,
      )
    }
    [], [curr, next, ..rest], False -> {
      let increasing = next > curr
      is_safe_with_dampener_recurse(
        [curr],
        [next, ..rest],
        increasing,
        dampened,
      )
      || is_safe_with_dampener_recurse(
        [],
        [next, ..rest],
        increasing,
        dampened: True,
      )
    }
    [p], [curr, next, ..rest], True -> {
      let increasing = curr > p
      let safe = is_safe_seq(curr, p, increasing)
      case safe {
        True ->
          is_safe_with_dampener_recurse(
            [curr, p],
            [next, ..rest],
            increasing,
            dampened,
          )
        False -> False
      }
    }
    [p, ..ps], [curr, next, ..rest], True -> {
      let safe = is_safe_seq(curr, p, increasing)
      case safe {
        True ->
          is_safe_with_dampener_recurse(
            [curr, p, ..ps],
            [next, ..rest],
            increasing,
            dampened,
          )
        False -> False
      }
    }
    [p, ..ps], [curr, next, ..rest], False -> {
      let safe = is_safe_seq(curr, p, increasing)
      case safe {
        True ->
          is_safe_with_dampener_recurse(
            [curr, p, ..ps],
            [next, ..rest],
            increasing,
            dampened,
          )
        False -> {
          // try to drop current
          is_safe_with_dampener_recurse(
            [p, ..ps],
            [next, ..rest],
            increasing,
            dampened: True,
          )
          // try to drop previous
          || is_safe_with_dampener_recurse(
            ps,
            [curr, next, ..rest],
            increasing,
            dampened: True,
          )
        }
      }
    }
  }
}

/// The levels are either all increasing or all decreasing.
///
/// Any two adjacent levels differ by at least one and at most three.
/// 
/// If removing a single level from an unsafe report would make it safe,
/// the report instead counts as safe.
pub fn is_safe_with_dampener(report: Report) -> Bool {
  is_safe_with_dampener_recurse([], report, increasing: False, dampened: False)
}

pub fn part2(data: Parsed) {
  data |> list.count(is_safe_with_dampener)
}
