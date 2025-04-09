//// This module contains functions for formatting durations of time to `String`s (e.g. `"100.0ms"`, `"1.5s"`).
////
//// Usage generally looks like this:
//// ```
//// time.Millisecond(2000.0) |> time.humanise |> time.to_string // "2.0s"
//// 
//// // or, if you don't want to change the unit
//// time.Millisecond(2000.0) |> time.to_string // "2000.0ms"
//// ```

import gleam/bool
import gleam/float

import util

const microsecond = 1000.0

const millisecond = 1_000_000.0

const second = 1_000_000_000.0

const minute = 60_000_000_000.0

const hour = 3_600_000_000_000.0

const day = 86_400_000_000_000.0

const week = 604_800_000_000_000.0

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
    Microseconds(n) -> n *. microsecond
    Milliseconds(n) -> n *. millisecond
    Seconds(n) -> n *. second
    Minutes(n) -> n *. minute
    Hours(n) -> n *. hour
    Days(n) -> n *. day
    Weeks(n) -> n *. week
  }
}

/// Convert a value to microseconds.
///
/// Example:
/// ```
/// time.Nanoseconds(1000.0) |> time.as_microseconds // 1.0
/// ```
pub fn as_microseconds(this time: Time) -> Float {
  as_nanoseconds(time) /. microsecond
}

/// Convert a value to milliseconds.
///
/// Example:
/// ```
/// time.Microseconds(1000.0) |> time.as_milliseconds // 1.0
/// ```
pub fn as_milliseconds(this time: Time) -> Float {
  as_nanoseconds(time) /. millisecond
}

/// Convert a value to seconds.
///
/// Example:
/// ```
/// time.Milliseconds(1000.0) |> time.as_seconds // 1.0
/// ```
pub fn as_seconds(this time: Time) -> Float {
  as_nanoseconds(time) /. second
}

/// Convert a value to minutes.
///
/// Example:
/// ```
/// time.Seconds(60.0) |> time.as_minutes // 1.0
/// ```
pub fn as_minutes(this time: Time) -> Float {
  as_nanoseconds(time) /. minute
}

/// Convert a value to hours.
///
/// Example:
/// ```
/// time.Minutes(60.0) |> time.as_hours // 1.0
/// ```
pub fn as_hours(this time: Time) -> Float {
  as_nanoseconds(time) /. hour
}

/// Convert a value to days.
///
/// Example:
/// ```
/// time.Hours(24.0) |> time.as_days // 1.0
/// ```
pub fn as_days(this time: Time) -> Float {
  as_nanoseconds(time) /. day
}

/// Convert a value to weeks.
///
/// Example:
/// ```
/// time.Days(7.0) |> time.as_weeks // 1.0
/// ```
pub fn as_weeks(this time: Time) -> Float {
  as_nanoseconds(time) /. week
}

/// Convert a value to a more optimal unit, if possible.
///
/// Example:
/// ```
/// time.Seconds(120.0) |> time.humanise // time.Minutes(2.0)
/// ```
pub fn humanise(this time: Time) -> Time {
  let abs = float.absolute_value
  let ns = as_nanoseconds(time)

  use <- bool.guard(when: abs(ns) <. microsecond, return: Nanoseconds(ns))
  use <- bool.guard(
    when: abs(ns) <. millisecond,
    return: Microseconds(ns /. microsecond),
  )
  use <- bool.guard(
    when: abs(ns) <. second,
    return: Milliseconds(ns /. millisecond),
  )
  use <- bool.guard(when: abs(ns) <. minute, return: Seconds(ns /. second))
  use <- bool.guard(when: abs(ns) <. hour, return: Minutes(ns /. minute))
  use <- bool.guard(when: abs(ns) <. day, return: Hours(ns /. hour))
  use <- bool.guard(when: abs(ns) <. week, return: Days(ns /. day))

  Weeks(ns /. week)
}

/// Format a value as a `String`, rounded to at most 2 decimal places, followed by a unit suffix.
///
/// Example:
/// ```
/// time.Seconds(30.125) |> time.to_string // "30.13s"
/// ```
pub fn to_string(this time: Time) -> String {
  let #(n, suffix) = case time {
    Nanoseconds(ns) -> #(ns, "ns")
    Microseconds(us) -> #(us, "us")
    Milliseconds(ms) -> #(ms, "ms")
    Seconds(s) -> #(s, "s")
    Minutes(m) -> #(m, "m")
    Hours(h) -> #(h, "h")
    Days(d) -> #(d, "d")
    Weeks(w) -> #(w, "w")
  }

  util.format(n, suffix)
}
