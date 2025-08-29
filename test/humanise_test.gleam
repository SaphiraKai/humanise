import gleam/time/calendar
import gleam/time/timestamp

import gleeunit
import gleeunit/should

import humanise
import humanise/bytes
import humanise/bytes1024
import humanise/time

pub fn main() {
  gleeunit.main()
}

pub fn time_to_string_test() {
  time.Microseconds(800.0)
  |> time.to_string
  |> should.equal("800us")

  time.Milliseconds(1.125)
  |> time.to_string
  |> should.equal("1.1ms")

  time.Seconds(0.0)
  |> time.to_string
  |> should.equal("0s")

  time.Minutes(120.0)
  |> time.to_string
  |> should.equal("120min")

  time.Hours(25.555555)
  |> time.to_string
  |> should.equal("25.6hr")

  time.Days(7.999)
  |> time.to_string
  |> should.equal("8d")

  time.Weeks(0.5)
  |> time.to_string
  |> should.equal("0.5wk")

  assert time.Months(12.0)
    |> time.to_string
    == "12mo"

  assert time.Years(0.5)
    |> time.to_string
    == "0.5yr"
}

pub fn time_humanise_test() {
  time.Microseconds(800.0)
  |> time.humanise
  |> should.equal(time.Microseconds(800.0))

  time.Milliseconds(1.125)
  |> time.humanise
  |> should.equal(time.Milliseconds(1.125))

  time.Seconds(0.0)
  |> time.humanise
  |> should.equal(time.Nanoseconds(0.0))

  time.Minutes(120.0)
  |> time.humanise
  |> should.equal(time.Hours(2.0))

  time.Hours(25.555555)
  |> time.humanise
  |> should.equal(time.Days(1.0648147916666666))

  time.Days(7.999)
  |> time.humanise
  |> should.equal(time.Weeks(1.1427142857142858))

  time.Weeks(0.5)
  |> time.humanise
  |> should.equal(time.Days(3.5))

  assert time.Months(18.0)
    |> time.humanise
    == time.Years(1.5)

  assert time.Years(0.5)
    |> time.humanise
    == time.Months(6.0)
}

pub fn time_conversion_test() {
  time.Microseconds(800.0)
  |> time.as_milliseconds
  |> should.equal(0.8)

  time.Milliseconds(1000.0)
  |> time.as_seconds
  |> should.equal(1.0)

  time.Seconds(0.0)
  |> time.as_seconds
  |> should.equal(0.0)

  time.Minutes(120.0)
  |> time.as_hours
  |> should.equal(2.0)

  time.Hours(25.555555)
  |> time.as_days
  |> should.equal(1.0648147916666666)

  time.Days(7.999)
  |> time.as_weeks
  |> should.equal(1.1427142857142858)

  time.Weeks(0.5)
  |> time.as_days
  |> should.equal(3.5)
}

pub fn bytes_to_string_test() {
  bytes.Bytes(800.0)
  |> bytes.to_string
  |> should.equal("800B")

  bytes.Kilobytes(1.125)
  |> bytes.to_string
  |> should.equal("1.1KB")

  bytes.Megabytes(0.0)
  |> bytes.to_string
  |> should.equal("0MB")

  bytes.Gigabytes(1200.0)
  |> bytes.to_string
  |> should.equal("1200GB")

  bytes.Terabytes(0.5)
  |> bytes.to_string
  |> should.equal("0.5TB")
}

pub fn bytes_humanise_test() {
  bytes.Bytes(800.0)
  |> bytes.humanise
  |> should.equal(bytes.Bytes(800.0))

  bytes.Kilobytes(1.125)
  |> bytes.humanise
  |> should.equal(bytes.Kilobytes(1.125))

  bytes.Megabytes(0.0)
  |> bytes.humanise
  |> should.equal(bytes.Bytes(0.0))

  bytes.Gigabytes(1200.0)
  |> bytes.humanise
  |> should.equal(bytes.Terabytes(1.2))

  bytes.Terabytes(0.5)
  |> bytes.humanise
  |> should.equal(bytes.Gigabytes(500.0))
}

