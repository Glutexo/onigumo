defmodule Onigumo do
  @moduledoc """
  Web scraper
  """
  @output_file_name "body.html"

  def main() do
    http_client().start()

    root_path = File.cwd!()
    download_urls_from_file(root_path)
    |> Stream.run()
  end

  def download_urls_from_file(root_path) do
    file_path = Path.join(root_path, @output_file_name)

    root_path
    |> load_urls()
    |> Stream.map(&download_url(&1, file_path))
  end

  def download_url(url, file_path) do
    url
    |> get_url()
    |> get_body()
    |> write_response(file_path)
  end

  def get_url(url) do
    http_client().get!(url)
  end

  def get_body(%HTTPoison.Response{
        status_code: 200,
        body: body
      }) do
    body
  end

  def write_response(response, file_path) do
    File.write!(file_path, response)
  end

  def load_urls(dir_path) do
    input_path = Application.get_env(:onigumo, :input_path)
    Path.join(dir_path, input_path)
    |> File.stream!([:read], :line)
    |> Stream.map(&String.trim_trailing/1)
  end

  defp http_client() do
    Application.get_env(:onigumo, :http_client)
  end
end
