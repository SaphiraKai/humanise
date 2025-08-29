import gleam/float
import gleam/int

pub const kilobyte = 1000.0

pub const megabyte = 1_000_000.0

pub const gigabyte = 1_000_000_000.0

pub const terabyte = 1_000_000_000_000.0

pub const kibibyte = 1024.0

pub const mebibyte = 1_048_576.0

pub const gibibyte = 1_073_741_824.0

pub const tebibyte = 1_099_511_627_776.0

pub const microsecond = 1000.0

pub const millisecond = 1_000_000.0

pub const second = 1_000_000_000.0

pub const minute = 60_000_000_000.0

pub const hour = 3_600_000_000_000.0

pub const day = 86_400_000_000_000.0

pub const week = 604_800_000_000_000.0

pub const month = 2_629_800_000_000_000.0

pub const year = 31_557_600_000_000_000.0

pub fn format(this n: Float, suffix suffix: String) -> String {
  let n = float.to_precision(n, 1)

  case float.floor(n) {
    // if `n` is an integer, avoid adding a trailing ".0"
    floor if floor == n -> int.to_string(float.round(floor)) <> suffix

    _ -> float.to_string(n) <> suffix
  }
}
