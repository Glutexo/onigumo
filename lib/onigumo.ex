defmodule Onigumo do
  @moduledoc """
  Web scraper
  """
  @input_filename "urls.txt"
  @output_filename "body.html"

  def main() do
    HTTPoison.start()
    http = http_client()

    download(http)
  end

  def download(http_client) do
    urls = load_urls(@input_filename)
    download(http_client, urls)
  end

  def download(http_client, urls) when is_list(urls) do
    Enum.map(urls, &download(http_client, &1))
  end

  def download(http_client, url) when is_binary(url) do
    %HTTPoison.Response{
      status_code: 200,
      body: body
    } = http_client.get!(url)

    File.write!(@output_filename, body)
  end

  def load_urls(filepath) do
    File.stream!(filepath, [:read], :line)
    |> Enum.map(&String.trim_trailing/1)
  end

  defp http_client() do
    Application.get_env(:onigumo, :http_client)
  end
end
