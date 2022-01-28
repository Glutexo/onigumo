defmodule OnigumoTest do
  use ExUnit.Case
  import Mox

  @url "http://onigumo.org/hello.html"
  @input_path "urls.txt"
  @output_path "body.html"

  setup(:verify_on_exit!)

  test("download") do
    expect(
      HTTPoisonMock,
      :get!,
      fn url ->
        %HTTPoison.Response{
          status_code: 200,
          body: "Body from: #{url}\n"
        }
      end
    )

    assert(:ok == Onigumo.download(@url, HTTPoisonMock))
    assert("Body from: #{@url}\n" == File.read!(@output_path))
  end


  @tag :tmp_dir
  test("load URL from file", %{tmp_dir: tmp_dir}) do
    path = Path.join(tmp_dir, @input_path)
    content = @url <> "\n"
    File.write!(path, content)

    expected = [@url]
    assert(expected == Onigumo.load_urls(path))
  end

end
