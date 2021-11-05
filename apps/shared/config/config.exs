use Mix.Config

config :appsignal, :config,
  name: "binge",
  env: Mix.env()

config :shared,
  aws_s3_url: "https://binge-pics.s3.us-west-1.amazonaws.com/"

import_config "#{Mix.env()}.exs"
