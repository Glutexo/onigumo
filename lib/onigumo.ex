defmodule Onigumo do
  @moduledoc """
  Web scraper
  """
  @url "https://www.httpbin.org/html"
  @filename "body.html"

  def download() do
    HTTPoison.start()
    http = http_client()

    %HTTPoison.Response{
      status_code: 200,
      body: body,
    } = http.get!(@url)
    File.write!(@filename, body)
  end

  defp http_client() do
    Application.get_env(:onigumo, :http_client, HTTPoison)
  end
end
