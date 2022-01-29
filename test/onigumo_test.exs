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
    assert(:ok == Onigumo.download(url, HTTPoisonMock, path))
    assert("Body from: #{url}\n" == File.read!(path))
  end

  @tag :tmp_dir
  test("download multiple URLs", %{tmp_dir: tmp_dir}) do
    expect(HTTPoisonMock,:get!,length(@urls), &get!/1)

    path = Path.join(tmp_dir, @output_path)
    responses = Enum.map(@urls, fn _ -> :ok end)
    assert(responses == Onigumo.download(@urls, HTTPoisonMock, path))

    last_url = Enum.at(@urls, -1)
    assert("Body from: #{last_url}\n" == File.read!(path))
  end

  @tag :tmp_dir
  test("download URLs from the input file", %{tmp_dir: tmp_dir}) do
    expect(
      HTTPoisonMock,:get!,length(@urls), &get!/1)

    content = Enum.map(@urls, &(&1 <> "\n")) |> Enum.join()
    File.write!(@input_path, content)

    path = Path.join(tmp_dir, @output_path)
    responses = Enum.map(@urls, fn _ -> :ok end)
    assert(responses == Onigumo.download(HTTPoisonMock, path))

    last_url = Enum.at(@urls, -1)
    expected = "Body from: #{last_url}\n"
    assert(expected == File.read!(path))
  end

  @tag :tmp_dir
  test("load URL from file", %{tmp_dir: tmp_dir}) do
    url = Enum.at(@urls, 0)

    path = Path.join(tmp_dir, @input_path)
    content = url <> "\n"
    File.write!(path, content)

    expected = [url]
    assert(expected == Onigumo.load_urls(path))
  end

  defp get!(url) do
    %HTTPoison.Response{
      status_code: 200,
      body: "Body from: #{url}\n"
    }
  end
end
