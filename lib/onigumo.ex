defmodule Onigumo do
  @moduledoc """
  Web scraper
  """
  @input_path "urls.txt"

  def main() do
    http = http_client()
    http.start()

    load_urls(@input_path)
    |> Enum.map(&download(&1, http, hash(&1)))
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

  def hash(url) do
    Hash.md5(url, :hex)
  end

  defp http_client() do
    Application.get_env(:onigumo, :http_client)
  end
end
