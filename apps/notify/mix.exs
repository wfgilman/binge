defmodule Notify.MixProject do
  use Mix.Project

  def project do
    [
      app: :notify,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      applications: [:ex_twilio, :pigeon, :kadabra],
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_twilio, "~> 0.9"},
      {:pigeon, "~> 1.6.1"},
      {:kadabra, "~> 0.6.0"}
    ]
  end
end
