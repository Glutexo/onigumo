defmodule Onigumo do
  @moduledoc """
  Web scraper
  """
  @input_filename "urls.txt"

  def main() do
    HTTPoison.start()
    http = http_client()

    load_urls(@input_filename)
    |> Enum.map(&download(http, &1))
  end

  def download(http_client, url) do
    %HTTPoison.Response{
      status_code: 200,
      body: body
    } = http_client.get!(url)

    filename(url)
    |> File.write!(body)
  end

  def load_urls(filepath) do
    File.stream!(filepath, [:read], :line)
    |> Enum.map(&String.trim_trailing/1)
  end

  def filename(url) do
    Hash.md5(url, :hex)
  end

  defp http_client() do
    Application.get_env(:onigumo, :http_client)
  end
end
