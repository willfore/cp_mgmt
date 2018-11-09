defmodule CpMgmt.MixProject do
  use Mix.Project

  def project do
    [
      app: :cp_mgmt,
      version: "0.0.1",
      elixir: "~> 1.7",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      deps: deps(),
      name: "Check Point Management API",
      source_url: ""
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:tesla, "~> 1.2.0"},
      {:hackney, "~> 1.14"},
      {:jason, "~> 1.0"},
      {:ex_doc, "~> 0.14", only: :dev}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
    ]
  end

  defp description() do
    "A lightweight wrapper for using the Check Point Management API in your elixir projects"
  end

  defp package() do
    [
      organization: "Check Point Software Technologies LTD.",
      licenses: ["Apache 2.0"],
      links: %{"GitHub" => ""}
    ]
  end
end
