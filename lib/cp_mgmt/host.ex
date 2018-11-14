defmodule CpMgmt.Host do
  @moduledoc """
  This module manages simple host functions with the Web API
  """
  use Tesla

  plug(Tesla.Middleware.BaseUrl, Application.get_env(:cp_mgmt, :mgmt_server_url))
  plug(Tesla.Middleware.Headers, [{"X-chkp-sid", Application.get_env(:cp_mgmt, :sid)}])
  plug(Tesla.Middleware.JSON)

  @doc """
  Basic host creation via the API.

  ## Examples
      iex> CpMgmt.Host.add("new_host", "10.1.1.1")
      {:ok,
        %{
          body: %{
            "color" => "black",
            "comments" => "",
            "domain" => %{
              "domain-type" => "domain",
              "name" => "SMC User",
              "uid" => "41e821a0-3720-11e3-aa6e-0800200c9fde"
            },
            "groups" => [],
            "icon" => "Objects/host",
            "interfaces" => [],
            "ipv4-address" => "10.1.1.1",
            "meta-info" => %{
              "creation-time" => %{
                "iso-8601" => "2018-11-13T22:00-0600",
                "posix" => 1542168053411
              },
              "creator" => "admin",
              "last-modifier" => "admin",
              "last-modify-time" => %{
                "iso-8601" => "2018-11-13T22:00-0600",
                "posix" => 1542168053411
              },
              "lock" => "unlocked",
              "validation-state" => "ok"
            },
            "name" => "something",
            "nat-settings" => %{"auto-rule" => false},
            "read-only" => true,
            "tags" => [],
            "type" => "host",
            "uid" => "6375018c-d0da-4556-b010-a0ffb84cfb6c"
          },
          status: 200
        }}

      iex> CpMgmt.Host.add("new_host", "10.1.1.1")
      {:error, error}
  """

  def add(name, ip_address) do
    query_filter(post("/web_api/add-host", %{"name" => name, "ip-address" => ip_address}))
  end

  @doc """
  Removes a Host

  ## Examples
      iex> CpMgmt.Host.remove("new_host")
      {:ok, %{body: %{"message" => "OK"}, status: 200}}

      iex> CpMgmt.Host.remove("new_host")
      {:error, error}
  """
  def remove(name) do
    query_filter(post("/web_api/delete-host", %{name: name}))
  end

  @doc """
  Shows a Host and returns same data as adding host
  """
  def show(name) do
    query_filter(post("/web_api/show-host", %{name: name}))
  end

  @doc """
  Shows all hosts.

  ## Examples
      iex> CpMgmt.Host.show_hosts()
      {:ok,
        %{
          body: %{
            "from" => 1,
            "objects" => [
              %{
                "domain" => %{
                  "domain-type" => "domain",
                  "name" => "SMC User",
                  "uid" => "41e821a0-3720-11e3-aa6e-0800200c9fde"
                },
                "ipv4-address" => "1.1.1.1",
                "name" => "blah",
                "type" => "host",
                "uid" => "bee96166-0548-4a00-917c-88c4f6bffaee"
              }
            ],
            "to" => 1,
            "total" => 1
          },
          status: 200
        }}

      iex> CpMgmt.Host.show_hosts()
      {:error, error}
  """
  def show_hosts(limit \\ 50, offset \\ 0, order \\ []) do
    query_filter(post("/web_api/show-hosts", %{limit: limit, offset: offset, order: order}))
  end

  defp query_filter(method) do
    case method do
      {:ok, response} ->
        %Tesla.Env{body: body} = response
        %Tesla.Env{status: status} = response

        case status do
          200 ->
            {:ok, %{status: status, body: body}}

          _ ->
            {:error, %{status: status, body: body}}
        end

      {:error, error} ->
        {:error, "Adding a host returned a #{error}"}
    end
  end
end
