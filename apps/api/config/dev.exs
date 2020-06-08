use Mix.Config

config :api, ApiWeb.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: []

config :logger, :console, format: "[$level] $message\n"

config :phoenix, :stacktrace_depth, 20

config :phoenix, :plug_init_mode, :runtime

config :api, Api.Guardian,
  issuer: "binge",
  secret_key: "o2ImcHK9l2DS+rxgf1/+7qXBrS6B3R0b+uIWcXrAv1xHYqbTaaBa23sOKVb+3tKX"
