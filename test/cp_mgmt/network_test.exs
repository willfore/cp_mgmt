defmodule CpMgmt.NetworkTest do
  use ExUnit.Case

  import Tesla.Mock

  setup do
    mock(fn
      %{
        method: :post,
        url: "http://example.com/web_api/add-network"
      } ->
        json(%{name: "test", subnet: "10.0.0.0", "subnet-mask": "255.255.255.0"})

      %{
        method: :post,
        url: "http://example.com/web_api/delete-network"
      } ->
        json(%{name: "test"})

      %{
        method: :post,
        url: "http://example.com/web_api/show-network"
      } ->
        json(%{name: "test"})

      %{
        method: :post,
        url: "http://example.com/web_api/show-networks"
      } ->
        json(%{})

      %{
        method: :post,
        url: "http://example.com/web_api/publish"
      } ->
        json(%{})
    end)

    :ok
  end

  test "add network" do
    assert {:ok, resp} = CpMgmt.Network.add("test", "10.0.0.0", "255.255.255.0")
    assert resp.status == 200
  end

  test "remove network" do
    assert {:ok, resp} = CpMgmt.Network.remove("test")
    assert resp.status == 200
  end

  test "show network" do
    assert {:ok, resp} = CpMgmt.Network.show("test")
    assert resp.status == 200
  end

  test "show all networks" do
    assert {:ok, resp} = CpMgmt.Network.show_all()
    assert resp.status == 200
  end
end
