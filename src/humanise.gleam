//// This module contains a bunch of shortcuts to the `time` and `bytes` modules for directly "humanising" and formatting a number (`Float` or `Int`) to a `String`.
////
//// For more control (e.g. return `time.Time` or `bytes.Bytes` instead of a `String`, use the given unit instead of the most optimal one), look at the `time` or `bytes` modules.

import gleam/int

import humanise/bytes
import humanise/bytes1024
import humanise/time

/// Format *n* microseconds as a `Float`, converting to a more optimal unit if possible.
pub fn microseconds_float(from n: Float) -> String {
  time.Microseconds(n) |> time.humanise |> time.to_string
}

/// Format *n* microseconds as an `Int`, converting to a more optimal unit if possible.
pub fn microseconds_int(from n: Int) -> String {
  time.Microseconds(int.to_float(n)) |> time.humanise |> time.to_string
}

/// Format *n* milliseconds as a `Float`, converting to a more optimal unit if possible.
pub fn milliseconds_float(from n: Float) -> String {
  time.Milliseconds(n) |> time.humanise |> time.to_string
}

/// Format *n* milliseconds as an `Int`, converting to a more optimal unit if possible.
pub fn milliseconds_int(from n: Int) -> String {
  time.Milliseconds(int.to_float(n)) |> time.humanise |> time.to_string
}

/// Format *n* seconds as a `Float`, converting to a more optimal unit if possible.
pub fn seconds_float(from n: Float) -> String {
  time.Seconds(n) |> time.humanise |> time.to_string
}

/// Format *n* seconds as an `Int`, converting to a more optimal unit if possible.
pub fn seconds_int(from n: Int) -> String {
  time.Seconds(int.to_float(n)) |> time.humanise |> time.to_string
}

/// Format *n* hours as a `Float`, converting to a more optimal unit if possible.
pub fn hours_float(from n: Float) -> String {
  time.Hours(n) |> time.humanise |> time.to_string
}

/// Format *n* hours as an `Int`, converting to a more optimal unit if possible.
pub fn hours_int(from n: Int) -> String {
  time.Hours(int.to_float(n)) |> time.humanise |> time.to_string
}

/// Format *n* days as a `Float`, converting to a more optimal unit if possible.
pub fn days_float(from n: Float) -> String {
  time.Days(n) |> time.humanise |> time.to_string
}

/// Format *n* days as an `Int`, converting to a more optimal unit if possible.
pub fn days_int(from n: Int) -> String {
  time.Days(int.to_float(n)) |> time.humanise |> time.to_string
}

/// Format *n* weeks as a `Float`, converting to a more optimal unit if possible.
pub fn weeks_float(from n: Float) -> String {
  time.Weeks(n) |> time.humanise |> time.to_string
}

/// Format *n* weeks as an `Int`, converting to a more optimal unit if possible.
pub fn weeks_int(from n: Int) -> String {
  time.Weeks(int.to_float(n)) |> time.humanise |> time.to_string
}

/// Format *n* bytes as a `Float`, converting to a more optimal unit if possible.
pub fn bytes_float(from n: Float) -> String {
  bytes.Bytes(n) |> bytes.humanise |> bytes.to_string
}

/// Format *n* bytes as an `Int`, converting to a more optimal unit if possible.
pub fn bytes_int(from n: Int) -> String {
  bytes.Bytes(int.to_float(n)) |> bytes.humanise |> bytes.to_string
}

/// Format *n* kilobytes as a `Float`, converting to a more optimal unit if possible.
pub fn kilobytes_float(from n: Float) -> String {
  bytes.Kilobytes(n) |> bytes.humanise |> bytes.to_string
}

/// Format *n* kilobytes as an `Int`, converting to a more optimal unit if possible.
pub fn kilobytes_int(from n: Int) -> String {
  bytes.Kilobytes(int.to_float(n)) |> bytes.humanise |> bytes.to_string
}

/// Format *n* megabytes as a `Float`, converting to a more optimal unit if possible.
pub fn megabytes_float(from n: Float) -> String {
  bytes.Megabytes(n) |> bytes.humanise |> bytes.to_string
}

/// Format *n* megabytes as an `Int`, converting to a more optimal unit if possible.
pub fn megabytes_int(from n: Int) -> String {
  bytes.Megabytes(int.to_float(n)) |> bytes.humanise |> bytes.to_string
}

/// Format *n* gigabytes as a `Float`, converting to a more optimal unit if possible.
pub fn gigabytes_float(from n: Float) -> String {
  bytes.Gigabytes(n) |> bytes.humanise |> bytes.to_string
}

/// Format *n* gigabytes as an `Int`, converting to a more optimal unit if possible.
pub fn gigabytes_int(from n: Int) -> String {
  bytes.Gigabytes(int.to_float(n)) |> bytes.humanise |> bytes.to_string
}

/// Format *n* terabytes as a `Float`, converting to a more optimal unit if possible.
pub fn terabytes_float(from n: Float) -> String {
  bytes.Terabytes(n) |> bytes.humanise |> bytes.to_string
}

/// Format *n* terabytes as an `Int`, converting to a more optimal unit if possible.
pub fn terabytes_int(from n: Int) -> String {
  bytes.Terabytes(int.to_float(n)) |> bytes.humanise |> bytes.to_string
}

/// Format *n* kibibytes as a `Float`, converting to a more optimal unit if possible.
pub fn kibibytes_float(from n: Float) -> String {
  bytes1024.Kibibytes(n)
  |> bytes1024.humanise
  |> bytes1024.to_string
}

/// Format *n* kibibytes as an `Int`, converting to a more optimal unit if possible.
pub fn kibibytes_int(from n: Int) -> String {
  bytes1024.Kibibytes(int.to_float(n))
  |> bytes1024.humanise
  |> bytes1024.to_string
}

/// Format *n* mebibytes as a `Float`, converting to a more optimal unit if possible.
pub fn mebibytes_float(from n: Float) -> String {
  bytes1024.Mebibytes(n)
  |> bytes1024.humanise
  |> bytes1024.to_string
}

/// Format *n* mebibytes as an `Int`, converting to a more optimal unit if possible.
pub fn mebibytes_int(from n: Int) -> String {
  bytes1024.Mebibytes(int.to_float(n))
  |> bytes1024.humanise
  |> bytes1024.to_string
}

/// Format *n* gibibytes as a `Float`, converting to a more optimal unit if possible.
pub fn gibibytes_float(from n: Float) -> String {
  bytes1024.Gibibytes(n)
  |> bytes1024.humanise
  |> bytes1024.to_string
}

/// Format *n* gibibytes as an `Int`, converting to a more optimal unit if possible.
pub fn gibibytes_int(from n: Int) -> String {
  bytes1024.Gibibytes(int.to_float(n))
  |> bytes1024.humanise
  |> bytes1024.to_string
}

/// Format *n* tebibytes as a `Float`, converting to a more optimal unit if possible.
pub fn tebibytes_float(from n: Float) -> String {
  bytes1024.Tebibytes(n)
  |> bytes1024.humanise
  |> bytes1024.to_string
}

/// Format *n* tebibytes as an `Int`, converting to a more optimal unit if possible.
pub fn tebibytes_int(from n: Int) -> String {
  bytes1024.Tebibytes(int.to_float(n))
  |> bytes1024.humanise
  |> bytes1024.to_string
}
