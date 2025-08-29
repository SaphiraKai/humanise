//// This module contains a bunch of shortcuts to the `time`, `bytes` and 'bytes1024' modules for directly "humanising"
//// and formatting a number (`Float` or `Int`) to a `String`.
////
//// For more control (e.g. work with `time.Time` or `bytes.Bytes` directly, use the given unit instead of the most
//// optimal one), look at the `time`, `bytes` or `bytes1024` modules.

import gleam/float
import gleam/int
import gleam/time/calendar.{type Date, type TimeOfDay, Date, TimeOfDay}
import gleam/time/duration.{type Duration}
import gleam/time/timestamp.{type Timestamp}

import humanise/bytes
import humanise/bytes1024
import humanise/time
import humanise/util

/// Format a `Timestamp` relative to the provided current `Timestamp`.
///
/// This function finds the difference between the current time and the given time, and returns a string describing the
/// difference using the provided formatter. (e.g. `"in 2s"`, `"3 days, 12 hours ago"`)
///
/// Examples:
///
/// ```
/// let now = timestamp.system_time()
///
/// let from = now |> timestamp.add(duration.hours(36))
/// humanise.date_relative(from:, now:, with: time.to_string) // "in 1.5d" 
///
/// let from = now |> timestamp.add(duration.hours(-36))
/// humanise.date_relative(from:, now:, with: time.split(_, time.to_string_full)) // "1 day, 12 hours ago"
/// ```
pub fn date_relative(
  from date: Timestamp,
  now current: Timestamp,
  with format: fn(time.Time) -> String,
) -> String {
  let relative = current |> timestamp.difference(date) |> time.from_duration

  let #(value, constructor) = time.decompose(relative)

  case value >=. 0.0 {
    True -> "in " <> format(relative)
    False -> float.absolute_value(value) |> constructor |> format <> " ago"
  }
}

/// Format a `Date`, `TimeOfDay` pair, automatically omitting redundant information (omit year if it matches the current
/// year, omit month and day if it also matches the current day)
/// 
/// The given date will be compared against the provided "current" date to determine what information to omit.
///
/// This function does not currently support internationalization, and simply returns a string in the following
/// largest-to-smallest format:
/// ```
/// <maybe year> <maybe <month> <day>> <hours>:<minutes>:<seconds>
/// ```
/// Note that hours are in 24 hour format, not 12 hours with AM/PM.
pub fn date(from date: #(Date, TimeOfDay), now current: Date) -> String {
  let year_matches = case current, date.0 {
    Date(current, ..), Date(given, ..) if current == given -> True
    _, _ -> False
  }

  let day_matches = case current, date.0 {
    Date(_, _, current), Date(_, _, given) if current == given -> True
    _, _ -> False
  }

  let Date(year, month, day) = date.0
  let TimeOfDay(hours, minutes, seconds, _) = date.1

  let maybe_year = case year_matches {
    True -> ""
    False -> int.to_string(year) <> " "
  }
  let maybe_month = case year_matches && day_matches, month {
    True, _ -> ""
    _, calendar.April -> "April "
    _, calendar.August -> "August "
    _, calendar.December -> "December "
    _, calendar.February -> "February "
    _, calendar.January -> "January "
    _, calendar.July -> "July "
    _, calendar.June -> "June "
    _, calendar.March -> "March "
    _, calendar.May -> "May "
    _, calendar.November -> "November "
    _, calendar.October -> "October "
    _, calendar.September -> "September "
  }
  let maybe_day = case year_matches && day_matches {
    True -> ""
    False -> int.to_string(day) <> " "
  }

  let hours = case hours < 10 {
    True -> "0" <> int.to_string(hours)
    False -> int.to_string(hours)
  }
  let minutes = case minutes < 10 {
    True -> "0" <> int.to_string(minutes)
    False -> int.to_string(minutes)
  }
  let seconds = case seconds < 10 {
    True -> "0" <> int.to_string(seconds)
    False -> int.to_string(seconds)
  }

  maybe_year
  <> maybe_month
  <> maybe_day
  <> hours
  <> ":"
  <> minutes
  <> ":"
  <> seconds
}

/// Format a `Duration`, using the most optimal unit.
pub fn duration(from duration: Duration) -> String {
  time.from_duration(duration) |> time.to_string
}

/// Format *n* nanoseconds as a `Float`, converting to a more optimal unit if possible.
pub fn nanoseconds_float(from n: Float) -> String {
  time.Nanoseconds(n) |> time.humanise |> time.to_string
}

/// Format *n* nanoseconds as a `Float`, converting to a more optimal unit if possible.
pub fn nanoseconds_int(from n: Int) -> String {
  time.Nanoseconds(int.to_float(n)) |> time.humanise |> time.to_string
}

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

/// Format *n* months as a `Float`, converting to a more optimal unit if possible.
pub fn months_float(from n: Float) -> String {
  time.Months(n) |> time.humanise |> time.to_string
}

/// Format *n* months as an `Int`, converting to a more optimal unit if possible.
pub fn months_int(from n: Int) -> String {
  time.Months(int.to_float(n)) |> time.humanise |> time.to_string
}

/// Format *n* years as a `Float`, converting to a more optimal unit if possible.
pub fn years_float(from n: Float) -> String {
  time.Years(n) |> time.humanise |> time.to_string
}

/// Format *n* years as an `Int`, converting to a more optimal unit if possible.
pub fn years_int(from n: Int) -> String {
  time.Years(int.to_float(n)) |> time.humanise |> time.to_string
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

/// Convert from 1000-multiple `bytes.Bytes` to 1024-multiple `bytes1024.Bytes`.
pub fn bytes_to_bytes1024(from data: bytes.Bytes) -> bytes1024.Bytes {
  case data {
    bytes.Bytes(a) -> bytes1024.Bytes(a)
    bytes.Kilobytes(a) ->
      bytes1024.Kibibytes(a *. util.kilobyte /. util.kibibyte)
    bytes.Megabytes(a) ->
      bytes1024.Mebibytes(a *. util.megabyte /. util.mebibyte)
    bytes.Gigabytes(a) ->
      bytes1024.Gibibytes(a *. util.gigabyte /. util.gibibyte)
    bytes.Terabytes(a) ->
      bytes1024.Tebibytes(a *. util.terabyte /. util.tebibyte)
  }
}

/// Convert from 1000-multiple `bytes.Bytes` to 1024-multiple `bytes1024.Bytes`.
pub fn bytes1024_to_bytes(from data: bytes1024.Bytes) -> bytes.Bytes {
  case data {
    bytes1024.Bytes(a) -> bytes.Bytes(a)
    bytes1024.Kibibytes(a) ->
      bytes.Kilobytes(a *. util.kibibyte /. util.kilobyte)
    bytes1024.Mebibytes(a) ->
      bytes.Megabytes(a *. util.mebibyte /. util.megabyte)
    bytes1024.Gibibytes(a) ->
      bytes.Gigabytes(a *. util.gibibyte /. util.gigabyte)
    bytes1024.Tebibytes(a) ->
      bytes.Terabytes(a *. util.tebibyte /. util.terabyte)
  }
}
