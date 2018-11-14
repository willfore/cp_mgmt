defmodule CpMgmt.Network do
  @moduledoc """
  This module manages simple network functions with the Web API
  """

  defstruct(status: nil, data: %{})
  alias CpMgmt.Network

  use Tesla

  plug(Tesla.Middleware.BaseUrl, Application.get_env(:cp_mgmt, :mgmt_server_url))
  plug(Tesla.Middleware.Headers, [{"X-chkp-sid", Application.get_env(:cp_mgmt, :sid)}])
  plug(Tesla.Middleware.JSON)

  @doc """
  Creates a Network via the API

  ## Examples
      iex> CpMgmt.Network.add("some-network", "10.0.0.0", "255.255.255.0")
      {:ok,
        %CpMgmt.Network{
          data: %{
            "broadcast" => "allow",
            "color" => "black",
            "comments" => "",
            "domain" => %{
              "domain-type" => "domain",
              "name" => "SMC User",
              "uid" => "41e821a0-3720-11e3-aa6e-0800200c9fde"
            },
            "groups" => [],
            "icon" => "NetworkObjects/network",
            "mask-length4" => 24,
            "meta-info" => %{
              "creation-time" => %{
                "iso-8601" => "2018-11-14T11:12-0600",
                "posix" => 1542215568367
              },
              "creator" => "admin",
              "last-modifier" => "admin",
              "last-modify-time" => %{
                "iso-8601" => "2018-11-14T11:12-0600",
                "posix" => 1542215568367
              },
              "lock" => "unlocked",
              "validation-state" => "ok"
            },
            "name" => "some-network",
            "nat-settings" => %{"auto-rule" => false},
            "read-only" => true,
            "subnet-mask" => "255.255.255.0",
            "subnet4" => "10.0.1.0",
            "tags" => [],
            "type" => "network",
            "uid" => "458c0e7b-e546-46f1-98f5-f92178b1b49b"
          },
          status: 200
        }}
      iex> CpMgmt.Network.add("some-network", "10.0.0.0", "255.255.255.0")
      {:error, %Cpmgmt.Nework{status: 402, data: %{error_data}}}
  """

  def add(name, subnet, subnet_mask) do
    CpMgmt.logged_in?()

    query_filter(
      post("/web_api/add-network", %{
        name: name,
        subnet: subnet,
        "subnet-mask": subnet_mask
      })
    )
    |> CpMgmt.publish()
  end

  @doc """
  Removes a Network

  ## Examples
      iex> CpMgmt.Network.remove("some-network")
      :ok, %CpMgmt.Network{data: %{"message" => "OK"}, status: 200}}

      iex> CpMgmt.Network.remove("some-network")
      {:error, %Cpmgmt.Nework{status: 402, data: %{error_data}}}
  """

  def remove(name) do
    CpMgmt.logged_in?()

    query_filter(post("/web_api/delete-network", %{name: name}))
    |> CpMgmt.publish()
  end

  @doc """
  Shows a Network

  ## Examples
      iex> CpMgmt.Network.show("some-network")
      {:ok,
        %CpMgmt.Network{
          data: %{
            "broadcast" => "allow",
            "color" => "black",
            "comments" => "",
            "domain" => %{
              "domain-type" => "domain",
              "name" => "SMC User",
              "uid" => "41e821a0-3720-11e3-aa6e-0800200c9fde"
            },
            "groups" => [],
            "icon" => "NetworkObjects/network",
            "mask-length4" => 24,
            "meta-info" => %{
              "creation-time" => %{
                "iso-8601" => "2018-11-14T11:22-0600",
                "posix" => 1542216156432
              },
              "creator" => "admin",
              "last-modifier" => "admin",
              "last-modify-time" => %{
                "iso-8601" => "2018-11-14T11:22-0600",
                "posix" => 1542216156432
              },
              "lock" => "unlocked",
              "validation-state" => "ok"
            },
            "name" => "some-network",
            "nat-settings" => %{"auto-rule" => false},
            "read-only" => false,
            "subnet-mask" => "255.255.255.0",
            "subnet4" => "10.0.0.0",
            "tags" => [],
            "type" => "network",
            "uid" => "d65e5f3d-24e3-442b-94a0-3659a67ec27d"
          },
          status: 200
        }}

      iex> CpMgmt.Network.show("some-network")
      {:error, %Cpmgmt.Nework{status: 402, data: %{error_data}}}

  """
  def show(name) do
    CpMgmt.logged_in?()

    query_filter(post("/web_api/show-network", %{name: name}))
  end

  @doc """
  Shows all Networks with the same information as show
  """
  def show_all do
    CpMgmt.logged_in?()

    query_filter(post("/web_api/show-networks", %{}))
  end

  defp query_filter(method) do
    case method do
      {:ok, response} ->
        %Tesla.Env{body: body} = response
        %Tesla.Env{status: status} = response

        case status do
          200 ->
            {:ok, %Network{status: status, data: body}}

          _ ->
            {:error, %Network{status: status, data: body}}
        end

      {:error, error} ->
        {:error, "Adding a host returned a #{error}"}
    end
  end
end
