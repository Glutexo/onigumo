defmodule Mix.Tasks.Download do
  use Mix.Task

  @url "https://www.httpbin.org/html"
  @filename "body.html"

  def run(_) do
    HTTPoison.start()
    
    %HTTPoison.Response{
      status_code: 200,
      body: body,
    } = HTTPoison.get!(@url)
    File.write!(@filename, body) 
  end
end
