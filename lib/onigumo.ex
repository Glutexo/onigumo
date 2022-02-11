defmodule Onigumo do
  @moduledoc """
  Web scraper
  """
  @output_file_name "body.html"

  def main() do
    http_client = Application.get_env(:onigumo, :http_client)
    http_client.start()

    download(http_client)
  end

  def download(http_client, dir_path \\ nil)

  def download(http_client, nil) do
    dir_path = File.cwd!()
    download(http_client, dir_path)
  end

  def download(http_client, dir_path) do
    Application.get_env(:onigumo, :input_path)
    |> load_urls()
    |> download(http_client, dir_path)
  end

  def download(urls, http_client, dir_path) when is_list(urls) do
    file_path = Path.join(dir_path, @output_file_name)
    Enum.map(urls, &download(&1, http_client, file_path))
  end

  def download(url, http_client, file_path) when is_binary(url) do
    %HTTPoison.Response{
      status_code: 200,
      body: body
    } = http_client.get!(url)

    File.write!(file_path, body)
  end

  def load_urls(path) do
    File.stream!(path, [:read], :line)
    |> Enum.map(&String.trim_trailing/1)
  end
end
