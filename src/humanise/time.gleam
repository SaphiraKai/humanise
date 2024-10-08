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

import util

const millisecond = 1000.0

const second = 1_000_000.0

const minute = 60_000_000.0

const hour = 3_600_000_000.0

const day = 86_400_000_000.0

const week = 604_800_000_000.0

/// The main type for holding time information.
///
/// Use its constructors directly to specify a unit for the value you want to format.
pub type Time {
  Microseconds(Float)
  Milliseconds(Float)
  Seconds(Float)
  Minutes(Float)
  Hours(Float)
  Days(Float)
  Weeks(Float)
}

/// Convert a value to microseconds.
///
/// Example:
/// ```
/// time.Milliseconds(1.0) |> time.as_microseconds // 1000.0
/// ```
pub fn as_microseconds(this time: Time) -> Float {
  case time {
    Microseconds(n) -> n
    Milliseconds(n) -> n *. millisecond
    Seconds(n) -> n *. second
    Minutes(n) -> n *. minute
    Hours(n) -> n *. hour
    Days(n) -> n *. day
    Weeks(n) -> n *. week
  }
}

/// Convert a value to milliseconds.
///
/// Example:
/// ```
/// time.Microseconds(1000.0) |> time.as_milliseconds // 1.0
/// ```
pub fn as_milliseconds(this time: Time) -> Float {
  as_microseconds(time) /. millisecond
}

/// Convert a value to seconds.
///
/// Example:
/// ```
/// time.Milliseconds(1000.0) |> time.as_seconds // 1.0
/// ```
pub fn as_seconds(this time: Time) -> Float {
  as_microseconds(time) /. second
}

/// Convert a value to minutes.
///
/// Example:
/// ```
/// time.Seconds(60.0) |> time.as_minutes // 1.0
/// ```
pub fn as_minutes(this time: Time) -> Float {
  as_microseconds(time) /. minute
}

/// Convert a value to hours.
///
/// Example:
/// ```
/// time.Minutes(60.0) |> time.as_hours // 1.0
/// ```
pub fn as_hours(this time: Time) -> Float {
  as_microseconds(time) /. hour
}

/// Convert a value to days.
///
/// Example:
/// ```
/// time.Hours(24.0) |> time.as_days // 1.0
/// ```
pub fn as_days(this time: Time) -> Float {
  as_microseconds(time) /. day
}

/// Convert a value to weeks.
///
/// Example:
/// ```
/// time.Days(7.0) |> time.as_weeks // 1.0
/// ```
pub fn as_weeks(this time: Time) -> Float {
  as_microseconds(time) /. week
}

/// Convert a value to a more optimal unit, if possible.
///
/// Example:
/// ```
/// time.Seconds(120.0) |> time.humanise // time.Minutes(2.0)
/// ```
pub fn humanise(this time: Time) -> Time {
  let us = as_microseconds(time)

  use <- bool.guard(when: us <. millisecond, return: Microseconds(us))
  use <- bool.guard(when: us <. second, return: Milliseconds(us /. millisecond))
  use <- bool.guard(when: us <. minute, return: Seconds(us /. second))
  use <- bool.guard(when: us <. hour, return: Minutes(us /. minute))
  use <- bool.guard(when: us <. day, return: Hours(us /. hour))
  use <- bool.guard(when: us <. week, return: Days(us /. day))

  Weeks(us /. week)
}

/// Format a value as a `String`, rounded to at most 2 decimal places, followed by a unit suffix.
///
/// Example:
/// ```
/// time.Seconds(30.125) |> time.to_string // "30.13s"
/// ```
pub fn to_string(this time: Time) -> String {
  let #(n, suffix) = case time {
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
