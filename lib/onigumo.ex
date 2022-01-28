defmodule Onigumo do
  @moduledoc """
  Web scraper
  """
  @input_path "urls.txt"
  @output_path "body.html"

  def main() do
    HTTPoison.start()
    http = http_client()

    download(http, @output_path)
  end

  def download(http, path) do
    urls = load_urls(@input_path)
    download(urls, http, path)
  end

  def download(urls, http, path) when is_list(urls) do
    Enum.map(urls, &download(&1, http, path))
  end

  def download(url, http, path) when is_binary(url) do
    %HTTPoison.Response{
      status_code: 200,
      body: body
    } = http.get!(url)

    File.write!(path, body)
  end

  def load_urls(path) do
    File.stream!(path, [:read], :line)
    |> Enum.map(&String.trim_trailing/1)
  end

  defp http_client() do
    Application.get_env(:onigumo, :http_client)
  end
end
