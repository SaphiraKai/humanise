import gleeunit
import gleeunit/should

import bytes
import time

pub fn main() {
  gleeunit.main()
}

// gleeunit test functions end in `_test`
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
