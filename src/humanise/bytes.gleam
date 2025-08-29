//// This module contains functions for formatting amounts of data to `String`s (e.g. `"100B"`, `"1.5GB"`).
////
//// Usage generally looks like this:
//// ```
//// bytes.Kilobytes(2000.0) |> bytes.humanise |> bytes.to_string // "2MB"
//// 
//// // or, if you don't want to change the unit
//// bytes.Kilobytes(2000.0) |> bytes.to_string // "2000KB"
//// ```
////
//// *Note: This module is for 1000-multiple units! (kilobyte, megabyte, etc.)*
//// *If you're looking for 1024-multiple units (kibibyte, mebibyte, etc.), look at the `bytes1024` module instead.*

import gleam/float

import humanise/util

/// The main type for holding data amount information.
///
/// Use its constructors directly to specify a unit for the value you want to format.
pub type Bytes {
  Bytes(Float)
  Kilobytes(Float)
  Megabytes(Float)
  Gigabytes(Float)
  Terabytes(Float)
}

/// Convert a value to bytes.
///
/// Example:
/// ```
/// bytes.Kilobytes(1.0) |> bytes.as_bytes // 1000.0
/// ```
pub fn as_bytes(this bytes: Bytes) -> Float {
  case bytes {
    Bytes(n) -> n
    Kilobytes(n) -> n *. util.kilobyte
    Megabytes(n) -> n *. util.megabyte
    Gigabytes(n) -> n *. util.gigabyte
    Terabytes(n) -> n *. util.terabyte
  }
}

/// Convert a value to kilobytes.
///
/// Example:
/// ```
/// bytes.Bytes(1000.0) |> bytes.as_kilobytes // 1.0
/// ```
pub fn as_kilobytes(this bytes: Bytes) -> Float {
  as_bytes(bytes) /. util.kilobyte
}

/// Convert a value to megabytes.
///
/// Example:
/// ```
/// bytes.Kilobytes(1000.0) |> bytes.as_megabytes // 1.0
/// ```
pub fn as_megabytes(this bytes: Bytes) -> Float {
  as_bytes(bytes) /. util.megabyte
}

/// Convert a value to gigabytes.
///
/// Example:
/// ```
/// bytes.Megabytes(1000.0) |> bytes.as_gigabytes // 1.0
/// ```
pub fn as_gigabytes(this bytes: Bytes) -> Float {
  as_bytes(bytes) /. util.gigabyte
}

/// Convert a value to terabytes.
///
/// Example:
/// ```
/// bytes.Gigabytes(1000.0) |> bytes.as_terabytes // 1.0
/// ```
pub fn as_terabytes(this bytes: Bytes) -> Float {
  as_bytes(bytes) /. util.terabyte
}

/// Convert a value to a more optimal unit, if possible.
///
/// Example:
/// ```
/// bytes.Megabytes(0.5) |> bytes.humanise // bytes.Kilobytes(500.0)
/// ```
pub fn humanise(this bytes: Bytes) -> Bytes {
  let b = as_bytes(bytes)

  case float.absolute_value(b) {
    abs_b if abs_b <. util.kilobyte -> Bytes(b)
    abs_b if abs_b <. util.megabyte -> Kilobytes(b /. util.kilobyte)
    abs_b if abs_b <. util.gigabyte -> Megabytes(b /. util.megabyte)
    abs_b if abs_b <. util.terabyte -> Gigabytes(b /. util.gigabyte)
    _ -> Terabytes(b /. util.terabyte)
  }
}

/// Format a value as a `String`, rounded to at most 1 decimal place, followed by an abbreviated unit suffix.
///
/// Example:
/// ```
/// bytes.Gigabytes(30.125) |> bytes.to_string // "30.1GB"
/// ```
pub fn to_string(this bytes: Bytes) -> String {
  let #(n, suffix) = case bytes {
    Bytes(n) -> #(n, "B")
    Kilobytes(n) -> #(n, "KB")
    Megabytes(n) -> #(n, "MB")
    Gigabytes(n) -> #(n, "GB")
    Terabytes(n) -> #(n, "TB")
  }

  util.format(n, suffix)
}

/// Format a value as a `String`, rounded to at most 1 decimal place, followed by a long unit suffix.
///
/// Example:
/// ```
/// bytes.Gigabytes(30.125) |> bytes.to_string_full // "30.1 gigabytes"
/// bytes.Megabytes(1.0) |> bytes.to_string_full // "1 megabyte"
/// ```
pub fn to_string_full(this bytes: Bytes) -> String {
  let #(n, suffix) = case bytes {
    Bytes(n) -> #(n, " byte")
    Kilobytes(n) -> #(n, " kilobyte")
    Megabytes(n) -> #(n, " megabyte")
    Gigabytes(n) -> #(n, " gigabyte")
    Terabytes(n) -> #(n, " terabyte")
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
/// let #(value, constructor) = bytes.decompose(bytes.Megabytes(2.0)) // #(2.0, bytes.Megabytes)
///
/// constructor(value *. 2.0) // bytes.Megabytes(4.0)
/// ```
pub fn decompose(time: Bytes) -> #(Float, fn(Float) -> Bytes) {
  case time {
    Bytes(a) -> #(a, Bytes)
    Gigabytes(a) -> #(a, Gigabytes)
    Kilobytes(a) -> #(a, Kilobytes)
    Megabytes(a) -> #(a, Megabytes)
    Terabytes(a) -> #(a, Terabytes)
  }
}
