//// This module contains functions for formatting durations of time to `String`s (e.g. `"101.5ms"`, `"1 minute, 30 seconds"`).
////
//// Usage generally looks like this:
//// ```
//// time.Millisecond(2000.0) |> time.humanise |> time.to_string // "2s"
////
//// // or, if you don't want to change the unit
//// time.Millisecond(2000.0) |> time.to_string // "2000ms"
//// ```

import gleam/float
import gleam/time/duration.{type Duration}

import humanise/util

/// The main type for holding time information.
///
/// Use its constructors directly to specify a unit for the value you want to format.
pub type Time {
  Nanoseconds(Float)
  Microseconds(Float)
  Milliseconds(Float)
  Seconds(Float)
  Minutes(Float)
  Hours(Float)
  Days(Float)
  Weeks(Float)
  Months(Float)
  Years(Float)
}

/// Convert a Duration from `gleam/time`.
///
/// Example:
/// ```
/// duration.seconds(120) |> time.from_duration // time.Minutes(2.0)
/// ```
pub fn from_duration(this duration: Duration) -> Time {
  Seconds(duration |> duration.to_seconds) |> humanise
}

/// Convert a value to nanoseconds.
///
/// Example:
/// ```
/// time.Microseconds(1.0) |> time.as_nanoseconds // 1000.0
/// ```
pub fn as_nanoseconds(this time: Time) -> Float {
  case time {
    Nanoseconds(n) -> n
    Microseconds(n) -> n *. util.microsecond
    Milliseconds(n) -> n *. util.millisecond
    Seconds(n) -> n *. util.second
    Minutes(n) -> n *. util.minute
    Hours(n) -> n *. util.hour
    Days(n) -> n *. util.day
    Weeks(n) -> n *. util.week
    Months(n) -> n *. util.month
    Years(n) -> n *. util.year
  }
}

/// Convert a value to microseconds.
///
/// Example:
/// ```
/// time.Nanoseconds(1000.0) |> time.as_microseconds // 1.0
/// ```
pub fn as_microseconds(this time: Time) -> Float {
  as_nanoseconds(time) /. util.microsecond
}

/// Convert a value to milliseconds.
///
/// Example:
/// ```
/// time.Microseconds(1000.0) |> time.as_milliseconds // 1.0
/// ```
pub fn as_milliseconds(this time: Time) -> Float {
  as_nanoseconds(time) /. util.millisecond
}

/// Convert a value to seconds.
///
/// Example:
/// ```
/// time.Milliseconds(1000.0) |> time.as_seconds // 1.0
/// ```
pub fn as_seconds(this time: Time) -> Float {
  as_nanoseconds(time) /. util.second
}

/// Convert a value to minutes.
///
/// Example:
/// ```
/// time.Seconds(60.0) |> time.as_minutes // 1.0
/// ```
pub fn as_minutes(this time: Time) -> Float {
  as_nanoseconds(time) /. util.minute
}

/// Convert a value to hours.
///
/// Example:
/// ```
/// time.Minutes(60.0) |> time.as_hours // 1.0
/// ```
pub fn as_hours(this time: Time) -> Float {
  as_nanoseconds(time) /. util.hour
}

/// Convert a value to days.
///
/// Example:
/// ```
/// time.Hours(24.0) |> time.as_days // 1.0
/// ```
pub fn as_days(this time: Time) -> Float {
  as_nanoseconds(time) /. util.day
}

/// Convert a value to weeks.
///
/// Example:
/// ```
/// time.Days(7.0) |> time.as_weeks // 1.0
/// ```
pub fn as_weeks(this time: Time) -> Float {
  as_nanoseconds(time) /. util.week
}

/// Convert a value to months.
///
/// Example:
/// ```
/// time.Years(1.0) |> time.as_months // 12.0
/// ```
pub fn as_months(this time: Time) -> Float {
  as_nanoseconds(time) /. util.month
}

/// Convert a value to years.
///
/// Example:
/// ```
/// time.Months(12.0) |> time.as_years // 1.0
/// ```
pub fn as_years(this time: Time) -> Float {
  as_nanoseconds(time) /. util.year
}

/// Convert a value to a more optimal unit, if possible.
///
/// Example:
/// ```
/// time.Seconds(120.0) |> time.humanise // time.Minutes(2.0)
/// ```
pub fn humanise(this time: Time) -> Time {
  let ns = as_nanoseconds(time)

  case float.absolute_value(ns) {
    abs_ns if abs_ns <. util.microsecond -> Nanoseconds(ns)
    abs_ns if abs_ns <. util.millisecond -> Microseconds(ns /. util.microsecond)
    abs_ns if abs_ns <. util.second -> Milliseconds(ns /. util.millisecond)
    abs_ns if abs_ns <. util.minute -> Seconds(ns /. util.second)
    abs_ns if abs_ns <. util.hour -> Minutes(ns /. util.minute)
    abs_ns if abs_ns <. util.day -> Hours(ns /. util.hour)
    abs_ns if abs_ns <. util.week -> Days(ns /. util.day)
    abs_ns if abs_ns <. util.month -> Weeks(ns /. util.week)
    abs_ns if abs_ns <. util.year -> Months(ns /. util.month)
    _ -> Years(ns /. util.year)
  }
}

