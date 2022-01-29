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
    assert(:ok == Onigumo.download(url, HTTPoisonMock, path))
    assert("Body from: #{url}\n" == File.read!(path))
  end


  @tag :tmp_dir
  test("load a single URL form a file", %{tmp_dir: tmp_dir}) do
    url = Enum.at(@urls, 0)

    path = Path.join(tmp_dir, @input_path)
    content = url <> "\n"
    File.write!(path, content)

    expected = [url]
    assert(expected == Onigumo.load_urls(path))
  end

  @tag :tmp_dir
  test("load multiple URLs from a file", %{tmp_dir: tmp_dir}) do
    path = Path.join(tmp_dir, @input_path)
    content = Enum.map(@urls, &(&1 <> "\n")) |> Enum.join()
    File.write!(path, content)

    assert(@urls == Onigumo.load_urls(path))
  end
  
  defp get!(url) do
    %HTTPoison.Response{
      status_code: 200,
      body: "Body from: #{url}\n"
    }
  end
end
