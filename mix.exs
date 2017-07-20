defmodule Caster.Mixfile do
  use Mix.Project

  def project do
    [app: :caster,
     version: "0.0.1",
     elixir: "~> 1.2",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix, :gettext] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     aliases: aliases(),
     deps: deps()]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [mod: {Caster, []},
     applications: app_list(Mix.env)]
  end

  defp app_list do
    [:phoenix, :phoenix_pubsub, :phoenix_html, :cowboy, :logger, :gettext, :timex_ecto,
     :phoenix_ecto, :httpoison, :postgrex]
  end

  def app_list(:test) do
    [ :hound | app_list() ]
  end

  def app_list(_), do: app_list()

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [{:phoenix, "~> 1.2.1"},
     {:phoenix_pubsub, "~> 1.0"},
     {:phoenix_ecto, "~> 3.0"},
     {:credo, "~> 0.4", only: [:dev, :test]},
     {:temp, "~> 0.4", only: [:test]},
     {:postgrex, ">= 0.0.0"},
     {:phoenix_html, "~> 2.7"},
     {:phoenix_live_reload, "~> 1.0", only: :dev},
     {:timex, "~> 3.0"},
     {:timex_ecto, "~> 3.0"},
     {:gettext, "~> 0.11"},
     {:httpoison, "~> 0.9.0"},
     {:feeder_ex, "~> 0.0.4"},
     {:hound, "~> 1.0", only: :test},
     {:cowboy, "~> 1.0"}]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    ["ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
     "ecto.reset": ["ecto.drop", "ecto.setup"],
     "test": ["ecto.create --quiet", "ecto.migrate", "test"]]
  end
end
