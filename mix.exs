defmodule Exlibris.Mixfile do
  use Mix.Project

  @description """
  A collection of random library functions I use across multiple projects:

  pipe_while_ok: Create pipelines that terminate early if any step fails to return a tuple that starts {:ok, ...}

  before_returning: Like Ruby's returning, it evaluates its first argument, then evalates the do block. It always returns the value of its first argument.  
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
