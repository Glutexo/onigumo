defmodule Onigumo do
  @moduledoc """
  Web scraper
  """
  @input_filename "urls.txt"
  def input_filename, do: @input_filename
  @output_filename "body.html"
  def output_filename, do: @output_filename

  def main() do
    HTTPoison.start()
    save_URLs_contents(@input_filename, @output_filename)

  end

  def save_URLs_contents(input_file, output_file) do
    http = http_client()

    load_urls(input_file)
    |> Enum.map(&download(http, &1, output_file))
  end

  def download(http_client, url, output_file) do
    %HTTPoison.Response{
      status_code: 200,
      body: body
    } = http_client.get!(url)

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
