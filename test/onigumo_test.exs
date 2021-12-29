defmodule OnigumoTest do
  use ExUnit.Case
  doctest Onigumo

  test "download process" do

    assert :ok = Onigumo.download()
    assert File.exists?("body.html")
  end
end
