defmodule CpMgmt.AccessRuleTest do
  use ExUnit.Case

  import Tesla.Mock

  setup do
    mock(fn
      %{
        method: :post,
        url: "http://example.com/web_api/add-access-rule"
      } ->
        json(%{layer: 1, position: 2})

      %{
        method: :post,
        url: "http://example.com/web_api/delete-access-rule"
      } ->
        json(%{})

      %{
        method: :post,
        url: "http://example.com/web_api/show-access-rule"
      } ->
        json(%{})

      %{
        method: :post,
        url: "http://example.com/web_api/show-access-rulebase"
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

  test "adds access rule" do
    assert {:ok, resp} = CpMgmt.AccessRule.add(1, 2)
    assert resp.status == 200
  end

  test "removes access rule" do
    assert {:ok, resp} = CpMgmt.AccessRule.remove(1, "some-layer")
    assert resp.status == 200
  end

  test "shows access rule" do
    assert {:ok, resp} = CpMgmt.AccessRule.show(5, "some-layer")
    assert resp.status == 200
  end

  test "shows all access rulebase" do
    assert {:ok, resp} = CpMgmt.AccessRule.show_rulebase("some-layer")
    assert resp.status == 200
  end
end
