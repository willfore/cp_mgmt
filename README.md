# Check Point Management - Elixir

This wrapper makes use of the Check Point Web API available in R80.10 and above. Not all options from the API are available currently but I plan on adding them going forward. 

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `cp_mgmt` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:cp_mgmt, "~> 0.0.1"}
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

## Loging In/Out

You can login and out of your management server by using the following:

`CpMgmt.login()`
`CpMgmt.logout()`

`CpMgmt.login()` will utilize the credentials configured in the above setup step.

## Working with Hosts

Currently we provide the ability to add and remove hosts via the following commands.



Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/cp_mgmt](https://hexdocs.pm/cp_mgmt).

