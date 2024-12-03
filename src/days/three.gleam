import gleam/int
import gleam/string

type ProcessState {
  State(n1: Int, n2: Int, tot1: Int, tot2: Int, mul_enabled: Bool)
}

type State {
  None
  M
  U
  L
  MulLParen
  NumParsing(value: Int, digits: Int)
  Num1(value: Int)
  Num2(value: Int)
  D
  O
  DoLParen
  DoRParen
  N
  Apos
  T
  DontLParen
  DontRParen
}

fn process(feed: List(String), state: State, process_state: ProcessState) {
  case feed {
    [] -> #(process_state.tot1, process_state.tot2)
    [f, ..fs] -> {
      let next_state = case state, f {
        _, "d" -> D
        D, "o" -> O
        O, "(" -> DoLParen
        DoLParen, ")" -> DoRParen
        O, "n" -> N
        N, "'" -> Apos
        Apos, "t" -> T
        T, "(" -> DontLParen
        DontLParen, ")" -> DontRParen

        _, "m" -> M
        M, "u" -> U
        U, "l" -> L
        L, "(" -> MulLParen
        MulLParen, _ | Num1(_), _ -> {
          case f {
            "0" | "1" | "2" | "3" | "4" | "5" | "6" | "7" | "8" | "9" -> {
              let assert Ok(n) = int.parse(f)
              NumParsing(n, 1)
            }
            _ -> None
          }
        }
        NumParsing(n, c), _ -> {
          case f {
            "0" | "1" | "2" | "3" | "4" | "5" | "6" | "7" | "8" | "9" -> {
              let assert Ok(next_digit) = int.parse(f)
              NumParsing(n * 10 + next_digit, c + 1)
            }
            "," -> Num1(n)
            ")" -> Num2(n)
            _ -> None
          }
        }

        _, _ -> None
      }
      case next_state {
        Num1(new_n1) ->
          process(fs, next_state, State(..process_state, n1: new_n1))
        Num2(new_n2) -> {
          let new_tot1 = process_state.tot1 + process_state.n1 * new_n2
          let new_tot2 = case process_state.mul_enabled {
            True -> process_state.tot2 + process_state.n1 * new_n2
            False -> process_state.tot2
          }
          process(
            fs,
            next_state,
            State(..process_state, n1: 0, n2: 0, tot1: new_tot1, tot2: new_tot2),
          )
        }
        DoRParen ->
          process(fs, next_state, State(..process_state, mul_enabled: True))
        DontRParen ->
          process(fs, next_state, State(..process_state, mul_enabled: False))
        _ -> process(fs, next_state, process_state)
      }
    }
  }
}

pub fn part1(data: String) {
  let #(tot1, _tot2) =
    process(
      string.to_graphemes(data),
      None,
      State(n1: 0, n2: 0, tot1: 0, tot2: 0, mul_enabled: True),
    )
  tot1
}

pub fn part2(data: String) {
  let #(_tot1, tot2) =
    process(
      string.to_graphemes(data),
      None,
      State(n1: 0, n2: 0, tot1: 0, tot2: 0, mul_enabled: True),
    )
  tot2
}