/// Format a value as a `String`, rounded to at most 1 decimal place, followed by an abbreviated unit suffix.
///
/// Example:
/// ```
/// time.Seconds(30.125) |> time.to_string // "30.1s"
/// ```
pub fn to_string(this time: Time) -> String {
  let #(n, suffix) = case time {
    Nanoseconds(ns) -> #(ns, "ns")
    Microseconds(us) -> #(us, "us")
    Milliseconds(ms) -> #(ms, "ms")
    Seconds(s) -> #(s, "s")
    Minutes(min) -> #(min, "min")
    Hours(hr) -> #(hr, "hr")
    Days(d) -> #(d, "d")
    Weeks(wk) -> #(wk, "wk")
    Months(mo) -> #(mo, "mo")
    Years(yr) -> #(yr, "yr")
  }

  util.format(n, suffix)
}

/// Format a value as a `String`, rounded to at most 1 decimal place, followed by a long unit suffix.
///
/// Examples:
/// ```
/// time.Seconds(30.125) |> time.to_string_full // "30.1 seconds"
/// time.Minutes(1.0) |> time.to_string_full // "1 minute"
/// ```
pub fn to_string_full(this time: Time) -> String {
  let #(n, suffix) = case time {
    Nanoseconds(ns) -> #(ns, " nanosecond")
    Microseconds(us) -> #(us, " microsecond")
    Milliseconds(ms) -> #(ms, " millisecond")
    Seconds(s) -> #(s, " second")
    Minutes(min) -> #(min, " minute")
    Hours(hr) -> #(hr, " hour")
    Days(day) -> #(day, " day")
    Weeks(wk) -> #(wk, " week")
    Months(mo) -> #(mo, " month")
    Years(yr) -> #(yr, " year")
  }

  let plural = case float.to_precision(n, 1) {
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
/// let #(value, constructor) = time.decompose(time.Minutes(2.0)) // #(2.0, time.Minutes)
///
/// constructor(value *. 2.0) // time.Minutes(4.0)
/// ```
pub fn decompose(time: Time) -> #(Float, fn(Float) -> Time) {
  case time {
    Nanoseconds(a) -> #(a, Nanoseconds)
    Microseconds(a) -> #(a, Microseconds)
    Milliseconds(a) -> #(a, Milliseconds)
    Seconds(a) -> #(a, Seconds)
    Minutes(a) -> #(a, Minutes)
    Hours(a) -> #(a, Hours)
    Days(a) -> #(a, Days)
    Weeks(a) -> #(a, Weeks)
    Months(a) -> #(a, Months)
    Years(a) -> #(a, Years)
  }
}

/// Format a value as a `String`, split into integer and fractional components.
///
/// Make sure to provide it with a function to format with, such as `to_string` or `to_string_full`!
/// 
/// Examples:
/// ```
/// time.Minutes(1.75) |> time.split(with: time.to_string_full) // "1 minute, 45 seconds"
/// time.Minutes(1.75) |> time.split(with: time.to_string) // "1min, 45s"
/// ```
pub fn split(this time: Time, with format: fn(Time) -> String) -> String {
  let #(value, constructor) = humanise(time) |> decompose
  let assert Ok(frac) = float.modulo(value, 1.0)

  let larger = constructor(value |> float.floor)
  let smaller = constructor(frac) |> humanise

  case frac {
    0.0 -> format(larger)
    _ -> format(larger) <> ", " <> format(smaller)
  }
}
// pub fn split_multi(
//   this time: Time,
//   max_segments segments: Int,
//   min_unit unit: fn(Float) -> Time,
//   with format: fn(Time) -> String,
// ) -> String {
//   do_split_multi(time, segments, unit, format, [])
// }

// fn do_split_multi(
//   time: Time,
//   remaining: Int,
//   unit,
//   format,
//   acc: List(#(Float, fn(Float) -> Time)),
// ) -> String {
//   case remaining {
//     0 ->
//       acc
//       |> list.map(fn(a) { format(a.1(a.0)) })
//       |> list.reverse
//       |> string.join(", ")

//     _ -> {
//       let #(value, constructor) = humanise(time) |> decompose
//       let assert Ok(frac) = float.modulo(value, 1.0)

//       let next = constructor(frac) |> humanise

//       let min_unit = unit(value) |> as_nanoseconds
//       let current_unit = constructor(value) |> as_nanoseconds

//       let remaining = case
//         float.to_precision(frac, 1),
//         min_unit >=. current_unit
//       {
//         0.0, _ | _, True -> 0
//         _, _ -> remaining - 1
//       }

//       let segment = case remaining {
//         0 -> constructor(value |> float.round |> int.to_float)
//         _ -> constructor(value |> float.floor)
//       }

//       do_split_multi(next, remaining, unit, format, [segment, ..acc])
//     }
//   }
// }
