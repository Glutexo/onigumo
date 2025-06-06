defmodule Onigumo.MixProject do
  use Mix.Project

  def project do
    env = Mix.env()

    [
      app: :onigumo,
      version: "0.1.0",
      elixir: "~> 1.18",
      start_permanent: env == :prod,
      deps: deps(),
      escript: escript(),
      elixirc_paths: elixirc_paths(env)
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
      {:httpoison, "~> 1.8"},
      {:mox, "~> 1.0", only: :test},

      # Spider toolbox dependencies
      {:floki, "~> 0.32"}
    ]
  end

  def escript() do
    [
      main_module: Onigumo.CLI
    ]
  end

  defp elixirc_paths(:test), do: elixirc_paths_default() ++ ["test/support"]

  defp elixirc_paths(_), do: elixirc_paths_default()

  defp elixirc_paths_default(), do: Mix.Project.config()[:elixirc_paths]
end
