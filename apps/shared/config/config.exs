use Mix.Config

config :appsignal, :config,
  name: "binge",
  env: Mix.env()

import_config "#{Mix.env()}.exs"
