use Mix.Config

config :db, Db.Repo,
  database: "binge_dev",
  username: "postgres",
  password: "postgres",
  pool: Ecto.Adapters.SQL.Sandbox
