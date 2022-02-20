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
  test("download a URL", %{tmp_dir: tmp_dir}) do
    expect(HTTPoisonMock, :get!, &prepare_response/1)

    input_url = Enum.at(@urls, 0)
    output_path = Path.join(tmp_dir, @output_path)
    download_result = Onigumo.download_url(input_url, output_path)
    assert(download_result == :ok)

    read_output = File.read!(output_path)
    expected_output = body(input_url)
    assert(read_output == expected_output)
  end

  @tag :tmp_dir
  test("download URLs from the input file", %{tmp_dir: tmp_dir}) do
    expect(HTTPoisonMock, :get!, length(@urls), &prepare_response/1)

    input_path_env = Application.get_env(:onigumo, :input_path)
    input_path_tmp = Path.join(tmp_dir, input_path_env)
    input_file_content = prepare_input(@urls)
    File.write!(input_path_tmp, input_file_content)

    Onigumo.download_urls_from_file(input_path_tmp, tmp_dir)
    |> Stream.run()

    output_path = Path.join(tmp_dir, @output_path)
    read_output = File.read!(output_path)
    last_url = Enum.at(@urls, -1)
    expected_output = body(last_url)
    assert(read_output == expected_output)
  end

  @tag :tmp_dir
  test("load a single URL from a file", %{tmp_dir: tmp_dir}) do
    input_urls = Enum.slice(@urls, 0, 1)

    input_path_env = Application.get_env(:onigumo, :input_path)
    input_path_tmp = Path.join(tmp_dir, input_path_env)
    input_file_content = prepare_input(input_urls)
    File.write!(input_path_tmp, input_file_content)

    loaded_urls = Onigumo.load_urls(input_path_tmp) |> Enum.to_list()
    assert(loaded_urls == input_urls)
  end

  @tag :tmp_dir
  test("load multiple URLs from a file", %{tmp_dir: tmp_dir}) do
    input_path_env = Application.get_env(:onigumo, :input_path)
    input_path_tmp = Path.join(tmp_dir, input_path_env)
    input_file_content = prepare_input(@urls)
    File.write!(input_path_tmp, input_file_content)

    loaded_urls = Onigumo.load_urls(input_path_tmp) |> Enum.to_list()
    assert(loaded_urls == @urls)
  end

  test("get response by HTTP request") do
    expect(HTTPoisonMock, :get!, &prepare_response/1)

    url = Enum.at(@urls, 0)
    get_response = Onigumo.get_url(url)
    expected_response = prepare_response(url)
    assert(get_response == expected_response)
  end

  test("extract body from URL response") do
    url = Enum.at(@urls, 0)
    response = prepare_response(url)
    get_body = Onigumo.get_body(response)
    expected_body = body(url)
    assert(get_body == expected_body)
  end

  @tag :tmp_dir
  test("write response to file", %{tmp_dir: tmp_dir}) do
    response = "Response!"
    output_path = Path.join(tmp_dir, @output_path)
    Onigumo.write_response(response, output_path)

    read_output = File.read!(output_path)
    assert(read_output == response)
  end

  defp prepare_response(url) do
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