pub fn bytes_conversion_test() {
  bytes.Bytes(800.0)
  |> bytes.as_kilobytes
  |> should.equal(0.8)

  bytes.Kilobytes(1.125)
  |> bytes.as_kilobytes
  |> should.equal(1.125)

  bytes.Megabytes(0.0)
  |> bytes.as_bytes
  |> should.equal(0.0)

  bytes.Gigabytes(1200.0)
  |> bytes.as_terabytes
  |> should.equal(1.2)

  bytes.Terabytes(0.5)
  |> bytes.as_gigabytes
  |> should.equal(500.0)
}

pub fn bytes1024_to_string_test() {
  bytes1024.Bytes(800.0)
  |> bytes1024.to_string
  |> should.equal("800B")

  bytes1024.Kibibytes(1.125)
  |> bytes1024.to_string
  |> should.equal("1.1KiB")

  bytes1024.Mebibytes(0.0)
  |> bytes1024.to_string
  |> should.equal("0MiB")

  bytes1024.Gibibytes(1200.0)
  |> bytes1024.to_string
  |> should.equal("1200GiB")

  bytes1024.Tebibytes(0.5)
  |> bytes1024.to_string
  |> should.equal("0.5TiB")
}

pub fn bytes1024_humanise_test() {
  bytes1024.Bytes(800.0)
  |> bytes1024.humanise
  |> should.equal(bytes1024.Bytes(800.0))

  bytes1024.Kibibytes(1.125)
  |> bytes1024.humanise
  |> should.equal(bytes1024.Kibibytes(1.125))

  bytes1024.Mebibytes(0.0)
  |> bytes1024.humanise
  |> should.equal(bytes1024.Bytes(0.0))

  bytes1024.Gibibytes(1200.0)
  |> bytes1024.humanise
  |> should.equal(bytes1024.Tebibytes(1.171875))

  bytes1024.Tebibytes(0.5)
  |> bytes1024.humanise
  |> should.equal(bytes1024.Gibibytes(512.0))
}

pub fn bytes1024_conversion_test() {
  bytes1024.Bytes(800.0)
  |> bytes1024.as_kibibytes
  |> should.equal(0.78125)

  bytes1024.Kibibytes(1.125)
  |> bytes1024.as_kibibytes
  |> should.equal(1.125)

  bytes1024.Mebibytes(0.0)
  |> bytes1024.as_bytes
  |> should.equal(0.0)

  bytes1024.Gibibytes(1200.0)
  |> bytes1024.as_tebibytes
  |> should.equal(1.171875)

  bytes1024.Tebibytes(0.5)
  |> bytes1024.as_gibibytes
  |> should.equal(512.0)
}

pub fn negative_numbers_humanise_test() {
  time.Hours(-48.0)
  |> time.humanise
  |> should.equal(time.Days(-2.0))

  bytes.Megabytes(-2000.0)
  |> bytes.humanise
  |> should.equal(bytes.Gigabytes(-2.0))

  bytes1024.Mebibytes(-4096.0)
  |> bytes1024.humanise
  |> should.equal(bytes1024.Gibibytes(-4.0))
}

pub fn date_relative_test() {
  humanise.date_relative(
    timestamp.from_unix_seconds(10),
    timestamp.from_unix_seconds(0),
    time.to_string,
  )
  |> should.equal("in 10s")

  humanise.date_relative(
    timestamp.from_unix_seconds(0),
    timestamp.from_unix_seconds(10),
    time.to_string_full,
  )
  |> should.equal("10 seconds ago")

  humanise.date_relative(
    timestamp.from_unix_seconds(604_800),
    timestamp.from_unix_seconds(0),
    time.to_string_full,
  )
  |> should.equal("in 1 week")
}

