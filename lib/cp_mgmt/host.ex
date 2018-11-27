defmodule CpMgmt.Host do
  @moduledoc """
  This module manages simple host functions with the Web API
  """
  alias CpMgmt.Host
  defstruct(status: nil, data: %{})

  @doc """
  Creates a host via the API.

  ## Examples
      iex> CpMgmt.Host.add("new_host", "10.1.1.1", ["nat-settings": %{"auto-rule": true}])
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
      {:error, %Cpmgmt.Host{status: 402, data: %{error_data}}}
  """

  def add(name, ip_address, options \\ []) do
    params = Enum.into(options, %{name: name, "ip-address": ip_address})

    CpMgmt.logged_in?()
    |> Tesla.post("/web_api/add-host", params)
    |> CpMgmt.transform_response()
    |> CpMgmt.to_struct(%Host{})
    |> CpMgmt.publish()
  end

  @doc """
  Removes a Host

  ## Examples
      iex> CpMgmt.Host.remove("new_host")
      {:ok, %CpMgmt.Host{data: %{"message" => "OK"}, status: 200}}

      iex> CpMgmt.Host.remove("new_host")
      {:error, %Cpmgmt.Host{status: 402, data: %{error_data}}}
  """
  def remove(name) do
    CpMgmt.logged_in?()
    |> Tesla.post("/web_api/delete-host", %{name: name})
    |> CpMgmt.transform_response()
    |> CpMgmt.to_struct(%Host{})
    |> CpMgmt.publish()
  end

  @doc """
  Shows a Host and returns same data as adding host
  """
  def show(name) do
    CpMgmt.logged_in?()
    |> Tesla.post("/web_api/show-host", %{name: name})
    |> CpMgmt.transform_response()
    |> CpMgmt.to_struct(%Host{})
  end

  @doc """
  Shows all hosts.

  ## Examples
      iex> CpMgmt.Host.show_all()
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

      iex> CpMgmt.Host.show_all()
      {:error, %Cpmgmt.Host{status: 402, data: %{error_data}}}
  """
  def show_all(limit \\ 50, offset \\ 0, order \\ [], level \\ "standard") do
    CpMgmt.logged_in?()
    |> Tesla.post("/web_api/show-hosts", %{
      limit: limit,
      offset: offset,
      order: order,
      "details-level": level
    })
    |> CpMgmt.transform_response()
    |> CpMgmt.to_struct(%Host{})
  end
end
