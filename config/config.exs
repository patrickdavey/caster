# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :caster,
  ecto_repos: [Caster.Repo],
  root_downloads_directory: 'downloads'

# Configures the endpoint
config :caster, Caster.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "JjFnqhJT5xFHr0NUomVV2C9XX6KFlTH7QiqwSZZMIip1TEcug1EYbcGOwWYtvwRN",
  render_errors: [view: Caster.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Caster.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
