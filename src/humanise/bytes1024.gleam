//// This module contains functions for formatting 1024-multiple amounts of data to `String`s (e.g. `"100B"`, `"1.5GiB"`).
////
//// Usage generally looks like this:
//// ```
//// bytes1024.Kibibytes(2048.0) |> bytes1024.humanise |> bytes1024.to_string // "2MiB"
//// 
//// // or, if you don't want to change the unit
//// bytes1024.Kibibytes(2048.0) |> bytes1024.to_string // "2048KiB"
//// ```
////
//// *Note: This module is for 1024-multiple units! (kibibyte, megbibyte, etc.)*
//// *If you're looking for 1000-multiple units (kilobyte, megabyte, etc.), look at the `bytes` module instead.*

import gleam/float

import humanise/util

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
    Kibibytes(n) -> n *. util.kibibyte
    Mebibytes(n) -> n *. util.mebibyte
    Gibibytes(n) -> n *. util.gibibyte
    Tebibytes(n) -> n *. util.tebibyte
  }
}

/// Convert a value to kibibytes.
///
/// Example:
/// ```
/// bytes1024.Bytes(1024.0) |> bytes1024.as_kibibytes // 1.0
/// ```
pub fn as_kibibytes(this bytes: Bytes) -> Float {
  as_bytes(bytes) /. util.kibibyte
}

/// Convert a value to mebibytes.
///
/// Example:
/// ```
/// bytes1024.Kibibytes(1024.0) |> bytes1024.as_mebibytes // 1.0
/// ```
pub fn as_mebibytes(this bytes: Bytes) -> Float {
  as_bytes(bytes) /. util.mebibyte
}

/// Convert a value to gibibytes.
///
/// Example:
/// ```
/// bytes1024.Mebibytes(1024.0) |> bytes1024.as_gibibytes // 1.0
/// ```
pub fn as_gibibytes(this bytes: Bytes) -> Float {
  as_bytes(bytes) /. util.gibibyte
}

/// Convert a value to tebibytes.
///
/// Example:
/// ```
/// bytes1024.Gibibytes(1024.0) |> bytes1024.as_tebibytes // 1.0
/// ```
pub fn as_tebibytes(this bytes: Bytes) -> Float {
  as_bytes(bytes) /. util.tebibyte
}

/// Convert a value to a more optimal unit, if possible.
///
/// Example:
/// ```
/// bytes1024.Mebibytes(0.5) |> bytes1024.humanise // bytes1024.Kibibytes(512.0)
/// ```
pub fn humanise(this bytes: Bytes) -> Bytes {
  let b = as_bytes(bytes)

  case float.absolute_value(b) {
    abs_b if abs_b <. util.kibibyte -> Bytes(b)
    abs_b if abs_b <. util.mebibyte -> Kibibytes(b /. util.kibibyte)
    abs_b if abs_b <. util.gibibyte -> Mebibytes(b /. util.mebibyte)
    abs_b if abs_b <. util.terabyte -> Gibibytes(b /. util.gibibyte)
    _ -> Tebibytes(b /. util.tebibyte)
  }
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

/// 
/// Format a value as a `String`, rounded to at most 1 decimal place, followed by a long unit suffix.
///
/// Example:
/// ```
/// bytes1024.Gibibytes(30.125) |> bytes1024.to_string_full // "30.1 gibibytes"
/// bytes1024.Mebibytes(1.0) |> bytes1024.to_string_full // "1 mebibyte"
/// ```
pub fn to_string_full(this bytes: Bytes) -> String {
  let #(n, suffix) = case bytes {
    Bytes(n) -> #(n, " byte")
    Kibibytes(n) -> #(n, " kibibyte")
    Mebibytes(n) -> #(n, " mebibyte")
    Gibibytes(n) -> #(n, " gibibyte")
    Tebibytes(n) -> #(n, " tebibyte")
  }

  let plural = case n {
    1.0 -> ""
    _ -> "s"
  }

  util.format(n, suffix) <> plural
}

/// Decompose a value into its inner value and constructor.
///
/// This is useful if you need to operate directly on the value and then reconstruct it (i.e. for custom rounding precision).
///
/// Example:
/// ```
/// let #(value, constructor) = bytes1024.decompose(bytes1024.Mebibytes(2.0))
///
/// constructor(value *. 2.0) // bytes1024.Mebibytes(4.0)
/// ```
pub fn decompose(time: Bytes) -> #(Float, fn(Float) -> Bytes) {
  case time {
    Bytes(a) -> #(a, Bytes)
    Gibibytes(a) -> #(a, Gibibytes)
    Kibibytes(a) -> #(a, Kibibytes)
    Mebibytes(a) -> #(a, Mebibytes)
    Tebibytes(a) -> #(a, Tebibytes)
  }
}
