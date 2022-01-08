defmodule OnigumoTest do
  use ExUnit.Case
  import Mox

  @url "http://onigumo.org/hello.html"
  @filename "body.html"

  setup(:verify_on_exit!)

  test("download") do
    expect(
      HTTPoisonMock,
      :get!,
      fn url ->
        %HTTPoison.Response{
          status_code: 200,
          body: "Body from: #{url}"
        }
      end
    )

    assert(:ok = Onigumo.download(HTTPoisonMock, @url))
    assert("Body from: #{@url}" = File.read!(@filename))
  end

end
