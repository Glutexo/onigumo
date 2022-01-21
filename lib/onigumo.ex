defmodule Onigumo do
  @moduledoc """
  Web scraper
  """
  @input_filename "urls.txt"
  @output_filename "body.html"

  def main() do
    HTTPoison.start()
    http = http_client()

    save_urls_contents(http, @input_filename, @output_filename)
  end

  def save_urls_contents(http, input_file, output_file) do
    load_urls(input_file)
    |> download(http, output_file)
  end

  def download(urls, http_client, output_file) when is_list(urls) do
    Enum.map(urls, &download(&1, http, output_file))
  end

  def download(url, http_client, output_file) do
    %HTTPoison.Response{
      status_code: 200,
      body: body
    } = http_client.get!(url)
    IO.puts(body)

    File.write!(output_file, body, [:append])
  end

  def load_urls(filepath) do
    File.stream!(filepath, [:read], :line)
    |> Enum.map(&String.trim_trailing/1)
  end

  defp http_client() do
    Application.get_env(:onigumo, :http_client)
  end
end
