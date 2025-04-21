import gleam/float
import gleam/int

pub fn round_to(this n: Float, to places: Int) -> Float {
  let assert Ok(places) =
    int.to_float(int.max(1, places)) |> float.power(10.0, _)

  { float.round(n *. places) |> int.to_float } /. places
}

pub fn format(this n: Float, suffix suffix: String) -> String {
  n |> round_to(2) |> float.to_string <> suffix
}
