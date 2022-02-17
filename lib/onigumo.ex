defmodule Onigumo do
  @moduledoc """
  Web scraper
  """
  def main() do
    http_client = Application.get_env(:onigumo, :http_client)
    http_client.start()

    dir_path = File.cwd!()
    Application.get_env(:onigumo, :input_path)
    |> download_urls_from_file(http_client, dir_path)
  end

  def download_urls_from_file(input_path, http_client, dir_path) do
    input_path
    |> load_urls()
    |> download_urls(http_client, dir_path)
  end

  def download_urls(urls, http_client, dir_path) when is_list(urls) do
    for {url, index} <- Enum.with_index(urls) do
      file_name = Integer.to_string(index)
      file_path = Path.join(dir_path, file_name)
      download_url(url, http_client, file_path)
    end
  end

  def download_url(url, http_client, file_path) do
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
