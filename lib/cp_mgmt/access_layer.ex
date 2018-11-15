defmodule CpMgmt.AccessLayer do
  @moduledoc """
  This module manages simple Access Layer functions with the Web API
  """
  defstruct(status: nil, data: %{})
  alias CpMgmt.AccessLayer

  @doc """
  Creates an Access Layer via the API

  ## Examples
      iex> CpMgmt.AccessLayer.add("some-layer-name")
      {:ok,
      %CpMgmt.AccessLayer{
        data: %{
          "applications-and-url-filtering" => false,
          "color" => "black",
          "comments" => "",
          "content-awareness" => false,
          "domain" => %{
            "domain-type" => "domain",
            "name" => "SMC User",
            "uid" => "41e821a0-3720-11e3-aa6e-0800200c9fde"
          },
          "firewall" => true,
          "icon" => "ApplicationFirewall/rulebase",
          "implicit-cleanup-action" => "drop",
          "meta-info" => %{
            "creation-time" => %{
              "iso-8601" => "2018-11-14T22:09-0600",
              "posix" => 1542254971826
            },
            "creator" => "admin",
            "last-modifier" => "admin",
            "last-modify-time" => %{
              "iso-8601" => "2018-11-14T22:09-0600",
              "posix" => 1542254972362
            },
            "lock" => "locked by current session",
            "validation-state" => "ok"
          },
          "mobile-access" => false,
          "name" => "test",
          "read-only" => false,
          "shared" => false,
          "tags" => [],
          "type" => "access-layer",
          "uid" => "978ff99e-23c0-4d1e-84d2-3ec2b7e283c2"
        },
        status: 200
      }}

      iex> CpMgmt.AccessLayer.add("some-layer-name")
      {:error, %Cpmgmt.AccessLayer{status: 402, data: %{error_data}}}
  """
  def add(name) do
    CpMgmt.logged_in?()
    |> Tesla.post("/web_api/add-access-layer", %{name: name})
    |> CpMgmt.transform_response()
    |> CpMgmt.to_struct(%AccessLayer{})
    |> CpMgmt.publish()
  end

  @doc """
  Shows an Access layer

  ## Examples
      iex> CpMgmt.AccessLayer.show("some-layer-name")
      {:ok,
      %CpMgmt.AccessLayer{
        data: %{
          "applications-and-url-filtering" => false,
          "color" => "black",
          "comments" => "",
          "content-awareness" => false,
          "domain" => %{
            "domain-type" => "domain",
            "name" => "SMC User",
            "uid" => "41e821a0-3720-11e3-aa6e-0800200c9fde"
          },
          "firewall" => true,
          "icon" => "ApplicationFirewall/rulebase",
          "implicit-cleanup-action" => "drop",
          "meta-info" => %{
            "creation-time" => %{
              "iso-8601" => "2018-11-14T22:09-0600",
              "posix" => 1542254968431
            },
            "creator" => "admin",
            "last-modifier" => "admin",
            "last-modify-time" => %{
              "iso-8601" => "2018-11-14T22:09-0600",
              "posix" => 1542254969218
            },
            "lock" => "unlocked",
            "validation-state" => "ok"
          },
          "mobile-access" => false,
          "name" => "test",
          "read-only" => false,
          "shared" => false,
          "tags" => [],
          "type" => "access-layer",
          "uid" => "ebfd1aa4-a60a-4937-b882-ba01d939d62c"
        },
        status: 200
      }}

      iex> CpMgmt.AccessLayer.show("some-layer-name")
      {:error, %CpMgmt.AccessLayer{error, status}}
  """
  def show(name) do
    CpMgmt.logged_in?()
    |> Tesla.post("/web_api/show-access-layer", %{name: name})
    |> CpMgmt.transform_response()
    |> CpMgmt.to_struct(%AccessLayer{})
  end

  @doc """
  Removes an access layer

  ## Exmaples
      iex> CpMgmt.AccessLayer.remove("some-layer-name")
      {:ok, %CpMgmt.AccessLayer{data: %{"message" => "OK"}, status: 200}}

      iex> CpMgmt.AccessLayer.remove("some-layer-name")
      {:error, %CpMgmt.AccessLayer{error, status}}
  """
  def remove(name) do
    CpMgmt.logged_in?()
    |> Tesla.post("/web_api/delete-access-layer", %{name: name})
    |> CpMgmt.transform_response()
    |> CpMgmt.to_struct(%AccessLayer{})
    |> CpMgmt.publish()
  end

  @doc """
  Shows all Access Layers with the same information as show.
  """
  def show_all do
    CpMgmt.logged_in?()
    |> Tesla.post("/web_api/show-access-layers", %{})
    |> CpMgmt.transform_response()
    |> CpMgmt.to_struct(%AccessLayer{})
  end
end
