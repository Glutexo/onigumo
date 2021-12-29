defmodule Onigumo do
  @moduledoc """
  Web scraper
  """
  @url "https://www.httpbin.org/html"
  @filename "body.html"

  def download() do
    HTTPoison.start()

    %HTTPoison.Response{
      status_code: 200,
      body: body,
    } = HTTPoison.get!(@url)
    File.write!(@filename, body)
  end
end
