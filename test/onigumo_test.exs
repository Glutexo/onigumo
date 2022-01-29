defmodule OnigumoTest do
  use ExUnit.Case
  import Mox

  @urls [
    "https://onigumo.org/hello.html",
    "https://onigumo.org/bye.html"
  ]

  @input_path "urls.txt"
  @output_path "body.html"

  setup(:verify_on_exit!)

  @tag :tmp_dir
  test("download a single URL", %{tmp_dir: tmp_dir}) do
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
  test("download multiple URLs", %{tmp_dir: tmp_dir}) do
    expect(HTTPoisonMock, :get!, length(@urls), &get!/1)

    path = Path.join(tmp_dir, @output_path)
    responses = Enum.map(@urls, fn _ -> :ok end)
    result = Onigumo.download(@urls, HTTPoisonMock, path)
    assert(result == responses)

    last_url = Enum.at(@urls, -1)
    read_content = File.read!(path)
    expected_content = body(last_url)
    assert(read_content == expected_content)
  end

  @tag :tmp_dir
  test("download URLs from the input file", %{tmp_dir: tmp_dir}) do
    expect(HTTPoisonMock, :get!, length(@urls), &get!/1)

    content = Enum.map(@urls, &(&1 <> "\n")) |> Enum.join()
    File.write!(@input_path, content)

    path = Path.join(tmp_dir, @output_path)
    responses = Enum.map(@urls, fn _ -> :ok end)
    result = Onigumo.download(@urls, HTTPoisonMock, path)
    assert(result == responses)

    last_url = Enum.at(@urls, -1)
    read_content = File.read!(path)
    expected_content = body(last_url)
    assert(read_content == expected_content)
  end

  @tag :tmp_dir
  test("load URL from file", %{tmp_dir: tmp_dir}) do
    url = Enum.at(@urls, 0)

    path = Path.join(tmp_dir, @input_path)
    content = url <> "\n"
    File.write!(path, content)

    urls = Onigumo.load_urls(path)
    assert(urls == [url])
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
