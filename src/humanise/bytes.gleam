//// This module contains functions for formatting amounts of data to `String`s (e.g. `"100.0B"`, `"1.5GB"`).
////
//// Usage generally looks like this:
//// ```
//// bytes.Kilobytes(2000.0) |> bytes.humanise |> bytes.to_string // "2.0MB"
//// 
//// // or, if you don't want to change the unit
//// bytes.Kilobytes(2000.0) |> bytes.to_string // "2000.0KB"
//// ```
////
//// *Note: This module currently uses multiples of 1000 (kilobytes, megabytes etc), NOT multiples of 1024 (kibibytes, mebibytes, etc). Support for 1024-multiples will likely be added later!*

import gleam/bool

import util

// const byte = 1.0

const kilobyte = 1000.0

const megabyte = 1_000_000.0

const gigabyte = 1_000_000_000.0

const terabyte = 1_000_000_000_000.0

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

fn to_b(bytes: Bytes) -> Float {
  case bytes {
    Bytes(n) -> n
    Kilobytes(n) -> n *. kilobyte
    Megabytes(n) -> n *. megabyte
    Gigabytes(n) -> n *. gigabyte
    Terabytes(n) -> n *. terabyte
  }
}

/// Convert a value to a more optimal unit, if possible.
///
/// Example:
/// ```
/// bytes.Megabytes(0.5) |> bytes.humanise // bytes.Kilobytes(500.0)
/// ```
pub fn humanise(this bytes: Bytes) -> Bytes {
  let b = to_b(bytes)

  use <- bool.guard(when: b <. kilobyte, return: Bytes(b))
  use <- bool.guard(when: b <. megabyte, return: Kilobytes(b /. kilobyte))
  use <- bool.guard(when: b <. gigabyte, return: Megabytes(b /. megabyte))
  use <- bool.guard(when: b <. terabyte, return: Gigabytes(b /. gigabyte))

  Terabytes(b /. terabyte)
}

/// Format a value as a `String`, rounded to at most 2 decimal places, followed by a unit suffix.
///
/// Example:
/// ```
/// bytes.Gigabytes(30.125) |> bytes.to_string // "30.13GB"
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
