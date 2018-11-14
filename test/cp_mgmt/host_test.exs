defmodule CpMgmt.HostTest do
  use ExUnit.Case

  import Tesla.Mock

  setup do
    mock(fn
      %{
        method: :post,
        url: "http://example.com/web_api/add-host"
      } ->
        json(%{"name" => "test", "ip-address" => "10.1.1.1"})

      %{
        method: :post,
        url: "http://example.com/web_api/delete-host"
      } ->
        json(%{name: "test"})

      %{
        method: :post,
        url: "http://example.com/web_api/show-host"
      } ->
        json(%{name: "test"})

      %{
        method: :post,
        url: "http://example.com/web_api/publish"
      } ->
        json(%{})
    end)

    :ok
  end

  test "add host" do
    assert {:ok, resp} = CpMgmt.Host.add("test", "10.1.1.1")
    assert resp.status == 200
  end

  test "remove host" do
    assert {:ok, resp} = CpMgmt.Host.remove("test")
    assert resp.status == 200
  end

  test "show host" do
    assert {:ok, resp} = CpMgmt.Host.show("test")
    assert resp.status == 200
  end
end
