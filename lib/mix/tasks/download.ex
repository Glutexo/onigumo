defmodule Mix.Tasks.Download do
  use Mix.Task

  def run(_) do
    HTTPoison.start()
    %HTTPoison.Response{
      status_code: 200,
      body: body,
    } = HTTPoison.get!(
      "https://www.httpbin.org/html"
    )
    IO.puts("Got milk: #{body}")
  end
end
