defmodule OnigumoDownloaderTest do
  use ExUnit.Case
  import Mox

  @urls [
    "http://onigumo.local/hello.html",
    "http://onigumo.local/bye.html"
  ]

  setup(:verify_on_exit!)

  describe("Onigumo.Downloader.main/1") do
    @tag :tmp_dir
    test("run the download", %{tmp_dir: tmp_dir}) do
      expect(HTTPoisonMock, :start, fn -> nil end)
      expect(HTTPoisonMock, :get!, length(@urls), &prepare_response/1)

      input_path_env = Application.get_env(:onigumo, :input_path)
      input_path_tmp = Path.join(tmp_dir, input_path_env)
      input_file_content = prepare_input(@urls)
      File.write!(input_path_tmp, input_file_content)

      stream_result = Onigumo.Downloader.main(tmp_dir)
      assert(stream_result == :ok)

      Enum.map(@urls, &assert_downloaded(&1, tmp_dir))
    end
  end

  describe("Onigumo.Downloader.download_urls_from_file/1") do
    @tag :tmp_dir
    test("download URLs from the input file", %{tmp_dir: tmp_dir}) do
      expect(HTTPoisonMock, :get!, length(@urls), &prepare_response/1)

      input_path_env = Application.get_env(:onigumo, :input_path)
      input_path_tmp = Path.join(tmp_dir, input_path_env)
      input_file_content = prepare_input(@urls)
      File.write!(input_path_tmp, input_file_content)

      Onigumo.Downloader.download_urls_from_file(tmp_dir) |> Stream.run()

      Enum.map(@urls, &assert_downloaded(&1, tmp_dir))
    end
  end

  describe("Onigumo.Downloader.download_url/2") do
    @tag :tmp_dir
    test("download a URL", %{tmp_dir: tmp_dir}) do
      expect(HTTPoisonMock, :get!, &prepare_response/1)

      input_url = Enum.at(@urls, 0)
      download_result = Onigumo.Downloader.download_url(input_url, tmp_dir)
      assert(download_result == :ok)

      output_file_name = Onigumo.Downloader.create_file_name(input_url)
      output_path = Path.join(tmp_dir, output_file_name)
      read_output = File.read!(output_path)
      expected_output = body(input_url)
      assert(read_output == expected_output)
    end
  end

  describe("Onigumo.Downloader.get_url/1") do
    test("get response by HTTP request") do
      expect(HTTPoisonMock, :get!, &prepare_response/1)

      url = Enum.at(@urls, 0)
      get_response = Onigumo.Downloader.get_url(url)
      expected_response = prepare_response(url)
      assert(get_response == expected_response)
    end
  end

  describe("Onigumo.Downloader.get_body/1") do
    test("extract body from URL response") do
      url = Enum.at(@urls, 0)
      response = prepare_response(url)
      get_body = Onigumo.Downloader.get_body(response)
      expected_body = body(url)
      assert(get_body == expected_body)
    end
  end

  describe("Onigumo.Downloader.write_response/2") do
    @tag :tmp_dir
    test("write response to file", %{tmp_dir: tmp_dir}) do
      response = "Response!"
      output_file_name = "body.html"
      output_path = Path.join(tmp_dir, output_file_name)
      Onigumo.Downloader.write_response(response, output_path)

      read_output = File.read!(output_path)
      assert(read_output == response)
    end
  end

  describe("Onigumo.Downloader.load_urls/1") do
    @tag :tmp_dir
    test("load a single URL from a file", %{tmp_dir: tmp_dir}) do
      input_urls = Enum.slice(@urls, 0, 1)

      input_path_env = Application.get_env(:onigumo, :input_path)
      input_path_tmp = Path.join(tmp_dir, input_path_env)
      input_file_content = prepare_input(input_urls)
      File.write!(input_path_tmp, input_file_content)

      loaded_urls = Onigumo.Downloader.load_urls(tmp_dir) |> Enum.to_list()
      assert(loaded_urls == input_urls)
    end

    @tag :tmp_dir
    test("load multiple URLs from a file", %{tmp_dir: tmp_dir}) do
      input_path_env = Application.get_env(:onigumo, :input_path)
      input_path_tmp = Path.join(tmp_dir, input_path_env)
      input_file_content = prepare_input(@urls)
      File.write!(input_path_tmp, input_file_content)

      loaded_urls = Onigumo.Downloader.load_urls(tmp_dir) |> Enum.to_list()
      assert(loaded_urls == @urls)
    end
  end

  describe("Onigumo.Downloader.create_file_name/1") do
    test("create file name from URL") do
      input_url = "https://onigumo.local/hello.html"
      created_file_name = Onigumo.Downloader.create_file_name(input_url)

      expected_file_name = Hash.md5(input_url, :hex)
      assert(created_file_name == expected_file_name)
    end
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

  defp assert_downloaded(url, tmp_dir) do
    file_name = Onigumo.Downloader.create_file_name(url)
    output_path = Path.join(tmp_dir, file_name)
    read_output = File.read!(output_path)
    expected_output = body(url)
    assert(read_output == expected_output)
  end
end
