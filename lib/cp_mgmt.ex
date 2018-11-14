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
          body: %{
            "api-server-version" => "1.3",
            "last-login-was-at" => %{
              "iso-8601" => "2018-11-13T15:37-0600",
              "posix" => 1542145054413
            },
            "session-timeout" => 600,
            "sid" => "ZXr5cyMAKb4PK_rozKhcTU7E53Uj80xU3NCr6mEzkaY",
            "uid" => "b9e0d483-164d-405e-96bd-4932da37d496",
            "url" => "https://example.com/web_api"
          },
          status: 200
        }}

      iex> CpMgmt.login
      {:error,
        %{
          body: %{
            "code" => "err_login_failed",
            "message" => "Authentication to server failed."
          },
          status: 403
        }}

      iex> CpMgmt.login
      {:error, some_network_error}

  """
  def login do
    user = Application.get_env(:cp_mgmt, :mgmt_user)
    pass = Application.get_env(:cp_mgmt, :mgmt_pass)

    case post("/web_api/login", %{user: user, password: pass}) do
      {:ok, response} ->
        %Tesla.Env{body: body} = response
        %Tesla.Env{status: status} = response

        case status do
          200 ->
            Application.put_env(:cp_mgmt, :sid, body["sid"], timeout: 600)
            Application.put_env(:cp_mgmt, :uid, body["uid"], timeout: 600)
            {:ok, %{status: status, body: body}}

          _ ->
            {:error, %{status: status, body: body}}
        end

      {:error, error} ->
        {:error, "Login returned a #{error}"}
    end
  end

  @doc """
  Runs the logout function to the management API. Unregisters the :sid and :uid from the env.

  ## Examples

      iex> CpMgmt.logout
      {:ok, %{body: %{"message" => "OK"}, status: 200}}

      iex> CpMgmt.logout
      {:error, %{error}}
  """
  def logout do
    sid = Application.get_env(:cp_mgmt, :sid)

    case post("/web_api/logout", %{}, headers: [{"X-chkp-sid", sid}]) do
      {:ok, response} ->
        %Tesla.Env{body: body} = response
        %Tesla.Env{status: status} = response

        Application.delete_env(:cp_mgmt, :sid)
        Application.delete_env(:cp_mgmt, :uid)
        {:ok, %{status: status, body: body}}

      {:error, error} ->
        {:error, "Logout returned #{error}"}
    end
  end

  @doc """
  Checks to see if the sid is currently stored. If not, issues login
  """
  def logged_in? do
    case Application.get_env(:cp_mgmt, :sid) do
      nil ->
        CpMgmt.login()

      _ ->
        ""
    end
  end

  @doc """
  Checks to see if the request was successful.
  If it was publishes changes to the management server. If not does nothing
  """
  def publish(response) do
    sid = Application.get_env(:cp_mgmt, :sid)

    case response do
      {:ok, data} ->
        CpMgmt.logged_in?()
        post("/web_api/publish", %{}, headers: [{"X-chkp-sid", sid}])
        {:ok, data}

      {:error, error} ->
        {:error, error}
    end
  end
end
