defmodule KinoSheetex.MixProject do
  use Mix.Project

  def project do
    [
      app: :kino_sheetex,
      version: "0.4.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      docs: docs(),
      name: "KinoSheetex",
      description: description(),
      package: package(),
      source_url: "https://github.com/malinowskip/kino_sheetex",
      homepage_url: "https://github.com/malinowskip/kino_sheetex"
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {KinoSheetex.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:kino, "~> 0.13.2"},
      {:sheetex, "~> 0.4"},
      {:goth, "~> 1.4"},
      {:jason, "~> 1.0"},
      {:ex_doc, "~> 0.36.1", only: :dev, runtime: false}
    ]
  end

  defp docs do
    [
      main: "guide",
      source_url: "https://github.com/malinowskip/kino_livebook",
      extras: ["docs/guide.livemd"]
    ]
  end

  defp description do
    "A Livebook smart cell for fetching rows from Google Sheets."
  end

  defp package do
    [
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/malinowskip/kino_sheetex"}
    ]
  end
end
