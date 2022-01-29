defmodule Onigumo do
  @moduledoc """
  Web scraper
  """
  @input_path "urls.txt"
  @output_path "body.html"

  def main() do
    HTTPoison.start()
    http_client = Application.get_env(:onigumo, :http_client)

    load_urls(@input_path)
    |> Enum.map(&download(&1, http_client, @output_path))
  end

  def download(url, http_client, path) do
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
