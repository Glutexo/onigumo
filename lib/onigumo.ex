defmodule Onigumo do
  @moduledoc """
  Web scraper
  """
  @output_filename "body.html"

  def main() do
    HTTPoison.start()
    http = http_client()

    Application.get_env(:onigumo, :input_filename)
    |> load_urls()
    |> Enum.map(&download(http, &1))
  end

  def download(http_client, url) do
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
