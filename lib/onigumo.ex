defmodule Onigumo do
  @moduledoc """
  Web scraper
  """
  @input_filename "urls.txt"
  @output_filename "body.html"

  def main() do
    HTTPoison.start()
    http = http_client()

    load_urls(@input_filename)
    |> Enum.with_index()
    |> Enum.map(fn {url, index} ->
      download(http, url, index)
    end)
  end

  def download(http_client, url, index) do
    %HTTPoison.Response{
      status_code: 200,
      body: body
    } = http_client.get!(url)

    filename = "#{index}_#{@output_filename}"
    File.write!(filename, body)
  end

  def load_urls(filepath) do
    File.stream!(filepath, [:read], :line)
    |> Enum.map(&String.trim_trailing/1)
  end

  defp http_client() do
    Application.get_env(:onigumo, :http_client)
  end
end
