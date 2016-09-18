use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :caster, Caster.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :caster, Caster.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "caster_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :caster, :vim_api, Caster.Feed.VimCastFeed.TestClient
