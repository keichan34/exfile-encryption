defmodule ExfileEncryption.Mixfile do
  use Mix.Project

  def project do
    [
      app: :exfile_encryption,
      version: "0.0.1",
      elixir: "~> 1.2",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps: deps
   ]
  end

  def application do
    [
      mod: {ExfileEncryption, []},
      applications: [
        :logger,
        :crypto,
        :exfile
      ]
    ]
  end

  defp deps do
    [
      {:exfile, "~> 0.2.3"}
    ]
  end
end
