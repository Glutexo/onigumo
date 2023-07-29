defmodule InputSupport do
  def url_list(urls) do
    Enum.map(urls, &(&1 <> "\n"))
    |> Enum.join()
  end
end