pub fn date_test() {
  humanise.date(
    timestamp.from_unix_seconds(0) |> timestamp.to_calendar(calendar.utc_offset),
    {
      timestamp.from_unix_seconds(0)
      |> timestamp.to_calendar(calendar.utc_offset)
    }.0,
  )
  |> should.equal("00:00:00")

  humanise.date(
    timestamp.from_unix_seconds(1)
      |> timestamp.to_calendar(calendar.utc_offset),
    {
      timestamp.from_unix_seconds(0)
      |> timestamp.to_calendar(calendar.utc_offset)
    }.0,
  )
  |> should.equal("00:00:01")

  humanise.date(
    timestamp.from_unix_seconds(60)
      |> timestamp.to_calendar(calendar.utc_offset),
    {
      timestamp.from_unix_seconds(0)
      |> timestamp.to_calendar(calendar.utc_offset)
    }.0,
  )
  |> should.equal("00:01:00")

  humanise.date(
    timestamp.from_unix_seconds(3600)
      |> timestamp.to_calendar(calendar.utc_offset),
    {
      timestamp.from_unix_seconds(0)
      |> timestamp.to_calendar(calendar.utc_offset)
    }.0,
  )
  |> should.equal("01:00:00")

  humanise.date(
    timestamp.from_unix_seconds(86_400)
      |> timestamp.to_calendar(calendar.utc_offset),
    {
      timestamp.from_unix_seconds(0)
      |> timestamp.to_calendar(calendar.utc_offset)
    }.0,
  )
  |> should.equal("January 2 00:00:00")

  humanise.date(
    timestamp.from_unix_seconds(31_536_000)
      |> timestamp.to_calendar(calendar.utc_offset),
    {
      timestamp.from_unix_seconds(0)
      |> timestamp.to_calendar(calendar.utc_offset)
    }.0,
  )
  |> should.equal("1971 January 1 00:00:00")
}

pub fn bytes_to_bytes1024_test() {
  assert humanise.bytes_to_bytes1024(bytes.Kilobytes(1.0))
    == bytes1024.Kibibytes(0.9765625)
  assert humanise.bytes_to_bytes1024(bytes.Megabytes(1.0))
    == bytes1024.Mebibytes(0.95367431640625)
  assert humanise.bytes_to_bytes1024(bytes.Gigabytes(1.0))
    == bytes1024.Gibibytes(0.9313225746154785)
  assert humanise.bytes_to_bytes1024(bytes.Terabytes(1.0))
    == bytes1024.Tebibytes(0.9094947017729282)
}

pub fn bytes1024_to_bytes_test() {
  assert humanise.bytes1024_to_bytes(bytes1024.Kibibytes(1.0))
    == bytes.Kilobytes(1.024)
  assert humanise.bytes1024_to_bytes(bytes1024.Mebibytes(1.0))
    == bytes.Megabytes(1.048576)
  assert humanise.bytes1024_to_bytes(bytes1024.Gibibytes(1.0))
    == bytes.Gigabytes(1.073741824)
  assert humanise.bytes1024_to_bytes(bytes1024.Tebibytes(1.0))
    == bytes.Terabytes(1.099511627776)
}

pub fn bytes_to_string_full_test() {
  assert bytes.Bytes(1.0) |> bytes.to_string_full == "1 byte"
  assert bytes.Terabytes(2.35) |> bytes.to_string_full == "2.4 terabytes"
}

pub fn bytes1024_to_string_full_test() {
  assert bytes1024.Bytes(1.0) |> bytes1024.to_string_full == "1 byte"
  assert bytes1024.Tebibytes(0.35) |> bytes1024.to_string_full
    == "0.4 tebibytes"
}

pub fn time_to_string_full_test() {
  assert time.Seconds(1.0) |> time.to_string_full == "1 second"
  assert time.Years(3.35) |> time.to_string_full == "3.4 years"
  assert time.Months(0.01) |> time.to_string_full == "0 months"
  assert time.Months(1.01) |> time.to_string_full == "1 month"
  assert time.Months(0.99) |> time.to_string_full == "1 month"
}

pub fn time_split_test() {
  assert time.Seconds(150.0) |> time.split(time.to_string_full)
    == "2 minutes, 30 seconds"
  assert time.Seconds(60.0) |> time.split(time.to_string) == "1min"
  assert time.Years(0.25) |> time.split(time.to_string_full) == "3 months"
  assert time.Months(1.033) |> time.split(time.to_string_full)
    == "1 month, 1 day"
}
