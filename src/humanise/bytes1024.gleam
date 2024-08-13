//// This module contains functions for formatting 1024-multiple amounts of data to `String`s (e.g. `"100.0B"`, `"1.5GiB"`).
////
//// Usage generally looks like this:
//// ```
//// bytes1024.Kibibytes(2048.0) |> bytes1024.humanise |> bytes1024.to_string // "2.0MiB"
//// 
//// // or, if you don't want to change the unit
//// bytes1024.Kilobytes(2048.0) |> bytes1024.to_string // "2048.0KiB"
//// ```
////
//// *Note: This module is for 1024-multiple units! (kibibyte, megbibyte, etc.)*
//// *If you're looking for 1000-multiple units (kilobyte, megabyte, etc.), look at the `bytes` module instead.*

import gleam/bool

import util

const kibibyte = 1024.0

const mebibyte = 1_048_576.0

const gibibyte = 1_073_741_824.0

const tebibyte = 1_099_511_627_776.0

/// The main type for holding data amount information.
///
/// Use its constructors directly to specify a unit for the value you want to format.
pub type Bytes {
  Bytes(Float)
  Kibibytes(Float)
  Mebibytes(Float)
  Gibibytes(Float)
  Tebibytes(Float)
}

/// Convert a value to bytes.
///
/// Example:
/// ```
/// bytes1024.Kibibytes(1.0) |> bytes1024.as_bytes // 1024.0
/// ```
pub fn as_bytes(this bytes: Bytes) -> Float {
  case bytes {
    Bytes(n) -> n
    Kibibytes(n) -> n *. kibibyte
    Mebibytes(n) -> n *. mebibyte
    Gibibytes(n) -> n *. gibibyte
    Tebibytes(n) -> n *. tebibyte
  }
}

/// Convert a value to kibibytes.
///
/// Example:
/// ```
/// bytes1024.Bytes(1024.0) |> bytes1024.as_kibibytes // 1.0
/// ```
pub fn as_kibibytes(this bytes: Bytes) -> Float {
  as_bytes(bytes) /. kibibyte
}

/// Convert a value to mebibytes.
///
/// Example:
/// ```
/// bytes1024.Kibibytes(1024.0) |> bytes1024.as_mebibytes // 1.0
/// ```
pub fn as_mebibytes(this bytes: Bytes) -> Float {
  as_bytes(bytes) /. mebibyte
}

/// Convert a value to gibibytes.
///
/// Example:
/// ```
/// bytes1024.Mebibytes(1024.0) |> bytes1024.as_gibibytes // 1.0
/// ```
pub fn as_gibibytes(this bytes: Bytes) -> Float {
  as_bytes(bytes) /. gibibyte
}

/// Convert a value to tebibytes.
///
/// Example:
/// ```
/// bytes1024.Gibibytes(1024.0) |> bytes1024.as_tebibytes // 1.0
/// ```
pub fn as_tebibytes(this bytes: Bytes) -> Float {
  as_bytes(bytes) /. tebibyte
}

/// Convert a value to a more optimal unit, if possible.
///
/// Example:
/// ```
/// bytes1024.Mebibytes(0.5) |> bytes1024.humanise // bytes1024.Kibibytes(512.0)
/// ```
pub fn humanise(this bytes: Bytes) -> Bytes {
  let b = as_bytes(bytes)

  use <- bool.guard(when: b <. kibibyte, return: Bytes(b))
  use <- bool.guard(when: b <. mebibyte, return: Kibibytes(b /. kibibyte))
  use <- bool.guard(when: b <. gibibyte, return: Mebibytes(b /. mebibyte))
  use <- bool.guard(when: b <. tebibyte, return: Gibibytes(b /. gibibyte))

  Tebibytes(b /. tebibyte)
}

/// Format a value as a `String`, rounded to at most 2 decimal places, followed by a unit suffix.
///
/// Example:
/// ```
/// bytes1024.Gibibytes(30.125) |> bytes1024.to_string // "30.13GiB"
/// ```
pub fn to_string(this bytes: Bytes) -> String {
  let #(n, suffix) = case bytes {
    Bytes(n) -> #(n, "B")
    Kibibytes(n) -> #(n, "KiB")
    Mebibytes(n) -> #(n, "MiB")
    Gibibytes(n) -> #(n, "GiB")
    Tebibytes(n) -> #(n, "TiB")
  }

  util.format(n, suffix)
}
