defmodule Onigumo do
  @moduledoc """
  Web scraper
  """
  @output_path "body.html"

  def main() do
    http_client = Application.get_env(:onigumo, :http_client)
    http_client.start()

    Application.get_env(:onigumo, :input_path)
    |> download_urls(http_client, @output_path)
  end

  def download_urls(input_path, http_client, output_path) do
    input_path
    |> load_urls()
    |> Enum.map(&download_url(&1, http_client, output_path))
  end

  def download_url(url, http_client, path) do
    %HTTPoison.Response{
      status_code: 200,
      body: body
    } = http_client.get!(url)

    File.write!(path, body)
  end

  def load_urls(path) do
    File.stream!(path, [:read], :line)
    |> Enum.map(&String.trim_trailing/1)
  end
end
