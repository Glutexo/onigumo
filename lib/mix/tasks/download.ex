defmodule Mix.Tasks.Download do
  use Mix.Task

  @url "https://www.httpbin.org/html"

  def run(_) do
    HTTPoison.start()
    %HTTPoison.Response{
      status_code: 200,
      body: body,
    } = HTTPoison.get!(@url)
    IO.puts("Got milk: #{body}")
  end
end
