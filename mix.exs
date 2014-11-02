defmodule Exlibris.Mixfile do
  use Mix.Project

  @description """
  """

  @package [
    files:        [ "lib", "mix.exs", "README.md", "LICENSE.md" ],
    contributors: [ "Dave Thomas <dave@pragprog.org>"],
    licenses:     [ "MIT. See LICENSE.md" ],
    links:        %{
                    "GitHub" => "https://github.com/pragdave/exlibris",
                  }
  ]

  def project do
    [
      app:         :exlibris,
      version:     "0.0.1",
      elixir:      ">= 1.0.0",
      deps:        [],
      description: @description,
      package:     @package,
    ]
  end

  def application, do: []

end
