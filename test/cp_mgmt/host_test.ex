defmodule CpMgmt.HostTest do
  use ExUnit.Case

  import Tesla.Mock

  setup do
    mock(fn
      %{method: :post, url: "http://example.com/web_api/add-host"} ->
        %Tesla.Env{
          status: 403,
          body: %{
            "code" => "err_login_failed",
            "message" => "Authentication to server failed."
          }
        }
    end)

    :ok
  end

  test "login failed" do
    assert {:error, resp} = CpMgmt.login()
    # Tesla.login("http://example.com/web_api/login", %{user: "me", password: "test"})

    assert resp.status == 403
  end
end
