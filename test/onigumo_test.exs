defmodule OnigumoTest do
  use ExUnit.Case
  import Mox

  @urls [
    "http://onigumo.local/hello.html",
    "http://onigumo.local/bye.html"
  ]
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

    env_path = Application.get_env(:onigumo, :input_path)
    input_path = Path.join(tmp_dir, env_path)
    content = Enum.map(@urls, &(&1 <> "\n")) |> Enum.join()
    File.write!(input_path, content)

    output_path = Path.join(tmp_dir, @output_path)
    responses = Enum.map(@urls, fn _ -> :ok end)
    result = Onigumo.download(@urls, HTTPoisonMock, output_path)
    assert(result == responses)

    last_url = Enum.at(@urls, -1)
    read_content = File.read!(output_path)
    expected_content = body(last_url)
    assert(read_content == expected_content)
  end

  @tag :tmp_dir
  test("load a single URL from a file", %{tmp_dir: tmp_dir}) do
    url = Enum.at(@urls, 0)

    env_path = Application.get_env(:onigumo, :input_path)
    tmp_path = Path.join(tmp_dir, env_path)
    content = url <> "\n"
    File.write!(tmp_path, content)

    urls = Onigumo.load_urls(tmp_path)
    assert(urls == [url])
  end

  @tag :tmp_dir
  test("load multiple URLs from a file", %{tmp_dir: tmp_dir}) do
    env_path = Application.get_env(:onigumo, :input_path)
    tmp_path = Path.join(tmp_dir, env_path)
    content = Enum.map(@urls, &(&1 <> "\n")) |> Enum.join()
    File.write!(tmp_path, content)

    urls = Onigumo.load_urls(tmp_path)
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
