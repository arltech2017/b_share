defmodule BShare.MixProject do
  use Mix.Project

  def project do
    [
      app: :b_share,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {BShare, []}
    ]
  end

  defp deps do
    [
      {:json, "~> 1.2"},
      {:httpoison, "~> 1.1"},
      {:cowboy, "~> 2.4"},
      {:plug, "~> 1.5"}
    ]
  end
end
