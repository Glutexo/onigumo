defmodule Onigumo do
  @moduledoc """
  Web scraper
  """
  @input_filename "urls.txt"
  @output_filename "body.html"

  def main() do
    HTTPoison.start()
    http = http_client()

    save_urls_contents(http)
  end

  def save_urls_contents(http) do
    load_urls(@input_filename)
    |> download(http)
  end

  def download(urls, http_client) when is_list(urls) do
    Enum.map(urls, &download(&1, http_client))
  end

  def download(url, http_client) do
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
