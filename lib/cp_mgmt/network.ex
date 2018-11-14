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
      iex> CpMgmt.Network.add("some_network", "10.0.0.0", "255.255.255.254")

      iex> CpMgmt.Network.add("some_network", "10.0.0.0", "255.255.255.254")
      {:error, error}
  """

  def add(name, subnet, subnet_mask) do
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
            {:error, %{status: status, body: body}}
        end

      {:error, error} ->
        {:error, "Adding a host returned a #{error}"}
    end
  end
end
