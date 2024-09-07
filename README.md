# KinoSheetex

<img style="aspect-ratio:1600/592;" src=".github/images/smart-cell.webp" alt="Smart Cell preview"/>

KinoSheetex is a Livebook smart cell for fetching rows from Google Sheets. Data is fetched using Google APIs and requires authorization – either using an API key (for public sheets) or a service account (for public and private sheets). For a detailed usage guide and instructions on obtaining authorization credentials, head over to the documentation: https://hexdocs.pm/kino_sheetex/.

## Installation

The package can be installed by adding `kino_sheetex` to `Mix.install/2`.

```elixir
Mix.install([
  {:kino_sheetex, "~> 0.4.0"}
])
```
