defmodule HttpSupport do
  def prepare_response(url) do
    %HTTPoison.Response{
      status_code: 200,
      body: body(url)
    }
  end

  def body(url) do
    "Body from: #{url}\n"
  end
end
