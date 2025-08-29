# humanise

[![Package Version](https://img.shields.io/hexpm/v/humanise)](https://hex.pm/packages/humanise)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/humanise/)

```sh
gleam add humanise
```
```gleam
import gleam/io

import humanise
import humanise/time

pub fn main() {
  humanise.bytes_int(10_000) |> io.println // 10KB

  time.Seconds(0.5) |> time.humanise |> time.to_string |> io.println // 500ms

  time.Hours(1.0) |> time.to_minutes |> echo // 60.0

  time.Months(1.075) |> time.split(time.to_string_full) |> io.println // 1 month, 2.3 days
}
```

Further documentation can be found at <https://hexdocs.pm/humanise>.

## Development

```sh
gleam run   # Run the project
gleam test  # Run the tests
```
