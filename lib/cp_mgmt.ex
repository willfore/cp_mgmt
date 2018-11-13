defmodule CpMgmt do
  @moduledoc """
  This module manages simple functions with the Web API
  """
  use Tesla

  plug(Tesla.Middleware.BaseUrl, Application.get_env(:cp_mgmt, :mgmt_server_url))
  plug(Tesla.Middleware.JSON)

  @doc """
  Runs the login function to the management API, sets env for :sid and :uid as well as returning a touple
  with the status and response. Uses the user and password provided via the config params.

  ## Examples
      iex> CpMgmt.login
      {:ok,
        %{
          "api-server-version" => "1.3",
          "last-login-was-at" => %{
            "iso-8601" => "2018-11-13T11:06-0600",
            "posix" => 1542128764233
          },
          "session-timeout" => 600,
          "sid" => "t1GtzEMKvOgHG6snD-V2N_tdjbdLX4mnNg2oqgUOX0Q",
          "uid" => "f6329b50-7890-4929-a6e6-6d5a67c726d6",
          "url" => "https://example.com/web_api"
        }}

      iex> CpMgmt.login
      {:error, %{error}}

  """
  def login do
    user = Application.get_env(:cp_mgmt, :mgmt_user)
    pass = Application.get_env(:cp_mgmt, :mgmt_pass)

    case post("/web_api/login", %{user: user, password: pass}) do
      {:ok, response} ->
        %Tesla.Env{body: body} = response

        Application.put_env(:cp_mgmt, :sid, body["sid"], timeout: 600)
        Application.put_env(:cp_mgmt, :uid, body["uid"], timeout: 600)
        {:ok, body}

      {:error, error} ->
        {:error, "Login returned a #{error}"}
    end
  end
end
