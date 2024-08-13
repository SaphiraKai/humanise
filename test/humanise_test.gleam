import gleeunit
import gleeunit/should

import humanise/bytes
import humanise/bytes1024
import humanise/time

pub fn main() {
  gleeunit.main()
}

pub fn time_to_string_test() {
  time.Microseconds(800.0)
  |> time.to_string
  |> should.equal("800.0us")

  time.Milliseconds(1.125)
  |> time.to_string
  |> should.equal("1.13ms")

  time.Seconds(0.0)
  |> time.to_string
  |> should.equal("0.0s")

  time.Minutes(120.0)
  |> time.to_string
  |> should.equal("120.0m")

  time.Hours(25.555555)
  |> time.to_string
  |> should.equal("25.56h")

  time.Days(7.999)
  |> time.to_string
  |> should.equal("8.0d")

  time.Weeks(0.5)
  |> time.to_string
  |> should.equal("0.5w")
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
  |> should.equal(time.Microseconds(0.0))

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
  |> should.equal("800.0B")

  bytes.Kilobytes(1.125)
  |> bytes.to_string
  |> should.equal("1.13KB")

  bytes.Megabytes(0.0)
  |> bytes.to_string
  |> should.equal("0.0MB")

  bytes.Gigabytes(1200.0)
  |> bytes.to_string
  |> should.equal("1.2e3GB")

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
  |> should.equal("800.0B")

  bytes1024.Kibibytes(1.125)
  |> bytes1024.to_string
  |> should.equal("1.13KiB")

  bytes1024.Mebibytes(0.0)
  |> bytes1024.to_string
  |> should.equal("0.0MiB")

  bytes1024.Gibibytes(1200.0)
  |> bytes1024.to_string
  |> should.equal("1.2e3GiB")

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
