defmodule CpMgmt do
  @moduledoc """
  This module manages simple functions with the Web API
  """
  @doc false
  def client(sid) do
    middleware =
      case sid do
        nil ->
          [
            {Tesla.Middleware.BaseUrl, Application.get_env(:cp_mgmt, :mgmt_server_url)},
            Tesla.Middleware.JSON
          ]

        {:error, error} ->
          [
            {Tesla.Middleware.BaseUrl, Application.get_env(:cp_mgmt, :mgmt_server_url)}
          ]

          IO.write(
            :stderr,
            "The server issued the following error on login: #{error.body["message"]}"
          )

        _ ->
          [
            {Tesla.Middleware.BaseUrl, Application.get_env(:cp_mgmt, :mgmt_server_url)},
            Tesla.Middleware.JSON,
            {Tesla.Middleware.Headers, [{"X-chkp-sid", sid}]}
          ]
      end

    middleware
    |> Tesla.client()
  end

  @doc """
  Runs the login function to the management API, sets env for :sid and :uid as well and returns sid to be used in the
  `CpMgmt.logged_in?/0` function. Uses the user and password provided via the config params.

  ## Examples
      iex> CpMgmt.login
      {:ok, "some_sid"}

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
    client = CpMgmt.client(nil)
    user = Application.get_env(:cp_mgmt, :mgmt_user)
    pass = Application.get_env(:cp_mgmt, :mgmt_pass)

    case Tesla.post(client, "/web_api/login", %{user: user, password: pass}) do
      {:ok, response} ->
        %Tesla.Env{body: body} = response
        %Tesla.Env{status: status} = response

        case status do
          200 ->
            Application.put_env(:cp_mgmt, :sid, body["sid"], timeout: 600)
            Application.put_env(:cp_mgmt, :uid, body["uid"], timeout: 600)
            body["sid"]

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
    client = CpMgmt.client(sid)

    case Tesla.post(client, "/web_api/logout", %{}) do
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
    sid = Application.get_env(:cp_mgmt, :sid)

    case sid do
      nil ->
        CpMgmt.login()
        |> CpMgmt.client()

      _ ->
        sid
        |> CpMgmt.client()
    end
  end

  @doc """
  Checks to see if the request was successful.
  If it was publishes changes to the management server. If not does nothing
  """
  def publish(response) do
    sid = Application.get_env(:cp_mgmt, :sid)
    client = CpMgmt.client(sid)

    case response do
      {:ok, data} ->
        CpMgmt.logged_in?()
        Tesla.post(client, "/web_api/publish", %{})
        {:ok, data}

      {:error, error} ->
        {:error, error}
    end
  end

  @doc """
  Transforms the Tesla response to a filtered version for use with `CpMgmt.to_struct/1`
  """
  def transform_response(response) do
    case response do
      {:ok, data} ->
        %Tesla.Env{body: body} = data
        %Tesla.Env{status: status} = data

        case status do
          200 ->
            {:ok, %{status: status, data: body}}

          _ ->
            {:error, %{status: status, data: body}}
        end

      {:error, error} ->
        {:error, error}
    end
  end

  @doc """
  Takes `CpMgmt.transform_response/1` and the given struct, then converts it to the struct for the calling module
  """
  def to_struct(data, module_struct) do
    {answer, map} = data
    {answer, struct(module_struct, data: map.data, status: map.status)}
  end

  @doc """
  Installs the specified policy package on the specified gateway or gatewayas.

  ## Examples
      Specifing a single gateway to install on.
      iex> CpMgmt.install_policy("policy-package-name", "someGW")

      You can also specify a list of gateways to install on
      iex> CpMgmt.install_policy("policy-package-name", ["someGW", "someOtherGW", "yetAnotherGW"])

      iex> CpMgmt.install_policy("policy-package-name", "someGW")
      {:error, %{error}}
  """
  def install_policy(package, gateways) do
    CpMgmt.logged_in?()
    |> Tesla.post("/web_api/install-policy", %{"policy-package": package, targets: gateways})
    |> CpMgmt.transform_response()
  end

  @doc """
  Runs verification on the specified policy package.

  ## Examples
      iex> CpMgmt.verify_policy("policy-package-name")

      iex> CpMgmt.verify_policy("policy-package-name")
      {:error, %{error}}
  """
  def verify_policy(package) do
    CpMgmt.logged_in?()
    |> Tesla.post("/web_api/verify-policy", %{"policy-package": package})
    |> CpMgmt.transform_response()
  end
end
