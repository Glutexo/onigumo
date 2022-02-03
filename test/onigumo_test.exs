defmodule OnigumoTest do
  use ExUnit.Case
  import Mox

  @urls [
    "http://onigumo.org/hello.html",
    "http://onigumo.org/bye.html"
  ]
  @input_path "urls.txt"
  @output_path "body.html"

  setup(:verify_on_exit!)

  @tag :tmp_dir
  test("download", %{tmp_dir: tmp_dir}) do
    expect(HTTPoisonMock, :get!, &get!/1)

    url = Enum.at(@urls, 0)
    path = Path.join(tmp_dir, @output_path)
    result = Onigumo.download(url, HTTPoisonMock, path)
    assert(result == :ok)

    read_content = File.read!(path)
    expected_content = body(url)
    assert(read_content == expected_content)
  end

  @tag :tmp_dir
  test("load a single URL from a file", %{tmp_dir: tmp_dir}) do
    url = Enum.at(@urls, 0)

    path = Path.join(tmp_dir, @input_path)
    content = url <> "\n"
    File.write!(path, content)

    urls = Onigumo.load_urls(path)
    assert(urls == [url])
  end

  @tag :tmp_dir
  test("load multiple URLs from a file", %{tmp_dir: tmp_dir}) do
    path = Path.join(tmp_dir, @input_path)
    content = Enum.map(@urls, &(&1 <> "\n")) |> Enum.join()
    File.write!(path, content)

    urls = Onigumo.load_urls(path)
    assert(urls == @urls)
  end

  defp get!(url) do
    %HTTPoison.Response{
      status_code: 200,
      body: body(url)
    }
  end

  defp body(url) do
    "Body from: #{url}\n"
  end
end
