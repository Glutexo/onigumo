defmodule OnigumoTest do
  use ExUnit.Case
  import Mox

  @url "http://onigumo.org/hello.html"
  @input_path "urls.txt"
  @output_path "body.html"

  setup(:verify_on_exit!)

  @tag :tmp_dir
  test("download", %{tmp_dir: tmp_dir}) do
    expect(HTTPoisonMock, :get!, &get!/1)

    path = Path.join(tmp_dir, @output_path)
    result = Onigumo.download(@url, HTTPoisonMock, path)
    assert(result == :ok)

    content = File.read!(path)
    assert(content == "Body from: #{@url}\n")
  end


  @tag :tmp_dir
  test("load URL from file", %{tmp_dir: tmp_dir}) do
    path = Path.join(tmp_dir, @input_path)
    content = @url <> "\n"
    File.write!(path, content)

    urls = Onigumo.load_urls(path)
    assert(urls == [@url])
  end

  defp get!(url) do
    %HTTPoison.Response{
      status_code: 200,
      body: "Body from: #{url}\n"
    }
  end
end
