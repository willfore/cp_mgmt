defmodule CpMgmtTest do
  use ExUnit.Case
  doctest CpMgmt

  test "greets the world" do
    assert CpMgmt.hello() == :world
  end
end
