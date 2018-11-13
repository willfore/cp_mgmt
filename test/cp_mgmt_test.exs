defmodule CpMgmtTest do
  use ExUnit.Case

  import Tesla.Mock

  setup do
    mock(fn
      %{method: :get, url: "http://example.com/hello"} ->
        %Tesla.Env{status: 200, body: "hello"}

      %{method: :post, url: "http://example.com/world"} ->
        json(%{"my" => "data"})

      %{method: :post, url: "http://example.com/web_api/login"} ->
        %Tesla.Env{
          status: 403,
          body: %{
            "code" => "err_login_failed",
            "message" => "Authentication to server failed."
          }
        }

      %{
        method: :post,
        url: "http://example.com/web_api/login/pass"
      } ->
        %Tesla.Env{
          status: 200,
          body: %{
            "api-server-version" => "1.3",
            "last-login-was-at" => %{
              "iso-8601" => "2018-11-12T17:54-0600",
              "posix" => 1_542_066_870_267
            },
            "session-timeout" => 600,
            "sid" => "OZs3Otw29wTF9sB_tLRNpNaJ_Al8u2LyBQMCp73fwoY",
            "uid" => "842f83cc-95a9-45b4-9646-24371d438419",
            "url" => "http://example.com/web_api/"
          }
        }
    end)

    :ok
  end

  test "list things" do
    assert {:ok, %Tesla.Env{} = env} = Tesla.get("http://example.com/hello")
    assert env.status == 200
    assert env.body == "hello"
  end

  test "login failed" do
    assert {:ok, %Tesla.Env{} = env} =
             Tesla.post("http://example.com/web_api/login", %{user: "me", password: "test"})

    assert env.status == 403
  end

  test "login successful" do
    assert {:ok, %Tesla.Env{} = env} =
             Tesla.post("http://example.com/web_api/login/pass", %{
               user: "admin",
               password: "test"
             })

    assert env.status == 200
    assert env.body["sid"] == "OZs3Otw29wTF9sB_tLRNpNaJ_Al8u2LyBQMCp73fwoY"
  end
end
