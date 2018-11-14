defmodule CpMgmtTest do
  use ExUnit.Case

  import Tesla.Mock

  setup do
    mock(fn
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
        url: "http://example.com/web_api/login/pass",
        body: [{"user", "admin"}, {"password", "vpn123"}]
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

  test "login failed" do
    assert {:error, resp} = CpMgmt.login()

    assert resp.status == 403
  end
end
