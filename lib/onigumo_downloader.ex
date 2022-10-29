defmodule Onigumo.Downloader do
  @moduledoc """
  Web scraper
  """

  def download(root_path) do
    root_path
    |> load_urls()
    |> Stream.map(&download(&1, root_path))
    |> Stream.run()
  end

  def download(url, root_path) do
    file_name = create_file_name(url)
    file_path = Path.join(root_path, file_name)

    url
    |> get_url()
    |> get_body()
    |> write_response(file_path)
  end

  def get_url(url) do
    http_client().start()
    http_client().get!(url)
  end

  def get_body(%HTTPoison.Response{
        status_code: 200,
        body: body
      }) do
    body
  end

  def write_response(response, file_path) do
    File.write!(file_path, response)
  end

  def load_urls(dir_path) do
    input_path = Application.get_env(:onigumo, :input_path)

    Path.join(dir_path, input_path)
    |> File.stream!([:read], :line)
    |> Stream.map(&String.trim_trailing/1)
  end

  def create_file_name(url) do
    Hash.md5(url, :hex)
  end

  defp http_client() do
    Application.get_env(:onigumo, :http_client)
  end
end
