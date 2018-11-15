defmodule CpMgmt.AccessLayerTest do
  use ExUnit.Case

  import Tesla.Mock

  setup do
    mock(fn
      %{
        method: :post,
        url: "http://example.com/web_api/add-access-layer"
      } ->
        json(%{name: "test-layer"})

      %{
        method: :post,
        url: "http://example.com/web_api/show-access-layer"
      } ->
        json(%{name: "test-layer"})

      %{
        method: :post,
        url: "http://example.com/web_api/delete-access-layer"
      } ->
        json(%{name: "test-layer"})

      %{
        method: :post,
        url: "http://example.com/web_api/show-access-layers"
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

  test "add access layer" do
    assert {:ok, resp} = CpMgmt.AccessLayer.add(%{name: "test-layer"})
    assert resp.status == 200
  end

  test "show access layer" do
    assert {:ok, resp} = CpMgmt.AccessLayer.show(%{name: "test-layer"})
    assert resp.status == 200
  end

  test "remove access layer" do
    assert {:ok, resp} = CpMgmt.AccessLayer.remove(%{name: "test-layer"})
    assert resp.status == 200
  end

  test "show access layers" do
    assert {:ok, resp} = CpMgmt.AccessLayer.show_all()
    assert resp.status == 200
  end
end
