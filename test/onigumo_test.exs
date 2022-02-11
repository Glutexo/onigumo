defmodule OnigumoTest do
  use ExUnit.Case
  import Mox

  @urls [
    "http://onigumo.local/hello.html",
    "http://onigumo.local/bye.html"
  ]

  setup(:verify_on_exit!)

  @tag :tmp_dir
  test("download a single URL", %{tmp_dir: tmp_dir}) do
    expect(HTTPoisonMock, :get!, &get!/1)

    index = 0
    url = Enum.at(@urls, index)
    output_file_name = Integer.to_string(index)
    output_file_path = Path.join(tmp_dir, output_file_name)
    result = Onigumo.download(url, HTTPoisonMock, output_file_path)
    assert(result == :ok)

    read_content = File.read!(output_file_path)
    expected_content = body(url)
    assert(read_content == expected_content)
  end

  @tag :tmp_dir
  test("download multiple URLs", %{tmp_dir: tmp_dir}) do
    expect(HTTPoisonMock, :get!, length(@urls), &get!/1)

    result = Onigumo.download(@urls, HTTPoisonMock, tmp_dir)
    responses = Enum.map(@urls, fn _ -> :ok end)
    assert(result == responses)

    for {url, index} <- Enum.with_index(@urls) do
      output_file_name = Integer.to_string(index)
      output_file_path = Path.join(tmp_dir, output_file_name)
      read_content = File.read!(output_file_path)
      expected_content = body(url)
      assert(read_content == expected_content)
    end
  end

  @tag :tmp_dir
  test("download URLs from the input file", %{tmp_dir: tmp_dir}) do
    expect(HTTPoisonMock, :get!, length(@urls), &get!/1)

    env_path = Application.get_env(:onigumo, :input_path)
    input_path = Path.join(tmp_dir, env_path)
    content = Enum.map(@urls, &(&1 <> "\n")) |> Enum.join()
    File.write!(input_path, content)

    result = Onigumo.download(@urls, HTTPoisonMock, tmp_dir)
    responses = Enum.map(@urls, fn _ -> :ok end)
    assert(result == responses)

    for {url, index} <- Enum.with_index(@urls) do
      file_name = Integer.to_string(index)
      output_path = Path.join(tmp_dir, file_name)
      read_content = File.read!(output_path)
      expected_content = body(url)
      assert(read_content == expected_content)
    end
  end

  @tag :tmp_dir
  test("load a single URL from a file", %{tmp_dir: tmp_dir}) do
    input_urls = Enum.slice(@urls, 0, 1)

    env_path = Application.get_env(:onigumo, :input_path)
    tmp_path = Path.join(tmp_dir, env_path)
    content = prepare_input(input_urls)
    File.write!(tmp_path, content)

    loaded_urls = Onigumo.load_urls(tmp_path)
    assert(loaded_urls == input_urls)
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

  defp prepare_input(urls) do
    Enum.map(urls, &(&1 <> "\n"))
    |> Enum.join()
  end

  defp body(url) do
    "Body from: #{url}\n"
  end
end
