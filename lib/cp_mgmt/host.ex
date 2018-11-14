defmodule CpMgmt.Host do
  @moduledoc """
  This module manages simple host functions with the Web API
  """
  defstruct(status: nil, data: %{})
  alias CpMgmt.Host

  use Tesla

  plug(Tesla.Middleware.BaseUrl, Application.get_env(:cp_mgmt, :mgmt_server_url))
  plug(Tesla.Middleware.Headers, [{"X-chkp-sid", Application.get_env(:cp_mgmt, :sid)}])
  plug(Tesla.Middleware.JSON)

  @doc """
  Creates a host via the API.

  ## Examples
      iex> CpMgmt.Host.add("new_host", "10.1.1.1")
      {:ok,
        %CpMgmt.Host{
          data: %{
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
            "ipv4-address" => "10.1.2.2",
            "meta-info" => %{
              "creation-time" => %{
                "iso-8601" => "2018-11-14T09:38-0600",
                "posix" => 1542209881008
              },
              "creator" => "admin",
              "last-modifier" => "admin",
              "last-modify-time" => %{
                "iso-8601" => "2018-11-14T09:38-0600",
                "posix" => 1542209881008
              },
              "lock" => "unlocked",
              "validation-state" => "ok"
            },
            "name" => "new-test-host",
            "nat-settings" => %{"auto-rule" => false},
            "read-only" => true,
            "tags" => [],
            "type" => "host",
            "uid" => "40155317-2299-4747-8ccf-44f4cdbdc0f1"
          },
          status: 200
        }}

      iex> CpMgmt.Host.add("new_host", "10.1.1.1")
      {:error, error}
  """

  def add(name, ip_address) do
    CpMgmt.logged_in?()

    query_filter(post("/web_api/add-host", %{name: name, "ip-address": ip_address}))
    |> CpMgmt.publish()
  end

  @doc """
  Removes a Host

  ## Examples
      iex> CpMgmt.Host.remove("new_host")
      {:ok, %CpMgmt.Host{data: %{"message" => "OK"}, status: 200}}

      iex> CpMgmt.Host.remove("new_host")
      {:error, error}
  """
  def remove(name) do
    CpMgmt.logged_in?()

    query_filter(post("/web_api/delete-host", %{name: name}))
    |> CpMgmt.publish()
  end

  @doc """
  Shows a Host and returns same data as adding host
  """
  def show(name) do
    CpMgmt.logged_in?()

    query_filter(post("/web_api/show-host", %{name: name}))
  end

  @doc """
  Shows all hosts.

  ## Examples
      iex> CpMgmt.Host.show_hosts()
      {:ok,
        %CpMgmt.Host{
          data: %{
            "from" => 1,
            "objects" => [
              %{
                "domain" => %{
                  "domain-type" => "domain",
                  "name" => "SMC User",
                  "uid" => "41e821a0-3720-11e3-aa6e-0800200c9fde"
                },
                "ipv4-address" => "10.1.1.1",
                "name" => "blah",
                "type" => "host",
                "uid" => "e63489af-c7a3-4d41-84ba-87748037f590"
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
  def show_all(limit \\ 50, offset \\ 0, order \\ [], level \\ "standard") do
    CpMgmt.logged_in?()

    query_filter(
      post("/web_api/show-hosts", %{
        limit: limit,
        offset: offset,
        order: order,
        "details-level": level
      })
    )
  end

  defp query_filter(method) do
    case method do
      {:ok, response} ->
        %Tesla.Env{body: body} = response
        %Tesla.Env{status: status} = response

        case status do
          200 ->
            {:ok, %Host{status: status, data: body}}

          _ ->
            {:error, %{status: status, body: body}}
        end

      {:error, error} ->
        {:error, "Adding a host returned a #{error}"}
    end
  end
end
