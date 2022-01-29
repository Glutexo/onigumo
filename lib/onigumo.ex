defmodule Onigumo do
  @moduledoc """
  Web scraper
  """
  @input_path "urls.txt"
  @output_path "body.html"

  def main() do
    HTTPoison.start()
    http = http_client()

    load_urls(@input_path)
    |> Enum.with_index()
    |> Enum.map(fn {url, index} ->
      path = "{index}_#{@output_path}"
      download(url, http, path)
    end)
  end

  def download(url, http, path) do
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
