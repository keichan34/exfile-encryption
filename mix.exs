defmodule ExfileEncryption.Mixfile do
  use Mix.Project

  def project do
    [
      app: :exfile_encryption,
      version: "0.0.1",
      elixir: "~> 1.2",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps: deps,
      source_url: "https://github.com/keichan34/exfile-encryption",
      docs: [
        extras: ["README.md", "FILE_FORMAT_1.md"]
      ],
      package: package,
      description: description
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
      {:exfile, "~> 0.3.1"},
      {:earmark, "~> 0.1", only: :dev},
      {:ex_doc, "~> 0.11", only: :dev}
    ]
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README.md", "LICENSE.txt"],
      maintainers: ["Keitaroh Kobayashi"],
      licenses: ["MIT"],
      links: %{
        "GitHub" => "https://github.com/keichan34/exfile-encryption",
        "Docs" => "http://hexdocs.pm/exfile_encryption/readme.html"
      }
    ]
  end

  defp description do
    """
    Transparent backend encryption / decryption for Exfile.
    """
  end
end
