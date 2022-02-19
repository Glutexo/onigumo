defmodule Onigumo do
  @moduledoc """
  Web scraper
  """
  @output_file_name "body.html"

  def main() do
    http_client = Application.get_env(:onigumo, :http_client)
    http_client.start()

    dir_path = File.cwd!()
    Application.get_env(:onigumo, :input_path)
    |> download_urls_from_file(http_client, dir_path)
    |> Stream.run()
  end

  def download_urls_from_file(input_path, http_client, dir_path) do
    file_path = Path.join(dir_path, @output_file_name)
    input_path
    |> load_urls()
    |> Stream.map(&download_url(&1, http_client, file_path))
  end

  def download_url(url, http_client, file_path) do
    url
    |> get_url(http_client)
    |> get_body()
    |> write_response(file_path)    
  end

  def get_url(url, http_client) do
    http_client.get!(url)
  end

  def get_body(
    %HTTPoison.Response{
      status_code: 200,
      body: body
    }
  ) do
    body
  end

  def write_response(response, file_path) do
    File.write!(file_path, response)
  end

  def load_urls(path) do
    File.stream!(path, [:read], :line)
    |> Stream.map(&String.trim_trailing/1)
  end
end
