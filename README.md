# humanise

[![Package Version](https://img.shields.io/hexpm/v/humanise)](https://hex.pm/packages/humanise)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/humanise/)

```sh
gleam add humanise
```
```gleam
import humanise
import humanise/time

pub fn main() {
  humanise.bytes_int(10_000) |> io.println // 10.0KB

  time.Seconds(0.5) |> time.humanise |> time.to_string |> io.println // 500.0ms
}
```

Further documentation can be found at <https://hexdocs.pm/humanise>.

## Development

```sh
gleam run   # Run the project
gleam test  # Run the tests
```
