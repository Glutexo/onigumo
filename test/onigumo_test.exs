defmodule OnigumoTest do
  use ExUnit.Case
  doctest Onigumo

  test "greets the world" do
    assert Onigumo.hello() == :world
  end
end
