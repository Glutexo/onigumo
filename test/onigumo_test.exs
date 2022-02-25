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

    input_url = Enum.at(@urls, 0)
    output_path = Path.join(tmp_dir, "body.html")
    download_result = Onigumo.download_url(
      input_url, HTTPoisonMock, output_path
    )
    assert(download_result == :ok)

    read_output = File.read!(output_path)
    expected_output = body(input_url)
    assert(read_output == expected_output)
  end

  @tag :tmp_dir
  test("download multiple URLs", %{tmp_dir: tmp_dir}) do
    expect(HTTPoisonMock, :get!, length(@urls), &get!/1)

    download_result = Onigumo.download_urls(
      @urls, HTTPoisonMock, tmp_dir
    )
    expected_responses = Enum.map(@urls, fn _ -> :ok end)
    assert(download_result == expected_responses)

    Enum.map(@urls, &assert_downloaded(&1, tmp_dir))
  end

  @tag :tmp_dir
  test("download URLs from the input file", %{tmp_dir: tmp_dir}) do
    expect(HTTPoisonMock, :get!, length(@urls), &get!/1)

    input_path_env = Application.get_env(:onigumo, :input_path)
    input_path_tmp = Path.join(tmp_dir, input_path_env)
    input_file_content = @urls
    |> Enum.map(&(&1 <> "\n"))
    |> Enum.join()
    File.write!(input_path_tmp, input_file_content)

    download_result = Onigumo.download_urls_from_file(
      input_path_tmp, HTTPoisonMock, tmp_dir
    )
    expected_responses = Enum.map(@urls, fn _ -> :ok end)
    assert(download_result == expected_responses)

    Enum.map(@urls, &assert_downloaded(&1, tmp_dir))
  end

  @tag :tmp_dir
  test("load a single URL from a file", %{tmp_dir: tmp_dir}) do
    input_urls = Enum.slice(@urls, 0, 1)

    input_path_env = Application.get_env(:onigumo, :input_path)
    input_path_tmp = Path.join(tmp_dir, input_path_env)
    input_file_content = prepare_input(input_urls)
    File.write!(input_path_tmp, input_file_content)

    loaded_urls = Onigumo.load_urls(input_path_tmp)
    assert(loaded_urls == input_urls)
  end

  @tag :tmp_dir
  test("load multiple URLs from a file", %{tmp_dir: tmp_dir}) do
    input_path_env = Application.get_env(:onigumo, :input_path)
    input_path_tmp = Path.join(tmp_dir, input_path_env)
    input_file_content = prepare_input(@urls)
    File.write!(input_path_tmp, input_file_content)

    loaded_urls = Onigumo.load_urls(input_path_tmp)
    assert(loaded_urls == @urls)
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

  defp assert_downloaded(url, tmp_dir) do
    filename = Base.url_encode64(url, padding: false)
    output_path = Path.join(tmp_dir, filename)
    read_output = File.read!(output_path)
    expected_output = body(url)
    assert(read_output == expected_output)
  end
end
