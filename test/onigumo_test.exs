defmodule OnigumoTest do
  use ExUnit.Case
  import Mox
  
  doctest Onigumo

  @filename "body.html"

  setup :verify_on_exit!

  test "download process" do
  #   assert :ok = Onigumo.download()
  #   assert File.exists?(@filename)
  end

  test "make request" do
    expect(
      HTTPoisonMock,
      :get!,
      fn _url ->
        %HTTPoison.Response{
          status_code: 200,
          body: "hello\n",
        }
      end
    )
    assert :ok = Onigumo.download()
    assert "hello\n" = File.read!(@filename)
  end

  test "downloads stuff" do
#    assert :ok = Onigumo.download()
#    assert "hello" = File.read!(@filename)
  end
end
