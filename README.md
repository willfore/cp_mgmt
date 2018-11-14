# Check Point Management - Elixir

[![CircleCI](https://circleci.com/gh/willfore/cp_mgmt.svg?style=svg)](https://circleci.com/gh/willfore/cp_mgmt)

This is a very light wrapper to help simplify working with the Check Point Web API in R80.10 and above. Currently  not all options from the API are available but I plan on adding them going forward. 

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `cp_mgmt` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:cp_mgmt, "~> 1.0"}
  ]
end
```

## Setup

Specify the following in your `config/config.exs` or `config/<env>.exs` config file:

```elixir
config :cp_mgmt, mgmt_server_url: "https://some.ip.address:443"
config :cp_mgmt, mgmt_user: "<username>"
config :cp_mgmt, mgmt_pass: "<user_password>"
```
Note that it is usually a better practice to use env variables in place of staticly coding passwords via `System.get_env`.

Currently this support the following basic API actions:

- Loging In/Out
- Hosts
- Networks
- Access Control Layer

Please view the [Documentation](https://hexdocs.pm/cp_mgmt) for usage details and examples.
