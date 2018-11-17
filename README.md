# Check Point Management - Elixir

[![CircleCI](https://circleci.com/gh/willfore/cp_mgmt.svg?style=svg)](https://circleci.com/gh/willfore/cp_mgmt)

This is a very light wrapper to help simplify working with the Check Point Web API in R80.10 and above. Currently  not all options from the API are available but I plan on adding them going forward. This project depends heavily on [Tesla](https://github.com/teamon/tesla) so you can technically run any Tesla based command inside this project as well. It has been developed using the 1.3 Version of the Check Point Management API. I would recommend using the [API Documentation](https://sc1.checkpoint.com/documents/latest/APIs/index.html#introduction~v1.3%20) as a reference as some of the functions accept an options map. You will need to reference this documentation to discover which options can be passed.

## *Note that this is in very early stages and is being developed on often. I would recommend not running the master branch unless you are willing to expierence outages or behavioral issues.*

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
config :cp_mgmt, mgmt_server_url: "https://some.ip.address"
config :cp_mgmt, mgmt_user: "<username>"
config :cp_mgmt, mgmt_pass: "<user_password>"
```
Note that it is usually a better practice to use env variables in place of staticly coding passwords via `config.exs`.

Currently this support the following basic API actions:

- Loging In/Out (This is automatic)
- Hosts `CpMgmt.Host`
- Networks `CpMgmt.Network`
- Access Layer `CpMgmt.AccessLayer`
- Access Rules `CpMgmt.AccessRule`
- Verify Policy `CpMgmt.verify_policy`
- Install Policy `CpMgmt.install_policy`

## Basic Usage

All requests will return a struct with the function status as well as the data returned from the API server and its web API status:

Successful Request:

`{:ok, %CpMgmt.Host{data: %{request_data}, status: 200}`

Failed Request:

`{:error, %Cpmgmt.Host{status: 402, data: %{error_data}}}`

Each Module has the same naming convention to make usage easy. The [Documentation](https://hexdocs.pm/cp_mgmt) is pretty thorough at this point with examples of each function and its return. Below is an example of adding a host.

`CpMgmt.Host.add("test-host", "1.1.1.1")`


Please view the [Documentation](https://hexdocs.pm/cp_mgmt) for usage details and examples.
