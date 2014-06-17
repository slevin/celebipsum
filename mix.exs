defmodule Celebipsum.Mixfile do
  use Mix.Project

  def project do
    [app: :celebipsum,
     version: "0.0.1",
     build_per_environment: true,
     dynamos: [Celebipsum.Dynamo],
     compilers: [:elixir, :dynamo, :app],
     elixir: "~> 0.13.3",
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [ applications: [:cowboy, :dynamo],
      mod: {Celebipsum, []} ]
  end

  defp deps do
    [{:cowboy, github: "extend/cowboy"},
     { :dynamo, "~> 0.1.0-dev", github: "dynamo/dynamo" }]
  end
end
