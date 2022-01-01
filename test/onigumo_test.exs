defmodule OnigumoTest do
  use ExUnit.Case
  import Mox
  
  @filename "body.html"

  setup :verify_on_exit!

  test "download" do
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
end
