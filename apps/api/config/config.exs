# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :api, ApiWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "wgEIs62cpYK5r2sK/KwI6j3ZCkjcHAvly69wxBdGo5wGQA+uRG2dRZfCGmuuyn8G",
  render_errors: [view: ApiWeb.ErrorView, accepts: ~w(json)],
  pubsub_server: Api.PubSub

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :api, Api.Guardian,
  issuer: "binge",
  secret_key: "o2ImcHK9l2DS+rxgf1/+7qXBrS6B3R0b+uIWcXrAv1xHYqbTaaBa23sOKVb+3tKX"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
