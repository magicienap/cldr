defmodule Cldr.Mixfile do
  use Mix.Project

  def project do
    [app: :cldr,
     version: "0.0.1",
     elixir: "~> 0.14.2",
     description: description,
     package: package,
     deps: deps]
  end

  def application do
    [applications: []]
  end

  defp deps do
    []
  end

  defp description do
    """
    cldr is a library to use information from CLDR data.
    """
  end

  defp package do
    [
      contributors: ["Antoine Proulx"],
      licenses: ["MIT"],
      links: %{
        "GitHub" => "https://github.com/magicienap/cldr"
      }
    ]
  end
end
